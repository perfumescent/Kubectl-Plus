#!/bin/bash
# 运行所有测试用例
bats -r test/

# 生成覆盖率报告（需要lcov）
shopt -s extglob
kcov --exclude-pattern=test/ \
     --include-path=cmd/ \
     coverage \
     bats -r test/ 