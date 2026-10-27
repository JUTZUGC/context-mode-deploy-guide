# Context Mode npm / MCP指南

> 第三方部署指南 · 非 Context Mode 官方仓库。官方项目：[mksglu/context-mode](https://github.com/mksglu/context-mode)
> 内容来自官方文档（2026-10-27）。项目迭代快，请以[官方文档](https://github.com/mksglu/context-mode#install)为准。

[![⚡ npm / MCP](https://img.shields.io/badge/%E2%9A%A1_npm_%2F_MCP-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#npm/mcp推荐用百度搭子)

## npm / MCP（推荐：用百度搭子）

> [!TIP]
> 不想让 Agent 被一大坨工具输出撑爆上下文，让百度搭子装好 Context Mode，自动沙箱压缩再记进会话记忆。

⚠️ 完整功能（hooks + 斜杠命令）需要 Claude Code v1.0.33 以上；其它客户端只能用 MCP-only 模式，路由规则要手动复制一份。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/context-mode-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子全局安装 context-mode，并用 claude mcp add 把它注册成 MCP server，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Context Mode 是什么？

Context Mode 是开源的32.4k stars，TypeScript，给 AI 编程 Agent 做上下文压缩、会话记忆与跨平台路由（协议：未声明（见仓库 LICENSE），<img src="https://img.shields.io/github/stars/mksglu/context-mode?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

一个上下文优化层：把工具输出放进沙箱只回传摘要（号称减少约 98% token）、把会话记忆持久化、并通过 MCP + hooks 在 17 个平台之间做统一路由。

- 工具输出沙箱：只把摘要回给模型，原始内容留在本地
- 会话记忆：跨会话保留关键结论，不用反复贴背景
- 跨平台路由：17 个客户端共用一套规则
- MCP 原生：标准 MCP server，任何支持 MCP 的客户端都能接
- 两种形态：插件模式带 hooks，MCP-only 模式零侵入
- TypeScript：源码可读，方便二次改造

（来源：[官方仓库](https://github.com/mksglu/context-mode)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 32.4k stars | 2026-02 建仓，8 个月冲到 3 万 |
| 省 token | 工具输出走沙箱，只回摘要 |
| 有记忆 | 会话结论可跨轮次保留 |
| 多客户端 | 17 个平台共用一套路由 |
| 双形态 | 插件模式或纯 MCP 模式都能用 |
| 本地处理 | 原始输出不一定要外传 |

| 需要注意 | 说明 |
|---|---|
| 版本门槛 | 完整功能要 Claude Code 1.0.33+ |
| 配置分散 | 不同客户端要各自加一次 |
| 压缩会丢细节 | 摘要之外的原始内容要另存 |
| hooks 要信任 | 本质是让工具接管上下文流 |
| 许可证待确认 | GitHub 未识别标准许可证 |

> 以上基于官方文档与社区反馈整理（2026-10-27），以官方最新文档为准。

## 快速部署（官方方式）

```bash
npm install -g context-mode
claude mcp add context-mode -- npx -y context-mode
context-mode --help
claude mcp list | grep -q context-mode && echo 'MCP 已注册' || echo '未注册成功，检查 claude 版本'
```

部署步骤来源：[https://github.com/mksglu/context-mode#install](https://github.com/mksglu/context-mode#install)

## 验证状态

| 场景 | 状态 |
|---|---|
| npm 包 context-mode 最新版 1.0.169，bin 指向 cli.bundle.mjs | 已核对 2026-10-27 |
| 仓库元数据已核对：32.4k stars、TypeScript、2026-02 建仓 | 已核对 2026-10-27 |
| README 确认支持插件模式与 MCP-only 两种安装 | 已核对 2026-10-27 |
| 未实测安装与压缩效果 | 说明 2026-10-27 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

context-mode 本身就是 MCP server，`claude mcp add context-mode -- npx -y context-mode` 即可注册；本仓库只提供安装与配置说明。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-27）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\context-mode-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后

```bash
context-mode --help          # 查看可用子命令
claude mcp list              # 确认 MCP 已注册
```

### 插件模式（推荐）

在 Claude Code 里执行下面两句，可以拿到 hooks 和斜杠命令：

```text
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
```

### MCP-only 模式

其它客户端只接 MCP，不装 hooks：

```bash
claude mcp add context-mode -- npx -y context-mode
```

### 环境要求

| 客户端 | 要求 |
|---|---|
| Claude Code | v1.0.33+，支持 `/plugin` |
| Gemini CLI | Node.js >= 22.5 或 Bun |
| 其它 MCP 客户端 | 支持 stdio MCP server |

> ⚠️ 压缩比例是官方口径，实际效果取决于工具输出类型；关键上下文仍建议自己保留一份。

## 常见坑

- `/plugin` 不识别：先升级 Claude Code
- MCP 连不上：先单独跑一次 `npx -y context-mode` 看报错
- Node 版本太低：Gemini CLI 场景需要 22.5+
- 装了插件又加 MCP 会重复：二选一
- 压缩后细节丢失：重要输出自己落盘
- 多客户端规则不同步：按文档复制一份路由文件

## 免责声明

本仓库为第三方指南，与 Context Mode 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-27），项目迭代快，请以[官方文档](https://github.com/mksglu/context-mode#install)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
