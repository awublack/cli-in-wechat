#!/bin/bash
# cli-in-wechat 重新登录脚本

echo "╔══════════════════════════════════════╗"
echo "║ cli-in-wechat - 重新登录             ║"
echo "╚══════════════════════════════════════╝"
echo ""

# 备份旧的认证文件
if [ -f ~/.wx-ai-bridge/credentials.json ]; then
    echo "发现已保存的登录信息..."
    echo "是否删除并重新登录？(y/N)"
    read -r response
    if [[ $response == "y" || $response == "Y" ]]; then
        mv ~/.wx-ai-bridge/credentials.json ~/.wx-ai-bridge/credentials.json.backup.$(date +%Y%m%d_%H%M%S)
        echo "已删除旧的登录信息"
    else
        echo "取消操作"
        exit 0
    fi
fi

# 启动程序
echo "启动微信 ClawBot 桥接服务..."
echo "请扫描二维码登录..."
echo ""

cd /home/awu/cli-in-wechat
npm run dev
