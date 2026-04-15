#!/bin/bash
# BLstory GitHub 推送脚本
# 保存为 push.sh 然后执行

cd /home/administrator/.openclaw/workspaces/writer/BLstory

echo "🔧 设置 Git 配置..."
git config user.email "writer@localhost"
git config user.name "Novel Sister"

echo "🌐 使用 GitHub CLI 推送..."
gh auth login --web

echo "⬆️ 推送到远程仓库..."
git push -u origin main

echo "✅ 完成！"