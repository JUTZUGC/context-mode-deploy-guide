#!/usr/bin/env bash
set -euo pipefail
# Context Mode npm / MCP脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/mksglu/context-mode#install
# 更新日期：2026-10-27
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

npm install -g context-mode
claude mcp add context-mode -- npx -y context-mode
context-mode --help
claude mcp list | grep -q context-mode && echo 'MCP 已注册' || echo '未注册成功，检查 claude 版本'

echo ""

echo "部署完成：context-mode 已注册为 MCP server，重启客户端后可用；需要插件形态时可执行 /plugin install context-mode@context-mode"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/mksglu/context-mode#install"
