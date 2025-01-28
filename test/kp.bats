#!/usr/bin/env bats

load 'test_helper'

@test "主命令帮助信息" {
    run kp --help
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "Kubectl Plus CLI - Kubernetes运维增强工具" ]
}

@test "显示版本信息" {
    run kp --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Version:" ]]
}

@test "无效子命令提示" {
    run kp invalid-command
    [ "$status" -eq 1 ]
    [[ "$output" == *"未知子命令: invalid-command"* ]]
    [[ "$output" == *"可用子命令: p, f, l, i"* ]]
}

@test "子命令参数透传验证" {
    # 测试参数位置正确处理
    run kp p -n test-ns get pod
    [ "$status" -eq 0 ]
    [[ "$output" == *"-n test-ns get pod"* ]] # 实际应根据具体实现调整
} 