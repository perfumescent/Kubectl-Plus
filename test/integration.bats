#!/usr/bin/env bats

load 'test_helper'

@test "完整工作流测试" {
    # 创建测试Pod
    kubectl run test-pod --image=nginx
    
    # 测试日志查看
    run kp l test-pod
    [ "$status" -eq 0 ]
    [[ "$output" == *"nginx"* ]]
    
    # 测试资源查看
    run kp p get pods
    [ "$status" -eq 0 ]
    [[ "$output" == *"test-pod"* ]]
    
    # 清理
    kubectl delete pod test-pod
} 