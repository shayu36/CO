import requests
import json
import time
import datetime

# 请在这里直接填写你的学号和密码
student_id = "24373313" ""  # <--- 在这里填入学号
password = "jxy4321."  # <--- 在这里填入密码060828lsy

# --- 新增代码：获取用户指定的开始日期 ---
while True:
    start_date_str = input("请输入你想要开始打卡的日期 (格式 YYYY-MM-DD，例如 2024-09-01): ")
    try:
        # 尝试将输入的字符串转换为 datetime 对象
        # 注意：strptime 创建的 datetime 对象时间部分默认为 00:00:00
        # 这对于日期迭代没有影响，因为我们只关心日期部分
        custom_start_date = datetime.datetime.strptime(start_date_str, "%Y-%m-%d")
        break  # 如果转换成功，跳出循环
    except ValueError:
        print("日期格式错误，请输入 YYYY-MM-DD 格式的有效日期。请重试。")

# 使用用户输入的日期作为 today 变量
today = custom_start_date
# --- 新增代码结束 ---

# 获取用户id和sessionId，为查询课表和根据课表打卡做准备
url = "https://iclass.buaa.edu.cn:8346/app/user/login.action"
para = {
    "password": password,  # 使用变量 'password'
    "phone": student_id,  # 使用变量 'student_id'
    "userLevel": "1",
    "verificationType": "2",
    "verificationUrl": "",
}

res = requests.get(url=url, params=para)
userData = json.loads(res.text)
userId = userData["result"]["id"]
sessionId = userData["result"]["sessionId"]

cnt = 0  # 连续没课的天数，超过7天说明放假了
# today = datetime.datetime.today() # <--- 注释或删除这行，因为上面已经设置了 today

for i in range(120):
    if cnt == 7:
        break

    date_loop = today + datetime.timedelta(days=i)  # 使用不同的变量名避免覆盖
    dateStr = date_loop.strftime("%Y%m%d")

    # 查询课表
    url = "https://iclass.buaa.edu.cn:8346/app/course/get_stu_course_sched.action"
    para = {"dateStr": dateStr, "id": userId}
    headers = {
        "sessionId": sessionId,
    }
    res = requests.get(url=url, params=para, headers=headers)
    json_data = json.loads(res.text)
    # 严格遵循原始代码的判断逻辑
    if json_data["STATUS"] == "0":
        cnt = 0
        # 严格遵循原始代码的迭代逻辑 (如果 'result' 不存在会报错)
        for item in json_data["result"]:
            courseSchedId = item["id"]
            # --- 先提取课程信息用于确认提示 ---
            classBeginTime = item["classBeginTime"]
            classEndTime = item["classEndTime"]
            date_display = classBeginTime[:10]  # 使用新变量名显示日期
            begin = classBeginTime[11:16]
            end = classEndTime[11:16]
            courseName = item["courseName"]

            # --- 新增：用户确认打卡 ---
            confirmation = input(
                f"是否为这节课打卡: {date_display}\t{courseName}\t{begin}-{end} (输入 'y' 确认, 其他任意键跳过)? "
            ).lower()

            if confirmation == "y":
                # --- 用户确认后，执行原始的打卡代码 ---
                params = {"id": userId}
                current_timestamp_seconds = time.time()
                current_timestamp_milliseconds = int(current_timestamp_seconds * 1000)
                str = f"http://iclass.buaa.edu.cn:8081/app/course/stu_scan_sign.action?courseSchedId={courseSchedId}&timestamp={current_timestamp_milliseconds}"
                r = requests.post(url=str, params=params)

                # 严格使用原始的后续处理代码，包括变量名 'date' 的重新赋值
                classBeginTime = item["classBeginTime"]  # 原始代码在这里有多余的重复赋值，保留
                classEndTime = item["classEndTime"]  # 原始代码在这里有多余的重复赋值，保留
                date = classBeginTime[:10]  # 原始代码在这里重新赋值了 date 变量，保留
                begin = classBeginTime[11:16]  # 原始代码在这里有多余的重复赋值，保留
                end = classEndTime[11:16]  # 原始代码在这里有多余的重复赋值，保留

                # 严格使用原始的判断和打印逻辑
                if r.ok:
                    # 原始代码在这里尝试解析，如果失败会异常退出，保留此行为
                    data = json.loads(r.text)
                    # 原始代码的判断逻辑
                    if data["STATUS"] == "1":
                        print(f"疑似这节课没开扫码签到:{date}\t{item['courseName']}\t{begin}-{end}")
                    # 原始代码无论STATUS如何都会打印这句，保留此行为
                    print(f"已打卡：{date}\t{item['courseName']}\t{begin}-{end}")
                else:
                    # 原始代码的失败打印逻辑
                    print(f"不知道发生什么了但是打卡失败了喵：{date}\t{item['courseName']}\t{begin}-{end}")
                # --- 原始打卡代码结束 ---
            else:
                # --- 用户选择跳过 ---
                print(f"已跳过打卡: {date_display}\t{courseName}\t{begin}-{end}")
            # --- 用户确认结束 ---

    # 严格遵循原始代码的 else 逻辑
    else:
        cnt += 1
