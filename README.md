# Kubectl-Plus

<div align="center">

[English](README.md#english) | [中文](README.md#chinese)

</div>

<a id="english"></a>
# Kubectl-Plus - Supercharge Your K8s Operations! 🚀

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/kubectl-plus/pulls)

> 🎯 A carefully crafted set of Kubectl automation tools that make K8s daily operations simple and efficient!

## 🌟 Features

- 🔥 **Smart Command Wrappers**: Simplify complex kubectl commands into intuitive short commands
- ⚡ **Command Auto-completion**: Smart suggestions for pod and service names
- 🛠️ **One-click Installation**: Quick setup in new environments
- 📊 **Intelligent Log Analysis**: Fast log location and viewing
- 🔍 **Multi-Pod Operations**: Execute commands across multiple pods simultaneously

## 🚀 Quick Start

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/kubectl-plus.git
cd kubectl-plus

# Install script (specify namespace, default is dev)
sudo ./install.sh your-namespace
```

### Command Reference

1. **p command** - View Pod Status
```bash
p  # Display detailed information of all pods in specified namespace
```

2. **into command** - Quick Pod Access
```bash
into pod-name  # Directly enter pod's shell environment
# Supports Tab completion for pod names
```

3. **l command** - Smart Log Viewing
```bash
# Basic usage
l pod-name                    # View latest pod logs (last 500 lines)
l pod-name pattern           # Search logs with pattern (with context)

