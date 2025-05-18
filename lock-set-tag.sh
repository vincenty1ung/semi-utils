#!/bin/bash

# 使用第一个参数作为目标目录，默认是当前目录
TARGET_DIR="${1:-.}"

# 查找被锁定的文件（含uchg属性）
# shellcheck disable=SC2010
locked_files=$(ls -lO "$TARGET_DIR" | grep uchg | awk '{print $NF}')

# 遍历每个被锁定的文件
for nef_file in $locked_files; do
    # 原始文件完整路径
    nef_path="$TARGET_DIR/$nef_file"

    # 替换扩展名 .NEF -> .JPG
    jpg_file="${nef_file%.NEF}.JPG"
    jpg_path="$TARGET_DIR/$jpg_file"

    # 判断JPG文件是否存在
    if [ -f "$jpg_path" ]; then
        echo "Tagging JPG: $jpg_path"
        tag --add like "$jpg_path"
    else
        echo "JPG not found. Tagging original: $nef_path"
        tag --add like "$nef_path"
    fi
done