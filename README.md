# SuperDesign Skill

AI design skill for frontend UI/UX. Two versions included:

| Version | Path | Login? |
|---------|------|--------|
| **Open-source** (default) | `.agents/skills/superdesign/` | No |
| CLI-based | `.agents/skills/superdesign-cli-based/` | Yes |

## Open-source (recommended)

No CLI or login needed. Copy the skill files into your project:

```bash
mkdir -p .claude/skills
ln -s ../../.agents/skills/superdesign .claude/skills/superdesign
```

Then in Claude Code:

```
/superdesign help me design a dashboard
```

Designs are generated as self-contained HTML/Tailwind CSS files to `.superdesign/design_iterations/`. Open in browser to preview.

Based on [superdesigndev/superdesign](https://github.com/superdesigndev/superdesign) (MIT).

## CLI-based (requires login)

```bash
npm install -g @superdesign/cli@latest
superdesign login
```

See `.agents/skills/superdesign-cli-based/` for details. Uses remote API at `api.superdesign.dev`.

## Batch comparison

```bash
# Put design prompts in design_prompts/1.txt, 2.txt, 3.txt
./run_design.sh opensource all    # run open-source version
./run_design.sh cli all           # run CLI version
./run_design.sh both all          # run both, compare results
```

Results saved to `results/<mode>/prompt_N/`.
