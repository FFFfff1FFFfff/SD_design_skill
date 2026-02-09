#!/usr/bin/env bash
#
# run_design.sh — 对比运行开源版和 CLI 版 SuperDesign skill
#
# 用法:
#   ./run_design.sh opensource 1        # 用开源版运行 prompt 1
#   ./run_design.sh cli 2              # 用 CLI 版运行 prompt 2
#   ./run_design.sh opensource all     # 用开源版运行所有 prompt
#   ./run_design.sh both all           # 两个版本都跑，全部 prompt
#   ./run_design.sh both 1             # 两个版本都跑，只跑 prompt 1
#
# 结果保存到:
#   results/opensource/prompt_N/       # 开源版结果
#   results/cli-based/prompt_N/        # CLI 版结果
#

set -uo pipefail
# 注意：不用 set -e，因为 claude -p 可能返回非零退出码，不应中断整个流程

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

PROMPTS_DIR="design_prompts"
RESULTS_DIR="results"
ITERATIONS_DIR=".superdesign/design_iterations"
SKILL_LINK=".claude/skills/superdesign"

# ─── 颜色 ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

usage() {
    echo "用法: $0 <mode> <prompt_num>"
    echo ""
    echo "  mode:       opensource | cli | both"
    echo "  prompt_num: 1 | 2 | 3 | all"
    echo ""
    echo "示例:"
    echo "  $0 opensource 1       # 开源版跑 prompt 1"
    echo "  $0 both all          # 两版都跑，所有 prompt"
    exit 1
}

# ─── 检查前置条件 ───
check_prerequisites() {
    local mode="$1"

    if ! command -v claude &>/dev/null; then
        echo -e "${RED}错误: claude CLI 未安装。请先运行: npm install -g @anthropic-ai/claude-code${NC}"
        exit 1
    fi

    if [ "$mode" = "cli" ] || [ "$mode" = "both" ]; then
        if ! command -v superdesign &>/dev/null; then
            echo -e "${YELLOW}警告: superdesign CLI 未安装。CLI 版可能无法正常运行。${NC}"
            echo -e "${YELLOW}安装: npm install -g @superdesign/cli@latest && superdesign login${NC}"
            if [ "$mode" = "cli" ]; then
                echo -e "${RED}CLI 模式需要 superdesign CLI，退出${NC}"
                exit 1
            fi
            # both 模式下继续运行，CLI 版可能会失败但不影响 opensource
        fi
    fi
}

# ─── 切换 skill 版本 ───
switch_skill() {
    local mode="$1"
    local target

    if [ "$mode" = "opensource" ]; then
        target="../../.agents/skills/superdesign"
    elif [ "$mode" = "cli" ]; then
        target="../../.agents/skills/superdesign-cli-based"
    else
        echo -e "${RED}未知 mode: $mode${NC}"
        exit 1
    fi

    mkdir -p "$(dirname "$SKILL_LINK")"
    rm -f "$SKILL_LINK"
    ln -s "$target" "$SKILL_LINK"
    echo -e "${BLUE}已切换 skill 到: ${mode}${NC}"
}

