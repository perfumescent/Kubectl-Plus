# Kubectl-Plus

<div align="center">

[English](README.md) | [中文](README_zh.md)

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/perfumescent/kubectl-plus/pulls)

</div>

> 🎯 一套精心打造的 Kubectl 自动化工具集，让 K8s 日常运维工作变得简单高效！

## ✨ 特性

- 🚀 **命令简化**：将复杂的 kubectl 操作转化为直观的短命令
- 🔍 **智能补全**：支持命名空间、Pod 和服务名称的上下文感知式补全
- 📊 **日志增强**：先进的日志查看和跨 Pod 搜索功能
- 🛠️ **资源管理**：灵活的资源查看和交互方式
- ⚡ **快速部署**：新环境中轻松安装配置

## 🚀 快速开始

### 安装

选择以下任一方式安装：

#### 方式一：一键安装（推荐）
```bash
curl -fsSL https://raw.githubusercontent.com/perfumescent/Kubectl-Plus/main/install.sh | bash
```

#### 方式二：手动安装
```bash
# 克隆仓库
git clone https://github.com/perfumescent/Kubectl-Plus.git
cd Kubectl-Plus

# 运行安装程序
./install.sh
```

安装程序会：
- 检查系统要求
- 安装命令到 PATH
- 配置 shell 自动补全
- 设置您偏好的命名空间

### 系统要求
- 已安装并配置 kubectl
- bash 或 zsh shell
- Linux/macOS 操作系统

## 🎯 命令说明

### 资源查看 - `p` 命令
```bash
# 基本用法
p                    # 查看默认命名空间的 Pod（宽格式输出）
p svc                # 查看服务
p deploy             # 查看部署

# 高级选项
p -n prod            # 指定命名空间
p -l app=nginx       # 按标签过滤
p -o yaml            # YAML 格式输出
p -A                 # 查看所有命名空间
p -S name            # 按名称排序

# 组合使用
p -n prod -l tier=frontend -S status    # 查看 prod 命名空间下带标签的 Pod 并排序
p deploy -A -o wide                     # 查看所有命名空间的部署（宽格式）
```

### Pod 访问 - `i` 命令
```bash
# 基本用法
i nginx                     # 使用默认 shell 进入 Pod
i nginx -c side-car        # 进入指定容器
i nginx -- ls /etc         # 执行命令而不进入 shell
i nginx -s bash            # 使用 bash 作为 shell

# 高级选项
i nginx -n prod            # 指定命名空间
i nginx -u root           # 以 root 用户运行
i nginx -c nginx -s bash  # 使用 bash 进入 nginx 容器
```

### 日志查看 - `l` 命令
```bash
# 基本用法
l pod-name                    # 查看最新日志（最后 500 行）
l pod-name pattern           # 搜索包含 pattern 的日志（带上下文）

# 高级选项
l pod-name -n namespace      # 指定命名空间
l pod-name -c container      # 指定容器
l pod-name -p /logs/*.log    # 查看自定义路径的日志（支持通配符）
l pod-name -s pattern        # 从第一个匹配 pattern 处开始显示
l pod-name -t 1000          # 显示最后 1000 行
l pod-name -f               # 持续追踪日志输出
```

### 多 Pod 日志搜索 - `f` 命令
```bash
# 基本用法
f service-name pattern        # 在服务的所有 Pod 中搜索匹配项
                            # (带有彩色输出和上下文分隔符)

# 高级选项
f service-name -n namespace pattern    # 指定命名空间
f service-name -c container pattern    # 指定容器
f service-name -p /logs/*.log pattern  # 在自定义日志路径中搜索
f service-name pattern -C 5            # 显示 5 行上下文
f service-name pattern -t 100          # 显示最后 100 行匹配结果
```

## 🔮 智能自动补全

所有命令都配备了智能自动补全支持，让您的 K8s 操作更流畅、更快速！

### 命名空间补全
```bash
# 补全命名空间参数
l --n[Tab]                # 补全为: l --namespace
l -n[Tab]                 # 补全为: l -n

# 在 -n 或 --namespace 后补全命名空间
l -n pro[Tab]            # 补全为: l -n production
i -n stag[Tab]           # 补全为: i -n staging
f -n dev[Tab]            # 补全为: f -n development
p -n [Tab]               # 显示所有可用的命名空间
```

### 资源补全
```bash
# 补全 Pod 名称（会考虑命名空间上下文）
l ng[Tab]                  # 显示当前命名空间的 nginx 相关 pod
i -n prod ng[Tab]          # 显示 prod 命名空间的 nginx 相关 pod

# 补全服务名称
f ng[Tab]                  # 显示 nginx 相关服务
f -n prod ng[Tab]          # 显示 prod 命名空间的 nginx 相关服务

# 补全 p 命令的资源类型
p dep[Tab]                 # 补全为: p deploy
p [Tab]                    # 显示所有资源类型 (pod/svc/deploy/rs/sts)
```

### 选项补全
```bash
# 补全命令选项
p -[Tab]                   # 显示所有选项 (-n, -w, -l, -o, -A, -S)
i --[Tab]                  # 显示所有长选项 (--namespace, --container 等)

# 补全选项值
p -o [Tab]                 # 显示输出格式选项 (json/yaml/wide/custom)
p -S [Tab]                 # 显示排序字段选项 (name/status/age)
i -s [Tab]                 # 显示可用的 shell 选项 (sh/bash/zsh)
```

## 🤝 参与贡献

我们非常欢迎各种形式的贡献！以下是我们正在关注的领域：

### 未来规划

1. **命令扩展**
   - 服务重启自动化
   - 配置文件快速修改
   - 资源使用监控
   - 多集群管理

2. **功能增强**
   - 高级日志分析
   - 资源使用统计
   - 常见问题诊断
   - 可视化界面

3. **使用体验**
   - 增强错误提示
   - 命令执行历史
   - 更多自定义选项

### 如何贡献

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📝 许可证

本项目采用 Apache License 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详细信息。

## 🌟 Star History

如果您觉得这个项目对您有帮助，欢迎点击 Star！您的支持是我们持续改进的动力！

> 🎉 让我们一起让 K8s 运维工作变得更简单！
