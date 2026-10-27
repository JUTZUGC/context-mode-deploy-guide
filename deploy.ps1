# Context Mode npm / MCP脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/mksglu/context-mode#install
# 更新日期：2026-10-27
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

npm.cmd install -g context-mode
claude mcp add context-mode -- npx -y context-mode
context-mode --help
claude mcp list | Select-String 'context-mode'

Write-Host ''

Write-Host '部署完成：context-mode 已注册为 MCP server，重启客户端后可用；需要插件形态时可执行 /plugin install context-mode@context-mode'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/mksglu/context-mode#install'
