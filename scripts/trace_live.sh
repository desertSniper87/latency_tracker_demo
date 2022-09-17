#!/bin/bash

#lttng-sessiond --extra-kmod-probes=latency_tracker -d

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi
lttng-relayd
lttng create kernel-tracing-session --live 

lttng enable-channel k -k
lttng enable-event -c k -k syscall_latency
lttng enable-event -c k -k syscall_latency_stack
#lttng enable-event -c k -k workqueue_*

#lttng enable-channel u -u
#lttng enable-event -c u -u lttng_profile:off_cpu_sample
#lttng add-context -c u -u -t vtid

lttng start

#echo 'Starting relay daemon'

echo 'Press any key to stop tracing.'
read

lttng stop
lttng destroy
echo 'Stopped tracing.'
