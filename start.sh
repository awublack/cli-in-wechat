#!/bin/bash
# cli-in-wechat 启动脚本
# 清除不兼容的 SOCKS 代理 (ALL_PROXY)，保留 HTTP/HTTPS 代理
# 这样 Hermes Agent (httpx) 会使用 HTTP 代理而不是 SOCKS 代理

# 清除 ALL_PROXY (socks 协议与 Python httpx 不兼容)
# 但保留 HTTP_PROXY/HTTPS_PROXY (http 协议，httpx 支持)
unset ALL_PROXY
unset all_proxy

# 确保 HTTP/HTTPS 代理设置正确
export HTTP_PROXY="http://192.168.0.108:7890/"
export HTTPS_PROXY="http://192.168.0.108:7890/"
export http_proxy="http://192.168.0.108:7890/"
export https_proxy="http://192.168.0.108:7890/"
# 保持 no_proxy 不变

echo "✓ 已清除 ALL_PROXY (socks://) - 避免 httpx 协议错误"
echo "✓ 保留 HTTP_PROXY/HTTPS_PROXY (http://) - 正常网络访问"
echo "✓ Claude Code 仍可使用 SOCKS 代理（不受影响）"
echo ""

cd /home/awu/cli-in-wechat
npm run dev
