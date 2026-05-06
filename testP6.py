def read_at_content(file_path):
    """
    读取文件，提取每行@字符后的内容
    :param file_path: 文件路径
    :return: 列表，每个元素为(行号, @后的内容)，无@则内容为None；读取失败返回None
    """
    content_list = []
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            for line_num, line in enumerate(f, 1):
                clean_line = line.strip()
                at_index = clean_line.find("@")

                if at_index == -1:
                    at_content = None
                else:
                    at_content = clean_line[at_index + 1 :].strip()

                content_list.append((line_num, at_content))

        return content_list

    except FileNotFoundError:
        print(f"❌ 错误：文件 [{file_path}] 不存在！")
        return None
    except UnicodeDecodeError:
        print(f"❌ 错误：文件 [{file_path}] 编码格式不是UTF-8（可尝试修改代码中的encoding参数为gbk）")
        return None
    except Exception as e:
        print(f"❌ 读取文件 [{file_path}] 时发生未知错误：{str(e)}")
        return None


def compare_at_content(file1, file2):
    """
    对比两个文件中每行@后的内容，仅输出第一处差异
    :param file1: 第一个文件路径（my.txt）
    :param file2: 第二个文件路径（ac.txt）
    """
    content1 = read_at_content(file1)
    content2 = read_at_content(file2)

    if content1 is None or content2 is None:
        return

    first_diff = None  # 仅存储第一处差异
    max_lines = max(len(content1), len(content2))

    # 逐行对比，找到第一处差异后立即退出循环
    for i in range(max_lines):
        line1 = content1[i] if i < len(content1) else (i + 1, None)
        line2 = content2[i] if i < len(content2) else (i + 1, None)

        line_num = i + 1
        c1 = line1[1]
        c2 = line2[1]

        if c1 != c2:
            if c1 is None and c2 is None:
                continue
            # 生成第一处差异的提示信息
            diff_msg = f"第{line_num}行："
            if c1 is None:
                diff_msg += f"{file1} 无@字符 | {file2} @后内容：{c2}"
            elif c2 is None:
                diff_msg += f"{file1} @后内容：{c1} | {file2} 无@字符"
            else:
                diff_msg += f"{file1} @后内容：{c1} | {file2} @后内容：{c2}"
            first_diff = diff_msg
            break  # 找到第一处差异后立即停止对比

    # 输出结果
    if first_diff is None:
        print(f"✅ {file1} 和 {file2} 中每行@字符后的内容完全一致！")
    else:
        print(f"❌ 发现第一处内容差异：")
        print(f"  {first_diff}")

    # 提示行数不一致（可选保留）
    if len(content1) != len(content2):
        print(f"\n⚠️  注意：文件行数不一致 —— {file1} 有 {len(content1)} 行，{file2} 有 {len(content2)} 行")


if __name__ == "__main__":
    FILE1 = "my.txt"
    FILE2 = "ac.txt"
    compare_at_content(FILE1, FILE2)
