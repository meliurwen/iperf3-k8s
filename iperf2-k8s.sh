#!/usr/bin/env bash

set -eu

cd $(dirname $0)

## <setup>

kubectl create -f iperf2.yaml

until $(kubectl get pods -l app=iperf2-server -o jsonpath='{.items[0].status.containerStatuses[0].ready}'); do
    echo "Waiting for iperf server to start..."
    sleep 5
done

echo "Server is running"
echo

CLIENTS=$(kubectl get pods -l app=iperf2-client -o name | cut -d'/' -f2)

for POD in ${CLIENTS}; do
    until $(kubectl get pod "${POD}" -o jsonpath='{.status.containerStatuses[0].ready}'); do
        echo "Waiting for ${POD} to start..."
        sleep 5
    done
done

echo "All clients are running"
echo

kubectl get pod -o=custom-columns=NAME:.metadata.name,NODE:.spec.nodeName,IP-NODE:.status.hostIP,IP-POD:status.podIP

echo

## </setup>
## <run>

CLIENTS=$(kubectl get pods -l app=iperf2-client -o name | cut -d'/' -f2)

for POD in ${CLIENTS}; do
    HOST=$(kubectl get pod "${POD}" -o jsonpath='{.status.hostIP}')
    kubectl exec -it "${POD}" -- iperf -c iperf2-server -T "Client on ${HOST}" "$@"
    echo
done

## </run>
## <clean>

kubectl delete --cascade -f iperf2.yaml

## </clean>