# ─── 运行单个 prompt ───
run_single() {
    local mode="$1"
    local prompt_num="$2"
    local prompt_file="${PROMPTS_DIR}/${prompt_num}.txt"
    local result_dir="${RESULTS_DIR}/${mode}/prompt_${prompt_num}"

    # 检查 prompt 文件
    if [ ! -f "$prompt_file" ]; then
        echo -e "${RED}错误: prompt 文件不存在: ${prompt_file}${NC}"
        return 1
    fi

    local prompt_content
    prompt_content="$(cat "$prompt_file")"

    # 检查是否是占位内容
    if echo "$prompt_content" | grep -q "请将你的.*设计说明"; then
        echo -e "${YELLOW}跳过: ${prompt_file} 还是占位内容，请先填入实际的设计 prompt${NC}"
        return 0
    fi

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  模式: ${mode} | Prompt: ${prompt_num}${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Prompt 内容:${NC}"
    echo "$prompt_content" | head -5
    [ "$(wc -l < "$prompt_file")" -gt 5 ] && echo "  ..."
    echo ""

    # 切换 skill
    switch_skill "$mode"

    # 清理上次的设计迭代
    mkdir -p "$ITERATIONS_DIR"
    rm -rf "${ITERATIONS_DIR:?}"/*

    # 准备结果目录
    mkdir -p "$result_dir"

    # 构造完整 prompt
    local full_prompt
    full_prompt="/superdesign ${prompt_content}

IMPORTANT: This is a non-interactive run. Skip all confirmation steps and generate the final HTML design directly. Do NOT ask questions — make reasonable design decisions and proceed to generate the HTML file(s) to .superdesign/design_iterations/."

    echo -e "${BLUE}正在运行 Claude Code (${mode} 模式)...${NC}"
    echo -e "${YELLOW}这可能需要几分钟，请耐心等待...${NC}"

    # 运行 claude，将输出保存为日志
    local log_file="${result_dir}/claude_output.log"
    local start_time
    start_time=$(date +%s)

    claude -p "$full_prompt" \
        --output-format text \
        --max-turns 30 \
        > "$log_file" 2>&1 || true
    echo -e "${GREEN}Claude 运行完成${NC}"

    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo -e "${BLUE}耗时: ${duration}s${NC}"

    # 复制结果
    local count=0
    if [ -d "$ITERATIONS_DIR" ] && [ "$(ls -A "$ITERATIONS_DIR" 2>/dev/null)" ]; then
        cp "$ITERATIONS_DIR"/* "$result_dir/" 2>/dev/null || true
        count=$(find "$result_dir" -name "*.html" -o -name "*.css" | wc -l)
    fi

    # 保存元信息
    cat > "${result_dir}/meta.json" <<METAEOF
{
  "mode": "${mode}",
  "prompt_num": ${prompt_num},
  "prompt_file": "${prompt_file}",
  "duration_seconds": ${duration},
  "files_generated": ${count},
  "timestamp": "$(date -Iseconds)"
}
METAEOF

    if [ "$count" -gt 0 ]; then
        echo -e "${GREEN}生成了 ${count} 个设计文件，已保存到: ${result_dir}/${NC}"
        ls -1 "$result_dir"/*.html "$result_dir"/*.css 2>/dev/null | while read -r f; do
            echo -e "  ${GREEN}→ $(basename "$f")${NC}"
        done
    else
        echo -e "${YELLOW}未检测到生成的设计文件，请检查日志: ${log_file}${NC}"
    fi

    echo ""
}

# ─── 运行指定模式的所有/单个 prompt ───
run_mode() {
    local mode="$1"
    local prompt_num="$2"

    if [ "$prompt_num" = "all" ]; then
        for f in "$PROMPTS_DIR"/*.txt; do
            [ -f "$f" ] || continue
            local num
            num="$(basename "$f" .txt)"
            run_single "$mode" "$num" || echo -e "${YELLOW}prompt ${num} 运行异常，继续下一个...${NC}"
        done
    else
        run_single "$mode" "$prompt_num" || echo -e "${YELLOW}运行异常，检查日志${NC}"
    fi
}

# ─── 对比汇总 ───
print_summary() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  对比汇总${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""

    printf "%-10s %-12s %-8s %-10s %s\n" "Prompt" "Mode" "Files" "Time(s)" "目录"
    printf "%-10s %-12s %-8s %-10s %s\n" "------" "----" "-----" "-------" "----"

    for meta in "$RESULTS_DIR"/*/prompt_*/meta.json; do
        [ -f "$meta" ] || continue
        local mode prompt_num files duration dir
        mode=$(python3 -c "import json; print(json.load(open('$meta'))['mode'])" 2>/dev/null || echo "?")
        prompt_num=$(python3 -c "import json; print(json.load(open('$meta'))['prompt_num'])" 2>/dev/null || echo "?")
        files=$(python3 -c "import json; print(json.load(open('$meta'))['files_generated'])" 2>/dev/null || echo "?")
        duration=$(python3 -c "import json; print(json.load(open('$meta'))['duration_seconds'])" 2>/dev/null || echo "?")
        dir="$(dirname "$meta")"
        printf "%-10s %-12s %-8s %-10s %s\n" "$prompt_num" "$mode" "$files" "$duration" "$dir"
    done

    echo ""
    echo -e "${BLUE}用浏览器打开 results/ 下的 .html 文件即可对比设计效果${NC}"
}

# ─── 主流程 ───
main() {
    local mode="${1:-}"
    local prompt_num="${2:-}"

    [ -z "$mode" ] || [ -z "$prompt_num" ] && usage

    case "$mode" in
        opensource|cli)
            check_prerequisites "$mode"
            run_mode "$mode" "$prompt_num"
            ;;
        both)
            check_prerequisites "both"
            run_mode "opensource" "$prompt_num" || true
            run_mode "cli" "$prompt_num" || true
            ;;
        *)
            usage
            ;;
    esac

    # 跑完恢复到开源版
    switch_skill "opensource"

    print_summary
}

main "$@"
