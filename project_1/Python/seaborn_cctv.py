import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns

# 한글 깨짐 문제
from matplotlib import font_manager, rc

sns.set(style = "darkgrid")

# mpl.rcParams['axes.unicode_minus'] = False
%matplotlib inline

### 필요한 파일 불러오기
cctv = pd.read_csv("C:/project1/cctv_plz.csv", encoding="euc-kr")
cctv.head()

safe_dis_list = ['강북구', '노원구', '도봉구', '종로구', '서초구']
danger_dis_list = ['동대문구', '동작구', '관악구', '중구', '광진구']

# 안전지역 데이터 추출
safe_district = cctv[cctv['district'].isin(safe_dis_list)]

# 위험지역 데이터 추출
danger_district = cctv[cctv['district'].isin(danger_dis_list)]

### 한글 깨짐
font_name = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
rc('font', family=font_name)

# 안전지역 cctv 증가 대수 
sns.lineplot(x = 'district', y = '증가 대수', hue="year", data = safe_district)
# 위험지역 cctv 증가 대수 
sns.lineplot(x = 'district', y = '증가 대수', hue="year", data = danger_district)

sns.lineplot(x = 'year', y = '증감비', hue="district", data = danger_district)
## 2017, 2018 데이터 제거하는게 깔끔
## 2020, 2021 증감비 감소

sns.lineplot(x = 'year', y = '증감비', hue="district", data = safe_district)

sns.barplot(x = 'district', y = 'cctv', hue='year', data = safe_district) 

## danger 지역 연도별 cctv 개수 현황
sns.barplot(x = 'district', y = 'cctv', hue='year', data = danger_district)


### 안전지역 1(종로구), 위험지역 3(동대문구, 동작구, 관악구) 데이터 추출
new_dis_list = ['종로구', '동대문구', '동작구', '관악구']

# 안전지역 데이터 추출
new_district = cctv[cctv['district'].isin(new_dis_list)]

# 2017년 데이터 지우기
# new_cctv2017 = new_district[new_district['year'] == '2017'].index
# new_district.drop(new_cctv2017, inplace=True)

new_district = new_district[new_district.year != 2017]
new_district = new_district[new_district.year != 2018]
new_district = new_district[new_district.year != 2019]
new_district.head()


# 연도 실수로 표시
from matplotlib.ticker import MaxNLocator

new_g = sns.lineplot(x = "year", y = '증감비', hue="district",
                     style='district', 
                     markers= True, 
                     dashes=False, 
                     data = new_district)

new_g.xaxis.set_major_locator(MaxNLocator(integer=True))

### 안전지역 1, 위험지역 1 데이터 추출
jodo_dis_list = ['종로구', '동작구']

# 안전지역 데이터 추출
jodo_district = cctv[cctv['district'].isin(jodo_dis_list)]

# 2017년 데이터 지우기
# new_cctv2017 = new_district[new_district['year'] == '2017'].index
# new_district.drop(new_cctv2017, inplace=True)

jodo_district = jodo_district[jodo_district.year != 2017]
jodo_district = jodo_district[jodo_district.year != 2018]
jodo_district = jodo_district[jodo_district.year != 2019]


# 선 그래프 그리기
jodo_g = sns.lineplot(x = "year", y = '증감비', hue="district",
                     style='district', 
                     markers= True, 
                     dashes=False, 
                     data = jodo_district)
