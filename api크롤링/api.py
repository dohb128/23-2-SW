from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import mysql.connector
from datetime import datetime
import re

# 날짜 변환 함수
def convert_date_format(date_str):
    date_str = re.sub(r'\(.*?\)', '', date_str).strip()
    current_year = datetime.now().year
    return f"{current_year}-{date_str.replace('.', '-')}"

# 웹 드라이버 설정
DRIVER_PATH = 'D:\chromedriver-win64\chromedriver.exe'
driver = webdriver.Chrome(DRIVER_PATH)
driver.get("https://www.koreabaseball.com/Schedule/Schedule.aspx")

wait = WebDriverWait(driver, 30)
try:
    element = wait.until(EC.presence_of_element_located((By.ID, "tblScheduleList")))
except:
    print("요소를 찾을 수 없습니다.")

data = []
matches = driver.find_elements(By.CSS_SELECTOR, '#tblScheduleList tbody tr')
date = None
for match in matches:
    day_element = match.find_element(By.CSS_SELECTOR, 'td.day')
    if day_element:
        date = day_element.text.strip()

    time_info = match.find_element(By.CSS_SELECTOR, 'td.time').text if match.find_elements(By.CSS_SELECTOR, 'td.time') else None
    teams_elements = match.find_elements(By.CSS_SELECTOR, 'td.play span')

    if len(teams_elements) >= 2:  # 팀 이름이 존재하는 경우만 처리
        team1 = teams_elements[0].text.strip()
        team2 = teams_elements[-1].text.strip()  # 점수 등의 정보를 피하기 위해 마지막 요소 선택
        data.append([date, time_info, team1, team2])

driver.quit()

# 데이터베이스 연결 설정 및 커서 생성
conn = mysql.connector.connect(
    host="root",
    user="root",
    password="root43",
    database="matchs"
)
cursor = conn.cursor()

# 데이터 삽입
for row in data:
    date, time_info, team1, team2 = row
    formatted_date = convert_date_format(date)  # 날짜 문자열을 변환합니다.
    if formatted_date:
        cursor.execute("INSERT INTO kbo_matches (date, time, team1, team2) VALUES (%s, %s, %s, %s)", (formatted_date, time_info, team1, team2))

conn.commit()
cursor.close()
conn.close()

print(data)