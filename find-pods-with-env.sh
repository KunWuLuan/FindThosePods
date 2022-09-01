#!/bin/bash
env_key=$1

for ns in $(kubectl get ns | sed '1d'| awk '{print $1}')
do
    if [ $ns = "kube-system" ]; then
        continue
    fi
    echo "enter namespace ${ns}"
    for podName in $(kubectl get po -n ${ns} 2>/dev/null| sed '1d'| awk '{print $1}')
    do
        env=$(kubectl exec ${podName} -n ${ns} -- env 2>/dev/null)
        # echo ${#env}
        if [ ${#env} -eq 0 ]; then
            continue
        fi
        res=$(echo "${env}" | sed -n "s/${env_key}=\\(.*\\)/\\1/p")
        if [ ${#res} != 0 ]; then
            echo "${env_key}:${res}, PodName:${podName}, Namespace:${ns}"
        fi
    done
done
