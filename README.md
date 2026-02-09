# SuperDesign Skill

AI 设计技能，为前端 UI/UX 设计提供智能辅助。本仓库包含两个版本：

| 版本 | 路径 | 需要登录？ | 说明 |
|------|------|-----------|------|
| **开源版**（默认） | `.agents/skills/superdesign/` | **不需要** | 基于 [superdesigndev/superdesign](https://github.com/superdesigndev/superdesign)（MIT），Claude 直接生成 HTML/CSS 设计稿 |
| CLI 版 | `.agents/skills/superdesign-cli-based/` | 需要 | 基于 [app.superdesign.dev](https://app.superdesign.dev/) 闭源后端，需 `superdesign login` |

---

## 开源版（推荐）

### 安装

无需安装任何 CLI 或登录。只需将 skill 文件放入项目即可。

**方式一：使用 npx skills（自动）**

```bash
npx skills add superdesigndev/superdesign-skill --yes
```

然后将 `.agents/skills/superdesign/` 下的三个文件替换为本仓库 `.agents/skills/superdesign/` 中的开源版文件。

**方式二：手动复制**

将以下文件复制到你的项目中：

```
.agents/skills/superdesign/
  ├── SKILL.md
  ├── SUPERDESIGN.md
  └── INIT.md
```

为 Claude Code 创建符号链接：

```bash
mkdir -p .claude/skills
ln -s ../../.agents/skills/superdesign .claude/skills/superdesign
```

### 使用

在 Claude Code 中：

```
/superdesign help me design a dashboard
```

### 工作原理

1. Claude 读取 skill 指令，扮演高级前端设计师
2. 分析现有代码库（如果有的话），收集 UI 上下文
3. 直接生成 **自包含的 HTML/Tailwind CSS 文件** 到 `.superdesign/design_iterations/`
4. 用浏览器打开 HTML 文件即可预览设计

### 设计工作流

**新项目：**
1. Layout — 用 ASCII 线框图呈现布局，确认后继续
2. Theme — 生成 CSS 主题文件（颜色、字体、间距、阴影）
3. Animation — 设计微交互和过渡动画
4. HTML — 生成完整的自包含 HTML 设计稿（默认 2 个变体）

**现有项目：**
1. Init — 自动分析项目结构，生成上下文文件到 `.superdesign/init/`
2. 像素级还原 — 先生成当前 UI 的精确还原
3. 设计变体 — 基于还原版本生成设计变体
4. 迭代 — 根据反馈持续迭代

### 技术细节

- 输出格式：单文件 HTML，内联 Tailwind CSS（CDN）
- UI 库：Flowbite（默认）
- 图标：Lucide Icons（CDN）
- 字体：Google Fonts
- 间距系统：严格 4pt/8pt 网格
- 响应式：移动端 / 平板 / 桌面端
- 无图片：使用 CSS 占位符或公共图片 URL

---

## CLI 版（需登录）

如果你需要使用 SuperDesign 的远端设计服务：

### 安装

```bash
npm install -g @superdesign/cli@latest
superdesign login
```

### 使用

参考 `.agents/skills/superdesign-cli-based/` 中的 SKILL.md 和 SUPERDESIGN.md。

CLI 版通过 `superdesign` 命令调用远端 API（`api.superdesign.dev`）生成设计，所有设计命令都需要先登录。

---

## 项目结构

```
.agents/skills/
  ├── superdesign/              # 开源版 skill（默认激活）
  │   ├── SKILL.md              # 技能元信息与入口
  │   ├── SUPERDESIGN.md        # 设计 Agent SOP 与工作流
  │   └── INIT.md               # 仓库分析指引
  ├── superdesign-cli-based/    # CLI 版 skill（需登录，仅供对比）
  │   ├── SKILL.md
  │   ├── SUPERDESIGN.md
  │   └── INIT.md
.claude/skills/
  └── superdesign -> ../../.agents/skills/superdesign  # 符号链接指向开源版
.superdesign/                   # 运行时生成
  ├── design-system.md          # 设计系统定义
  ├── design_iterations/        # 生成的 HTML 设计稿
  └── init/                     # 项目上下文分析结果
```
