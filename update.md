
# CLI 工具整合项目 Prompt

## 背景
我们开发了一套 Kubernetes 运维增强工具集，当前包含四个独立命令：
- `p`: 资源查看与管理
- `f`: 跨 Pod 日志搜索
- `l`: 指定 Pod 日志查看
- `i`: 交互式 Pod 访问

当前架构下每个命令都是独立脚本，导致以下问题：
1. 用户需要记忆多个命令名称
2. 自动补全配置分散
3. 代码复用率低
4. 安装维护成本高

## 目标
将现有命令改造为统一入口的 CLI 工具，满足：
```bash
kp p [options]    # 原 p 命令功能
kp f [options]    # 原 f 命令功能
kp l [options]    # 原 l 命令功能
kp i [options]    # 原 i 命令功能
```
同时保持：
- 100% 原有功能兼容
- 自动补全体验一致
- 安装流程无缝升级
- 代码可维护性提升

## 详细需求

### 1. 主命令架构
```bash
# 文件结构
/cmd
  /kp         # 主入口脚本
  /p          # 原子命令脚本（保持原样）
  /f          # （保持原样）
  /l          # （保持原样）
  /i          # （保持原样）
/autocomplete # 新的统一补全配置
```

### 2. 自动补全改造
```bash
# 输入 kp [Tab] 时显示：
p   f   l   i

# 输入 kp p [Tab] 时：
# 保持原有 p 命令补全逻辑，但需处理参数位移：
# 原 p -n [Tab] → 现 kp p -n [Tab]
```

### 3. 安装脚本改造
```bash
# 安装后结构
/usr/local/bin
  kp    # 主命令
  kp-p  # 子命令（原 p 命令）
  kp-f  # （原 f 命令）
  ...   # 其他子命令

# 保持原有命令别名（可选）
alias p='kp p'
```

### 4. 测试验证需求
```bash
# 测试用例示例
$ kp p -n default pod1 # 应完全等同原 p -n default pod1
$ kp f nginx error     # 应完全等同原 f nginx error
$ kp invalid_cmd       # 应显示友好错误提示
```

## 技术约束
1. 兼容性要求：
   - Bash 3.2+ 
   - Zsh 5.8+
   - kubectl 1.20+

2. 代码规范：
```bash
# 保持现有代码风格：
# 变量命名: lower_case_with_underscores
# 函数命名: camelCase
# 错误处理: echo "Error: ..." >&2; exit 1
```

## 交付物
1. 新增/修改文件清单：
```text
/cmd/kp
/cmd/autocomplete
/install.sh
/docs/usage.md
```

2. 验收标准：
```bash
# 必须通过的基础测试
$ type kp → 显示正确安装路径
$ kp [Tab] → 显示 p/f/l/i
$ kp p -o [Tab] → 显示 json/yaml/wide/custom
$ kp f --help → 显示原 f 命令帮助信息
```

## 特别说明
1. 向后兼容方案：
```bash
# 安装时创建符号链接（可选）
ln -s /usr/local/bin/kp-p /usr/local/bin/p
```

2. 错误处理要求：
```bash
# 无效子命令提示
$ kp wrong
Error: Unknown subcommand 'wrong'
Available subcommands: p, f, l, i
```

请基于以上需求生成具体的代码实现方案，优先保证现有功能的完整性和用户体验的连贯性。对于可能产生歧义的技术细节，请主动做出符合 Kubernetes 运维工具惯例的合理决策。

