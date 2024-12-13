
<div align="center">

[English](README.md) | [中文](README_zh.md)

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/kubectl-plus/pulls)

</div>

> 🎯 A carefully crafted set of Kubectl automation tools that make K8s daily operations simple and efficient!

## ✨ Features

- 🚀 **Simplified Commands**: Intuitive shortcuts for complex kubectl operations
- 🔍 **Smart Completion**: Context-aware auto-completion for namespaces, pods, and services
- 📊 **Enhanced Logging**: Advanced log viewing and searching across pods
- 🛠️ **Resource Management**: Flexible resource viewing and interaction
- ⚡ **Quick Installation**: Easy setup in new environments

## 🚀 Quick Start

### Installation

Choose one of the following methods to install:

#### Method 1: One-line Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/perfumescent/Kubectl-Plus/main/install.sh | bash
```

#### Method 2: Manual Installation
```bash
# Clone repository
git clone https://github.com/perfumescent/Kubectl-Plus.git
cd Kubectl-Plus

# Run installer
./install.sh
```

The installer will: 
- Check system requirements
- Install commands to your PATH
- Configure shell completion
- Set up your preferred namespace

### Requirements
- kubectl installed and configured
- bash or zsh shell
- Linux/macOS operating system

## 🎯 Command Reference

### Resource Viewing - `kp p` Command
```bash
# Basic usage
kp p                    # View pods in default namespace (wide output)
kp p svc                # View services
kp p deploy             # View deployments

# Advanced options
kp p -n prod            # Specify namespace
kp p -l app=nginx       # Filter by label
kp p -o yaml            # Output in YAML format
kp p -A                 # List across all namespaces
kp p -S name            # Sort by name

# Combined usage
kp p -n prod -l tier=frontend -S status    # View sorted pods with label in prod
kp p deploy -A -o wide                     # View all deployments in wide format
```

### Pod Access - `kp i` Command
```bash
# Basic usage
kp i nginx                     # Enter pod with default shell
kp i nginx -c side-car        # Enter specific container
kp i nginx -- ls /etc         # Execute command without entering
kp i nginx -s bash            # Use bash as shell

# Advanced options
kp i nginx -n prod            # Specify namespace
kp i nginx -u root           # Run as root user
kp i nginx -c nginx -s bash  # Enter nginx container with bash
```

### Log Viewing - `kp l` Command
```bash
# Basic usage
kp l pod-name                    # View latest pod logs (last 500 lines)
kp l pod-name pattern           # Search logs with pattern (with context)

# Advanced options
kp l pod-name -n namespace      # Specify namespace
kp l pod-name -c container      # Specify container
kp l pod-name -p /logs/*.log    # View logs from custom path (supports wildcards)
kp l pod-name -s pattern        # Display logs starting from first pattern match
kp l pod-name -t 1000          # Show last 1000 lines
kp l pod-name -f               # Follow log output
```

### Multi-Pod Log Search - `kp f` Command
```bash
# Basic usage
kp f service-name pattern        # Search pattern in all pods of the service
                               # (with colored output and context separator)

# Advanced options
kp f service-name -n namespace pattern    # Specify namespace
kp f service-name -c container pattern    # Specify container
kp f service-name -p /logs/*.log pattern  # Search in custom log path
kp f service-name pattern -C 5            # Show 5 lines of context
kp f service-name pattern -t 100          # Show last 100 matching lines
```

## 🔮 Smart Auto-completion

All commands come with intelligent auto-completion support that makes your K8s operations smoother and faster!

### Command Completion
```bash
# Complete main command
kp [Tab]                 # Shows all available subcommands (l, f, i, p)

# Complete subcommand options
kp l -[Tab]              # Shows all options for log command
kp i --[Tab]             # Shows all long options for pod access command
```

### Namespace Completion
```bash
# Complete namespace parameter
kp l --n[Tab]                # Completes to: kp l --namespace
kp l -n[Tab]                 # Completes to: kp l -n

# Complete namespace after -n or --namespace
kp l -n pro[Tab]            # Completes to: kp l -n production
kp i -n stag[Tab]           # Completes to: kp i -n staging
kp f -n dev[Tab]            # Completes to: kp f -n development
kp p -n [Tab]               # Shows all available namespaces
```

### Resource Completion
```bash
# Complete pod names (context-aware of namespace)
kp l ng[Tab]                  # Shows nginx pods in current namespace
kp i -n prod ng[Tab]          # Shows nginx pods in prod namespace

# Complete service names
kp f ng[Tab]                  # Shows nginx services
kp f -n prod ng[Tab]          # Shows nginx services in prod namespace

# Complete resource types for p command
kp p dep[Tab]                 # Completes to: kp p deploy
kp p [Tab]                    # Shows all resource types (pod/svc/deploy/rs/sts)
```

### Option Completion
```bash
# Complete command options
kp p -[Tab]                   # Shows all options (-n, -w, -l, -o, -A, -S)
kp i --[Tab]                  # Shows all long options (--namespace, --container, etc)

# Complete option values
kp p -o [Tab]                 # Shows output formats (json/yaml/wide/custom)
kp p -S [Tab]                 # Shows sort fields (name/status/age)
kp i -s [Tab]                 # Shows available shells (sh/bash/zsh)
```

## 🤝 Contributing

We warmly welcome all forms of contributions! Here are some areas we're focusing on:

### Future Plans

1. **Command Extensions**
   - Service restart automation
   - Quick config file modification
   - Resource usage monitoring
   - Multi-cluster management

2. **Feature Enhancements**
   - Advanced log analysis
   - Resource usage statistics
   - Common issue diagnostics
   - Visualization interface

3. **User Experience**
   - Enhanced error messages
   - Command execution history
   - More customization options

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🌟 Star History
                                 
If you find this project helpful, please give it a star! Your support drives our continuous improvement!
