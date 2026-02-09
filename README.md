# SuperDesign Skill

基于 [SuperDesign](https://app.superdesign.dev/) 的 AI 设计技能，为前端 UI/UX 设计提供智能辅助。

## 在新环境中安装

### 1. 安装 SuperDesign CLI

```bash
npm install -g @superdesign/cli@latest
```

### 2. 登录

```bash
superdesign login
```

按提示完成认证，登录成功后才能使用设计功能。

### 3. 安装 Skill

在项目根目录运行：

```bash
npx skills add superdesigndev/superdesign-skill --yes
```

这会将技能文件安装到 `.agents/skills/superdesign/` 并为 Claude Code 创建符号链接。

## 使用方式

在 Claude Code 中使用 `/superdesign` 指令即可调用，常用命令：

| 命令 | 说明 |
|------|------|
| `/superdesign help me design X` | 开始一个设计任务 |
| `superdesign create-project --title "项目名"` | 创建设计项目 |
| `superdesign create-design-draft --project-id <id> --title "标题" -p "设计要求"` | 创建设计稿 |
| `superdesign iterate-design-draft --draft-id <id> -p "变体1" -p "变体2" --mode branch` | 在现有设计上迭代变体 |
| `superdesign execute-flow-pages --draft-id <id> --pages '[...]'` | 基于已有设计扩展多页面 |
| `superdesign get-design --draft-id <id>` | 查看设计稿内容 |

## 典型工作流

1. **创建项目** — `superdesign create-project --title "My App"`
2. **忠实复现当前 UI** — 用 `create-design-draft` 先做一版像素级还原
3. **设计迭代** — 用 `iterate-design-draft --mode branch` 生成多个设计变体
4. **确认后扩展** — 用 `execute-flow-pages` 将确认的设计扩展到更多页面
5. **实现代码** — 设计确认后再编写实际代码

## 传递上下文文件

设计命令支持 `--context-file` 传入源码文件，让设计 Agent 理解现有 UI：

```bash
superdesign create-design-draft --project-id <id> --title "Dashboard" \
  -p "像素级还原当前页面" \
  --context-file .superdesign/design-system.md \
  --context-file src/pages/Dashboard.tsx:50 \
  --context-file src/components/Nav.tsx \
  --context-file src/styles/globals.css \
  --context-file tailwind.config.ts
```

支持行范围语法：`path:startLine:endLine`，用于跳过大段业务逻辑只保留 UI 代码。

## 项目结构

```
.agents/skills/superdesign/   # 技能核心文件（跨 Agent 通用）
  ├── SKILL.md                # 技能元信息与入口
  ├── SUPERDESIGN.md          # 设计 Agent SOP 与工作流
  └── INIT.md                 # 仓库分析指引
.claude/skills/superdesign    # Claude Code 符号链接
.superdesign/                 # 运行时生成（设计系统、初始化上下文等）
```
