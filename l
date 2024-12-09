#!/bin/bash
pod=$1
word=$2

if [  !  $word ]
then 
  echo "cd logs && tail \$(ls | sort -r | head -n 1) -n 500 -f" > ${pod}.sh
else
  echo "cd logs && sed -n '/$word/,\$p' \$(ls | sort -r | head -n 1) | more" > ${pod}.sh
fi
kubectl cp -n dev ${pod}.sh $(kubectl -n dev get pod | grep ${pod} | awk '{print $1}'):tmp.sh
rm -f ${pod}.sh
kubectl exec -it $(kubectl -n dev get pod | grep ${pod} | awk '{print $1}') -n dev -- sh tmp.sh
