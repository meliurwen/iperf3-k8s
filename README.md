# iperf3-k8s

Simple wrapper around iperf3 to measure network bandwidth from all nodes of a Kubernetes cluster.

## How to use

*Make sure you are using the correct cluster context before running this script: `kubectl config current-context`*

```sh
./iperf3.sh
```

Any options supported by iperf3 can be added, e.g.:

```sh
./iperf3.sh -t 2
```

### NetworkPolicies

If you need NetworkPolicies you can install it:

```sh
kubectl apply -f network-policy.yaml
```

And cleanup afterwards:

```sh
kubectl delete -f network-policy.yaml
```

## How it works

The script will run an iperf3 client inside a pod on every cluster node including the Kubernetes master.
Each iperf3 client will then sequentially run the same benchmark against the iperf3 server running on the Kubernetes master.

All required Kubernetes resources will be created and removed after the benchmark finished successfully.

The latest version of this Docker image is used to run iperf3:
[https://hub.docker.com/r/networkstatic/iperf3/](https://hub.docker.com/r/networkstatic/iperf3/)

Details on how to use iperf3 can be found here:
[https://github.com/esnet/iperf](https://github.com/esnet/iperf)

## Thanks

Thanks to [Pharb](https://github.com/Pharb) for the code. This is a repackaged version of his [project](https://github.com/Pharb/kubernetes-iperf3) adapted for my use cases.
