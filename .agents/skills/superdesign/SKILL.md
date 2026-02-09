---
name: superdesign
description: >
  Open-source design agent for frontend UI/UX. Generates HTML/Tailwind CSS design files locally
  without any login or external backend. Usage: /superdesign help me design X — generates designs
  to .superdesign/design_iterations/ that you can open in a browser to preview.
  No CLI login required. Powered by the open-source SuperDesign project (MIT).
metadata:
  author: superdesigndev (open-source adaptation)
  version: "1.0.0"
  license: MIT
  source: https://github.com/superdesigndev/superdesign
---

SuperDesign (Open-Source) — generates and iterates UI design drafts as local HTML/Tailwind CSS files. No login, no external API, no CLI required.

---

# Core scenarios

1. **superdesign init** — Analyze the repo and build UI context to `.superdesign/init/`
2. **Help me design X** — Design a new page/component/flow
3. **Help me improve design of X** — Redesign or iterate an existing UI
4. **Set design system** — Create or update `.superdesign/design-system.md`

# Init: Repo Analysis

When `.superdesign/init/` directory doesn't exist or is empty, you MUST automatically:

1. Create the `.superdesign/init/` directory
2. Follow the INIT.md instructions in this skill folder to analyze the repo and write context files

Do NOT ask the user to do this manually — just do it.

# Mandatory Init Files

If `.superdesign/init/` exists, you MUST read ALL files in this directory FIRST before any design task:

- `components.md` — shared UI primitives with full source code
- `layouts.md` — shared layout components (nav, sidebar, header, footer)
- `routes.md` — page/route mapping
- `theme.md` — design tokens, CSS variables, Tailwind config
- `pages.md` — page component dependency trees

**When designing for an existing page**: check `pages.md` for the dependency tree. Every file in the tree should be read for UI context.

# How it works

Follow the instructions in SUPERDESIGN.md in this skill folder. Key points:

- Designs are generated as **self-contained HTML files** with Tailwind CSS via CDN
- Output goes to `.superdesign/design_iterations/`
- For existing UI: first do a pixel-perfect reproduction, then iterate with variations
- For new projects: follow the 4-step workflow (Layout → Theme → Animation → HTML)
- User previews designs by opening the HTML files in a browser
- No external service, CLI, or login needed — everything runs locally through Claude
