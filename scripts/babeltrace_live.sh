#!/usr/bin/env bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


babeltrace2 --input-format=lttng-live net://localhost
babeltrace2 --input-format=lttng-live net://localhost/host/e203mah/kernel-tracing-session
