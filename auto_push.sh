#!/bin/bash
# BLstory 自动推送脚本 - 由土拨鼠调用
# 监控 writer agent 生成的新章节并自动推送

REPO_DIR="/home/administrator/.openclaw/workspaces/writer/BLstory"
cd "$REPO_DIR" || exit 1

# 检查网络连通性
if ! curl -s --max-time 10 https://github.com > /dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] GitHub 不可达，跳过推送" >> /home/administrator/.openclaw/workspace/logs/blstory_push.log
    exit 0
fi

# 检查是否有新内容
git status --porcelain > /dev/null 2>&1
if [ -z "$(git status --porcelain)" ]; then
    exit 0  # 没有变更，静默退出
fi

# 获取新增文件列表
NEW_FILES=$(git status --porcelain | grep "^??" | grep -oE "[0-9]+_第.*\.md" || true)

if [ -n "$NEW_FILES" ]; then
    # 有新增章节
    CHAPTER_NAME=$(echo "$NEW_FILES" | head -1 | sed 's/^[0-9]*_//' | sed 's/\.md$//')
    DATE_STR=$(date +%Y-%m-%d)
    COMMIT_MSG="Add new chapter: $CHAPTER_NAME ($DATE_STR)"
else
    # 只有修改
    DATE_STR=$(date +%Y-%m-%d_%H:%M)
    COMMIT_MSG="Update BLstory ($DATE_STR)"
fi

git add .
git commit -m "$COMMIT_MSG"

# 推送到 GitHub
if git push origin main 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已推送: $COMMIT_MSG" >> /home/administrator/.openclaw/workspace/logs/blstory_push.log
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 推送失败: $COMMIT_MSG" >> /home/administrator/.openclaw/workspace/logs/blstory_push.log
fi