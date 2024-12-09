#!/bin/bash
svc=$1
keyword=$2
function func() {
    local pod=$1
    echo "cd logs && grep -C 3 '$keyword'  \$(ls | sort -r | head -n 1) | tail -n 50" > ${pod}.sh
    kubectl cp -n dev ${pod}.sh $pod:f.sh
    rm -f ${pod}.sh
    kubectl exec -i $pod -n dev -- sh f.sh
}

podlist=$(kubectl -n dev get pod | grep $svc| awk '{print $1}')
echo $podlist
for pod in ${podlist[*]}
do
echo -e "\n\n\n\033[44;37m $pod \033[0m"
func $pod
done
