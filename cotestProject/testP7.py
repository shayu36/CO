def compare_files_at_content(file1_path, file2_path):
    """
    比较两个文件中每一行@字符后的内容是否完全一致
    返回第一处不同所在的行数和不同的内容
    """
    try:
        # 读取两个文件
        with open(file1_path, 'r', encoding='utf-8') as f1, \
             open(file2_path, 'r', encoding='utf-8') as f2:
            lines1 = f1.readlines()
            lines2 = f2.readlines()
    
    except FileNotFoundError as e:
        return f"文件读取错误: {e}", None
    except Exception as e:
        return f"读取文件时发生错误: {e}", None
    
    # 检查文件行数是否一致
    if len(lines1) != len(lines2):
        return f"文件行数不同: {file1_path}有{len(lines1)}行, {file2_path}有{len(lines2)}行", None
    
    # 逐行比较
    for i, (line1, line2) in enumerate(zip(lines1, lines2), start=1):
        # 处理文件中的空白字符
        line1 = line1.rstrip('\n')
        line2 = line2.rstrip('\n')
        
        # 提取@符号后的内容
        if '@' in line1:
            content1 = line1.split('@', 1)[1].strip()
        else:
            content1 = line1.strip()
        
        if '@' in line2:
            content2 = line2.split('@', 1)[1].strip()
        else:
            content2 = line2.strip()
        
        # 比较内容
        if content1 != content2:
            return f"行 {i}: {file1_path}中为'{content1}', {file2_path}中为'{content2}'", i
    
    # 如果所有行都一致
    return "两个文件中@符号后的内容完全一致", None

def main():
    # 指定要比较的文件路径
    file1 = "ac.txt"
    file2 = "my.txt"
    
    # 执行比较
    result, line_num = compare_files_at_content(file1, file2)
    
    # 输出结果
    print(f"比较文件: {file1} 和 {file2}")
    print("-" * 50)
    
    if line_num is not None:
        print(f"发现第一处不同在第 {line_num} 行")
        print(f"差异内容: {result}")
    else:
        print(result)

if __name__ == "__main__":
    main()