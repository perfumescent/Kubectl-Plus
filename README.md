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
l pod-name  # Real-time view of latest pod logs
l pod-name keyword  # View logs starting from specified keyword
# Supports Tab completion for pod names
```

4. **f command** - Multi-Pod Log Search
```bash
f service-name keyword  # Search for keyword in logs across all pods of specified service
# Supports Tab completion for service names
```

## 🎯 Usage Tips

### Auto-completion Features
- All commands support smart Tab completion
- `into` and `l` commands support pod name completion
- `f` command supports service name completion

### Log Viewing Tips
- `l` command without keyword tracks latest logs in real-time
- `l` command with keyword starts displaying from keyword's first occurrence
- `f` command searches and displays keyword context across all relevant pods

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
l pod-name  # 实时查看指定Pod最新的日志
l pod-name keyword  # 从指定关键词开始查看日志
# 支持Tab自动补全Pod名称
```

4. **f命令** - 多Pod日志搜索
```bash
f service-name keyword  # 在指定服务的所有Pod中搜索包含关键词的日志
# 支持Tab自动补全服务名称
```

## 🎯 使用技巧

### 自动补全功能
- 所有命令都支持智能Tab补全
- `into`和`l`命令支持Pod名称补全
- `f`命令支持服务名称补全

### 日志查看技巧
- `l`命令不带关键词时会实时追踪最新日志
- `l`命令带关键词时会从关键词首次出现处开始显示
- `f`命令会在所有相关Pod中搜索并显示关键词上下文

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