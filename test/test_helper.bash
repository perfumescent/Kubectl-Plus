#!/usr/bin/env bash

setup() {
    export BATS_VERBOSE=${BATS_VERBOSE:-false} 
    
    if [ "$BATS_VERBOSE" = true ]; then
        set -x
    fi
    
    # 记录kubectl调用日志
    export KUBECTL_LOG="$BATS_TMPDIR/kubectl.log"
    touch "$KUBECTL_LOG"
    
    # 包装kubectl命令
    kubectl() {
        echo "$(date) [TEST] kubectl $@" >> "$KUBECTL_LOG"
        command kubectl "$@"
    }
    
    # 加载被测试文件
    export PATH="$BATS_TEST_DIRNAME/../cmd:$PATH"
    
    # 模拟kubectl环境
    export KUBECONFIG="$BATS_TMPDIR/kubeconfig"
    echo "apiVersion: v1
clusters: []
contexts: []
current-context: ""
kind: Config
preferences: {}" > "$KUBECONFIG"
    
    # 创建测试用namespace
    export TEST_NS="test-ns-$RANDOM"
}

teardown() {
    # 清理测试数据
    rm -rf "$KUBECONFIG"
}

# 新增错误诊断函数
print_debug_info() {
    echo -e "\n=== 测试失败调试信息 ==="
    echo "最后命令: ${BATS_TEST_DESCRIPTION}"
    echo "退出状态: $status"
    echo "输出内容:"
    printf '%s\n' "${lines[@]}"
    
    if [ -f "$KUBECTL_LOG" ]; then
        echo -e "\nkubectl调用记录:"
        cat "$KUBECTL_LOG"
    fi
    
    echo -e "\n环境变量:"
    printenv | grep -E 'PATH|KUBECONFIG|BIN_DIR'
} 