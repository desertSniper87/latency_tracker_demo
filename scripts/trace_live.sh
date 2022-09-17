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
kernel_events=(
    "sched_switch" 
    "sched_process_*" 
    #"lttng_statedump_*"
    "irq_*"
    "signal_*" 
    "workqueue_*"
    #"power_cpu_frequency"
    #"kmem_"{mm_page,cache}_{alloc,free} "block_rq_"{issue,complete,requeue}
    # "x86_exceptions_page_fault_"{user,kernel}
)

for event in "${kernel_events[@]}"; do
    lttng enable-event -c kernel -k "$event"
done

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