# Advanced options
l pod-name -n namespace      # Specify namespace
l pod-name -c container      # Specify container
l pod-name -p /logs/*.log    # View logs from custom path (supports wildcards)
l pod-name -s pattern        # Display logs starting from first pattern match
l pod-name -t 1000          # Show last 1000 lines
l pod-name -f               # Follow log output

# Combined usage
l pod-name -p /var/log/app/*.log -f    # Follow custom path logs
l pod-name -c nginx -p /logs/access.log # View specific container's custom logs

# Tab completion demo
```
> Press [Tab] to auto-complete pod names based on namespace
```bash
> l ng[Tab]
nginx-85c4cf67c-1234    nginx-85c4cf67c-5678    nginx-config-abc123

> l -n prod ng[Tab]
nginx-prod-abc123    nginx-prod-def456    nginx-prod-ghi789

> l -n staging ng[Tab]
nginx-staging-111    nginx-staging-222
```

4. **f command** - Multi-Pod Log Search
```bash
# Basic usage
f service-name pattern        # Search pattern in all pods of the service
                            # (with colored output and context separator)

# Advanced options
f service-name -n namespace pattern    # Specify namespace
f service-name -c container pattern    # Specify container
f service-name -p /logs/*.log pattern  # Search in custom log path (supports wildcards)
f service-name pattern -C 5            # Show 5 lines of context
f service-name pattern -t 100          # Show last 100 matching lines

# Combined usage
f nginx-svc -n prod -p /var/log/*.log error    # Search in custom logs across pods
f nginx-svc -c nginx -t 200 error             # Search in specific container with more lines

# Tab completion demo
```
> Press [Tab] to auto-complete service names based on namespace
```bash
> f ng[Tab]
nginx-svc    nginx-ingress    nginx-config

> f -n prod ng[Tab]
nginx-prod-svc    nginx-prod-ingress

> f -n staging ng[Tab]
nginx-staging-svc    nginx-staging-lb
```

## 🎯 Usage Tips

### Auto-completion Features
- All commands support smart Tab completion
- `into` and `l` commands support pod name completion with namespace awareness (-n option)
- `f` command supports service name completion with namespace awareness (-n option)

### Log Viewing Tips
- `l` command without keyword tracks latest logs in real-time
- `l` command with keyword starts displaying from keyword's first occurrence
- `f` command searches across all pods of a service with context separators and colored output

## 🤝 Contributing

We warmly welcome all forms of contributions! The project is in its early stages with many exciting features waiting to be implemented:

### Future Plans

1. **Command Extensions**
   - Add service restart command
   - Add quick config file modification
   - Add resource usage monitoring
   - Implement multi-cluster switching

2. **Feature Enhancements**
   - Support more log analysis features
   - Add resource usage statistics reports
   - Implement common issue diagnostics
   - Add visualization interface

3. **User Experience**
   - Optimize error messages
   - Add command execution history
   - Support more custom configuration options

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 🌟 Star History

If you find this project helpful, please give it a star! Your support drives our continuous improvement!

---

<a id="chinese"></a>
# Kubectl-Plus - 让K8s运维工作事半功倍！🚀

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/kubectl-plus/pulls)

> 🎯 一套精心打造的Kubectl自动化工具集，让K8s日常运维工作变得简单高效！

## 🌟 特性

- 🔥 **智能命令封装**：将常用的复杂kubectl命令简化为直观的短命令
- ⚡ **命令自动补全**：支持pod名称和服务名称的智能提示
- 🛠️ **一键安装部署**：快速在新环境中完成配置
- 📊 **日志智能分析**：快速定位和查看容器日志
- 🔍 **多Pod批量操作**：支持同时在多个Pod中执行命令

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/yourusername/kubectl-plus.git
cd kubectl-plus

# 安装脚本（需要指定namespace，默认为dev）
sudo ./install.sh your-namespace
```

### 命令说明

1. **p命令** - 查看Pod状态
```bash
p  # 显示指定namespace下所有pod的详细信息
```

2. **into命令** - 快速进入Pod
```bash
into pod-name  # 直接进入指定Pod的shell环境
# 支持Tab自动补全Pod名称
```

3. **l命令** - 智能日志查看
```bash
# 基本用法
l pod-name                    # 查看最新日志（最后500行）
l pod-name pattern           # 搜索包含pattern的日志（带上下文）

# 高级选项
l pod-name -n namespace      # 指定命名空间
l pod-name -c container      # 指定容器
l pod-name -p /logs/*.log    # 查看自定义路径的日志（支持通配符）
l pod-name -s pattern        # 从第一个匹配pattern处开始显示
l pod-name -t 1000          # 显示最后1000行
l pod-name -f               # 持续追踪日志输出

# 组合使用
l pod-name -p /var/log/app/*.log -f    # 追踪自定义路径的日志
l pod-name -c nginx -p /logs/access.log # 查看指定容器的自定义日志

# Tab补全演示
```
> �� [Tab] 键可根据命名空间自动补全Pod名称
```bash
> l ng[Tab]
nginx-85c4cf67c-1234    nginx-85c4cf67c-5678    nginx-config-abc123

> l -n prod ng[Tab]
nginx-prod-abc123    nginx-prod-def456    nginx-prod-ghi789

> l -n staging ng[Tab]
nginx-staging-111    nginx-staging-222
```

4. **f命令** - 多Pod日志搜索
```bash
# 基本用法
f service-name pattern        # 在服务的所有Pod中搜索匹配项
                            # (带有彩色输出和上下文分隔符)

# 高级选项
f service-name -n namespace pattern    # 指定命名空间
f service-name -c container pattern    # 指定容器
f service-name -p /logs/*.log pattern  # 在自定义日志路径中搜索（支持通配符）
f service-name pattern -C 5            # 显示5行上下文
f service-name pattern -t 100          # 显示最后100行匹配结果

# 组合使用
f nginx-svc -n prod -p /var/log/*.log error    # 在自定义日志中跨Pod搜索
f nginx-svc -c nginx -t 200 error             # 在特定容器中搜索更多行

# Tab补全演示
```
> 按 [Tab] 键可根据命名空间自动补全服务名称
```bash
> f ng[Tab]
nginx-svc    nginx-ingress    nginx-config

> f -n prod ng[Tab]
nginx-prod-svc    nginx-prod-ingress

> f -n staging ng[Tab]
nginx-staging-svc    nginx-staging-lb
```

## 🎯 使用技巧

### 自动补全功能
- 所有命令都支持智能Tab补全
- `into`和`l`命令支持Pod名称补全，可通过-n参数指定命名空间
- `f`命令支持服务名称补全，可通过-n参数指定命名空间

### 日志查看技巧
- `l`命令不带关键词时会实时追踪最新日志
- `l`命令带关键词时会从关键词首次出现处开始显示
- `f`命令会在服务的所有Pod中搜索，并带有上下文分隔符和彩色输出

## 🤝 参与贡献

我们非常欢迎各种形式的贡献！项目处于早期阶段，有很多激动人心的特性等待实现：

### 未来规划

1. **命令扩展**
   - 添加服务重启命令
   - 添加配置文件快速修改功能
   - 添加资源使用监控命令
   - 实现多集群切换功能

2. **功能增强**
   - 支持更多的日志分析功能
   - 添加资源使用统计报告
   - 实现常见问题自动诊断
   - 添加可视化界面

3. **使用体验**
   - 优化错误提示信息
   - 添加命令执行历史记录
   - 支持更多的自定义配置选项

### 如何贡献

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 📝 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详细信息

## 🌟 Star History

如果您觉得这个项目对您有帮助，欢迎点击 Star！您的支持是我们持续改进的动力！

---

> 🎉 让我们一起让K8s运维工作变得更简单！