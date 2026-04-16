#!/bin/bash
# BLstory 自动推送脚本 - 由土拨鼠调用
# 监控 writer agent 生成的新章节并自动推送

REPO_DIR="/home/administrator/.openclaw/workspaces/writer/BLstory"
cd "$REPO_DIR" || exit 1

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
    COMMIT_MSG="Add new chapter: $CHAPTER_NAME ($(date +%Y-%m-%d))"
else
    # 只有修改
    COMMIT_MSG="Update BLstory ($(date +%Y-%m-%d %H:%M))"
fi

git add .
git commit -m "$COMMIT_MSG"
git push origin main

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已推送: $COMMIT_MSG" >> /home/administrator/.openclaw/workspace/logs/blstory_push.log
