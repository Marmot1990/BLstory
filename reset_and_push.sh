#!/bin/bash
# 清空 GitHub 仓库并重新上传本地内容

cd /home/administrator/.openclaw/workspaces/writer/BLstory

echo "🗑️  删除 GitHub 上的所有旧文件..."
git ls-tree -r HEAD --name-only | xargs -I {} git rm -f "{}" 2>/dev/null || true
git commit -m "清除旧内容，准备重新上传" --allow-empty

echo "📦 添加本地新文件..."
git add .
git commit -m "重新上传：全新的 BLstory 第1-4章 (Gemma 4 19B生成)"

echo "⬆️ 推送到 GitHub..."
git push origin main --force

echo "✅ 完成！"