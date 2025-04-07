#!/bin/bash

# 检查目录是否存在
if [ ! -d "$@" ]; then
    echo "错误: 目录 '$@' 不存在"
    exit 1
fi

# 支持的图片和视频文件扩展名
IMAGE_EXTENSIONS=("jpg" "jpeg" "png" "gif" "bmp" "webp")
VIDEO_EXTENSIONS=("mp4" "avi" "mov" "mkv" "flv" "wmv")

# 生成随机字符串
generate_random_string() {
    openssl rand -base64 5
}

# 处理文件
process_file() {
    local file="$1"
    local original_md5=$(md5 -q "$file")
    local result="处理文件: $file\n原始MD5: $original_md5"
    
    # 生成随机字符串并追加到文件末尾
    local random_str=$(generate_random_string)
    echo "$random_str" >> "$file"
    
    local new_md5=$(md5 -q "$file")
    result="$result\n修改后MD5: $new_md5\n----------------------------------------"
    echo "$result"
}

# 收集所有结果
all_results=""

# 遍历目录
while IFS= read -r file; do
    # 获取文件扩展名（小写）
    extension=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')
    
    # 检查是否是图片或视频文件
    for img_ext in "${IMAGE_EXTENSIONS[@]}"; do
        if [ "$extension" = "$img_ext" ]; then
            all_results="$all_results\n$(process_file "$file")"
            break
        fi
    done
    
    for vid_ext in "${VIDEO_EXTENSIONS[@]}"; do
        if [ "$extension" = "$vid_ext" ]; then
            all_results="$all_results\n$(process_file "$file")"
            break
        fi
    done
done < <(find "$@" -type f)

# 显示结果弹窗
osascript -e "display alert \"文件处理完成\" message \"$all_results\""
