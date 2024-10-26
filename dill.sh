#!/bin/bash

# =============================================================================
# 脚本名称: install_dill_node.sh
# 作者: 子清
# 日期: 2024-04-27
# =============================================================================

# 设置脚本在遇到错误时退出
set -e

# 定义变量
DILL_VERSION="v1.0.3"
DILL_DIR="$HOME/dill"
DILL_SCRIPT_URL="https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/dill.sh"
DILL_SCRIPT_NAME="dill.sh"

# 函数：更新系统并安装必要的软件包
update_and_install() {
    echo "更新系统软件包数据库并升级已安装的软件包..."
    sudo apt-get update && sudo apt-get upgrade -y

    echo "安装必要的软件包（curl）..."
    sudo apt-get install -y curl
}

# 函数：创建 Dill 目录并进入
create_dill_directory() {
    echo "创建 Dill 目录并进入..."
    mkdir -p "$DILL_DIR" && cd "$DILL_DIR"
}

# 函数：下载并运行 Dill 节点脚本
download_and_run_dill_script() {
    echo "下载 Dill 节点脚本..."
    curl -sO "$DILL_SCRIPT_URL"

    echo "赋予脚本执行权限..."
    chmod +x "$DILL_SCRIPT_NAME"

    echo "运行 Dill 节点脚本..."
    ./"$DILL_SCRIPT_NAME"
}

# 函数：删除 Dill 压缩包
cleanup_dill_archive() {
    echo "清理 Dill 压缩包..."
    rm -rf "dill-$DILL_VERSION"* || echo "没有找到 Dill 压缩包，无需删除。"
}

# 函数：检查节点健康状态
check_health() {
    cd "$DILL_DIR/dill" || { echo "Dill 目录不存在，请确保节点已正确安装。"; return 1; }
    echo "检查节点健康状态..."
    ./health_check.sh -v
}

# 函数：查看验证者公钥
show_pubkey() {
    cd "$DILL_DIR/dill" || { echo "Dill 目录不存在，请确保节点已正确安装。"; return 1; }
    echo "查看验证者公钥..."
    ./show_pubkey.sh
}

# 函数：停止 Dill 节点
stop_dill_node() {
    cd "$DILL_DIR/dill" || { echo "Dill 目录不存在，请确保节点已正确安装。"; return 1; }
    echo "停止 Dill 节点..."
    ./stop_dill_node.sh
}

# 函数：启动 Dill 节点
start_dill_node() {
    cd "$DILL_DIR/dill" || { echo "Dill 目录不存在，请确保节点已正确安装。"; return 1; }
    echo "启动 Dill 节点..."
    ./start_dill_node.sh
}

# 函数：退出验证者
exit_validator() {
    cd "$DILL_DIR/dill" || { echo "Dill 目录不存在，请确保节点已正确安装。"; return 1; }
    echo "退出验证者..."
    ./exit_validator.sh
}

# 函数：显示主菜单
show_menu() {
    clear  # 每次显示菜单前清除屏幕
    # 每次显示菜单时下载并显示 logo
    curl -s https://raw.githubusercontent.com/ziqing888/logo.sh/refs/heads/main/logo.sh | bash
    sleep 3
    echo "============================================================"
    echo "                    Dill 节点管理主菜单"
    echo "============================================================"
    echo "1. 更新系统并安装必要依赖"
    echo "2. 创建 Dill 目录并启动节点安装"
    echo "3. 清理 Dill 压缩包"
    echo "4. 检查节点健康状态"
    echo "5. 查看验证者公钥"
    echo "6. 停止 Dill 节点"
    echo "7. 启动 Dill 节点"
    echo "8. 退出验证者"
    echo "9. 退出脚本"
    echo "============================================================"
}

# 函数：读取用户输入并执行操作
read_user_choice() {
    local choice
    read -p "请选择一个操作 [1-9]: " choice
    case $choice in
        1)
            update_and_install
            ;;
        2)
            create_dill_directory
            download_and_run_dill_script
            ;;
        3)
            cleanup_dill_archive
            ;;
        4)
            check_health
            ;;
        5)
            show_pubkey
            ;;
        6)
            stop_dill_node
            ;;
        7)
            start_dill_node
            ;;
        8)
            exit_validator
            ;;
        9)
            echo "退出脚本。"
            exit 0
            ;;
        *)
            echo "无效的选项，请重新选择。"
            ;;
    esac
}

# 主程序循环
while true; do
    show_menu
    read_user_choice
    echo ""
done
