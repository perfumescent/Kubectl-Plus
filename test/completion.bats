#!/usr/bin/env bats

load 'test_helper'

setup() {
    source ~/.kubectl-plus-completion
}

@test "主命令补全建议" {
    run _kp_completion
    [ "${#lines[@]}" -eq 4 ]
    [[ "$output" == *$'p\nf\nl\ni'* ]]
}

@test "子命令参数补全" {
    # 测试p命令的output格式补全
    run _kp_completion kp p -o ""
    [ "${#lines[@]}" -ge 4 ]
    [[ "$output" == *$'json\nyaml\nwide'* ]]
}

@test "namespace自动补全" {
    # 模拟kubectl get namespaces
    echo "test-ns-1\ntest-ns-2" > "$BATS_TMPDIR/namespaces"
    alias kubectl="cat $BATS_TMPDIR/namespaces"
    
    run _kp_completion kp p -n ""
    [ "${lines[0]}" = "test-ns-1" ]
    [ "${lines[1]}" = "test-ns-2" ]
}

@test "跨命名空间服务补全" {
    # 模拟不同命名空间的服务
    echo "frontend\nbackend" > "$BATS_TMPDIR/services"
    alias kubectl="echo -e 'frontend\nbackend'"
    
    run _kp_completion kp f -n production ""
    [ "${lines[0]}" = "frontend" ]
    [ "${lines[1]}" = "backend" ]
}

@test "带标签的Pod补全" {
    # 模拟带标签的Pod
    kubectl label pod test-pod app=nginx >/dev/null
    run _kp_completion kp l app=nginx ""
    [[ "$output" == *"test-pod"* ]]
}

@test "历史命令补全" {
    # 模拟历史命令缓存
    echo "kp p get pods" >> ~/.kp_history
    run _kp_completion kp ""
    [[ "$output" == *"p get pods"* ]]
} 