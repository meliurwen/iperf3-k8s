#!/usr/bin/env python3

import json
import sys
import argparse

def main(arguments):

    with open(arguments.source[0], 'r') as myfile:
        iperf_dict = json.loads(myfile.read())

    keys = ""
    for key, value in iperf_dict["intervals"][0]["sum"].items():
        keys = keys + "," + str(key)
    print(keys[1:])
    for interval in iperf_dict["intervals"]:
        values = ""
        for key, value in interval["sum"].items():
            values = values + "," + str(value)
        print(values[1:])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='iperf json2csv',
        usage='%(prog)s -s SOURCE [-h] [--version]',
        description='Converts json genereated from iperf into csv.'
    )
    parser.add_argument(
        "-s", "--source",
        nargs=1,
        required=True,
        help="source where getting the json"
    )
    args = parser.parse_args()
    main(args)
