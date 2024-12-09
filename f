#!/bin/bash

# Help information
usage() {
    echo "Usage: f <service> [options] <pattern>"
    echo "Options:"
    echo "  -n, --namespace <namespace>  Specify namespace (default: dev)"
    echo "  -c, --container <container>  Specify container name"
    echo "  -p, --path <path>           Specify log path inside container (default: stdout)"
    echo "  -t, --tail <lines>          Show last N lines (default: 50)"
    echo "  -C, --context <lines>       Show N lines of context (default: 3)"
    exit 1
}

# Parameter parsing
service=""
namespace="dev"
container=""
log_path=""
pattern=""
tail_lines="50"
context_lines="3"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -n|--namespace)
            namespace="$2"
            shift 2
            ;;
        -c|--container)
            container="$2"
            shift 2
            ;;
        -p|--path)
            log_path="$2"
            shift 2
            ;;
        -t|--tail)
            tail_lines="$2"
            shift 2
            ;;
        -C|--context)
            context_lines="$2"
            shift 2
            ;;
        *)
            if [ -z "$service" ]; then
                service="$1"
            else
                pattern="$1"
            fi
            shift
            ;;
    esac
done

# Check required parameters
if [ -z "$service" ] || [ -z "$pattern" ]; then
    echo "Error: Both service name and search pattern are required"
    usage
fi

# Get pod list
podlist=$(kubectl -n $namespace get pod | grep $service | awk '{print $1}')
if [ -z "$podlist" ]; then
    echo "Error: No pods found for service '$service' in namespace '$namespace'"
    exit 1
fi

# Function to search logs in a pod
function search_logs() {
    local pod=$1
    echo -e "\n\033[44;37m Pod: $pod \033[0m"
    
    if [ ! -z "$log_path" ]; then
        # Custom log path mode
        script="cd $(dirname $log_path) && grep --color=always  --group-separator='━━━━━━━━━━'  -C $context_lines '$pattern' $(basename $log_path) | tail -n $tail_lines"
        echo "$script" > ${pod}.sh
        kubectl cp -n $namespace ${pod}.sh $pod:tmp.sh
        rm -f ${pod}.sh
        if [ ! -z "$container" ]; then
            kubectl exec -i $pod -c $container -n $namespace -- sh tmp.sh
        else
            kubectl exec -i $pod -n $namespace -- sh tmp.sh
        fi
    else
        # Standard output mode
        cmd="kubectl logs"
        if [ ! -z "$container" ]; then
            cmd="$cmd -c $container"
        fi
        cmd="$cmd --tail=$tail_lines -n $namespace $pod | grep --color=always --group-separator='━━━━━━━━━━'  -C $context_lines '$pattern'"
        eval $cmd
    fi
}

# Process each pod
for pod in $podlist; do
    search_logs $pod
done
