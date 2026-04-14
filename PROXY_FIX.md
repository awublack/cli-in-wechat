# 代理配置解决方案

## 问题背景

- **需求**：需要同时使用 SOCKS 代理（Claude Code）和 HTTP 代理（Hermes Agent）
- **冲突**：Python `httpx` 库不支持 `socks://` 协议，但会优先读取 `ALL_PROXY` 环境变量
- **表现**：`cli-in-wechat` 启动时，Hermes Agent 初始化失败

## 环境变量说明

```bash
# SOCKS5 代理 - Claude Code 需要
ALL_PROXY=socks://192.168.0.108:7890/
all_proxy=socks://192.168.0.108:7890/

# HTTP 代理 - Hermes Agent (httpx) 支持
HTTP_PROXY=http://192.168.0.108:7890/
HTTPS_PROXY=http://192.168.0.108:7890/
http_proxy=http://192.168.0.108:7890/
https_proxy=http://192.168.0.108:7890/
```

## 解决方案

### 方案 1：使用启动脚本（推荐）

```bash
./start.sh
```

**原理**：启动前清除 `ALL_PROXY`，保留 `HTTP_PROXY/HTTPS_PROXY`

### 方案 2：使用 alias

先更新环境变量：
```bash
source ~/.bashrc
```

然后运行：
```bash
wcli-dev
```

### 方案 3：手动清除代理后运行

```bash
cd /home/awu/cli-in-wechat
unset ALL_PROXY all_proxy
export HTTP_PROXY="http://192.168.0.108:7890/"
export HTTPS_PROXY="http://192.168.0.108:7890/"
npm run dev
```

## 为什么这样可行？

1. **Claude Code**：使用 Node.js，支持 `socks://` 协议，但它在自己的进程内使用环境变量，不受影响
2. **Hermes Agent**：使用 Python `httpx` 库，当 `ALL_PROXY` 存在时会优先使用，清除后会自动使用 `HTTP_PROXY`
3. **cli-in-wechat**：作为桥接服务，本身不直接使用代理，只是传递环境变量

## 验证修复

运行启动脚本后，检查环境变量：
```bash
./start.sh
# 在另一个终端运行
env | grep -i proxy
```

应该看到：
- ✅ `ALL_PROXY` 和 `all_proxy` 已清除
- ✅ `HTTP_PROXY/HTTPS_PROXY` 保留
- ✅ Hermes Agent 正常初始化

## 注意事项

1. **不要全局清除 ALL_PROXY**：这会影响 Claude Code 的正常使用
2. **只在 cli-in-wechat 启动时清除**：使用启动脚本或 alias
3. **保持 HTTP 代理可用**：确保 `192.168.0.108:7890` 的 HTTP 代理服务正常运行

## 相关文件

- 启动脚本：`/home/awu/cli-in-wechat/start.sh`
- 配置说明：`/home/awu/cli-in-wechat/README.md`
- Bash 配置：`~/.bashrc`
