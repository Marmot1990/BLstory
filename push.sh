#!/bin/bash
# BLstory GitHub 自动推送脚本
# 由 Writer Agent 调用，每次生成新章节后自动推送

REPO_DIR="/home/administrator/.openclaw/workspaces/writer/BLstory"
cd "$REPO_DIR" || exit 1

# 检查是否有变更
if [ -z "$(git status --porcelain)" ]; then
    echo "📭 没有变更需要推送"
    exit 0
fi

# 添加所有变更
echo "📝 添加变更..."
git add .

# 获取最新章节号用于提交信息
LATEST_CHAPTER=$(git status --porcelain | grep -oE '[0-9]+_第[一二三四五六七八九十]+章' | head -1 || echo "新内容")
COMMIT_MSG="Add ${LATEST_CHAPTER:-更新内容} $(date +%Y-%m-%d_%H:%M)"

echo "💾 提交: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "⬆️ 推送到 GitHub..."
git push origin main

echo "✅ 完成！"
