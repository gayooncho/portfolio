# %%
import numpy as np
import pandas as pd

# %%
# hs / bec 파일 불러오기, excel 파일의 두번째 sheet
hs_bec = pd.read_excel('C:\project2\BEC5Correlations\HS2012-17-BEC5 -- 08 Nov 2018.xlsx'
                       , sheet_name = "HS17BEC5")

# hs4, hs6, bec, bec processing, bec specitication 목록만 별도로 추출
hs_bec = hs_bec[['HS4','HS6','BEC5Code1', 'BEC5Processing', 'BEC5Specification']]

# hs code -> code 이름변경
hs_bec.rename(columns={'HS4':'HS4', 'HS6':'HS', 'BEC5Code1':'BEC', }, inplace=True)

# %%
hs4_bec = hs_bec[['HS4','BEC']]

# hs4, bec코드 정리
hs4_bec['HS4'] = hs4_bec['HS4'].astype('int')


hs4_bec.dropna(axis=0, inplace= True)
# hs4_count = hs4_bec['HS4'].value_counts()
# hs4_count = pd.DataFrame(hs4_count)

# hs4_count.reset_index(inplace=True)
# hs4_count.columns = ['HS4', 'HS4_COUNT']
# hs4_bec.groupby('HS4').count()

hs4_bec['HS4'] = hs4_bec['HS4'].astype('int')
hs4_bec['BEC'] = hs4_bec['BEC'].astype('float')

# %%
hs4 = hs4_bec['HS4']

hs4.drop_duplicates(inplace=True)

hs4 = hs4.to_frame()

hs4.reset_index(inplace=True)
hs4.count()

# %%
# hs4에 대하여 bec 코드가 없는 행
# bec 값에 0

hs4_bec.loc[3513,'HS4'] = 0
hs4_bec.loc[3542,'HS4'] = 0

# %%
# hs4와 bec 사전 만들기

# from collections import defaultdict
# hs4_dict = defaultdict(list)
    
# hs4_bec.loc[0, 'HS4']
# for i in range(len(hs4)) :  # hs4코드만 있는 데이터 프레임 #1222개
#     hs4Temp = hs4.loc[i, 'HS4']
#     for j in range(len(hs4_bec)):   #hs4와 bec 코드가 함께 있음 # 5387개
#         hsbecTemp = hs4_bec.loc[j, 'HS4']
#         if hs4Temp == hsbecTemp and hs4_bec.loc[j, 'BEC'] not in hs4_dict[hs4Temp]:
#             hs4_dict[hs4Temp].append(hs4_bec.loc[j, 'BEC'])
#         pass

# import pickle

# with open('hs4_dict.pickle','wb') as fw:
#     pickle.dump(hs4_dict, fw)
# %%
# india exported 파일 불러오기
india_exported_list = pd.read_table('C:\project2\Trade_map_List_of_products_exported_and_imported\Trade_Map_-_List_of_products_exported_by_India.txt', sep = '\t')

# code -> hs로 컬럼 이름 변경
india_exported_list.rename(columns={'Code':'HS'}, inplace=True)
india_exported_list.head()

# %%
#   1) code 열에 total -> 0으로 변경
# korea_exported_list.loc[0, 'HS'] = 000000
# 제거
india_exported_list = india_exported_list.drop([india_exported_list.index[0]])

#   2) japan 데이터 프레임에 hs 코드 데이터 타입 형변환
india_exported_list['HS'] = pd.to_numeric(india_exported_list['HS'])

#   2) merge를 사용해 hs코드 기준으로 데이터 프레임 병합
india_exported_list = pd.merge(india_exported_list, hs_bec, how='left', on='HS')

#   2-1) hs 코드 자리수 맞춰주기 -> 5자리인경우 앞에 0붙여주기
india_exported_list['HS'] = india_exported_list['HS'].astype('str')
#       HS코드 6자리로 맞춰주기, 없는경우 left에 0으로 붙여줌
# india_exported_list['HS'].str.pad(width=6, side='left', fillchar='0')
india_exported_list['HS'] = india_exported_list['HS'].str.zfill(width=6)

#   2-2 hs코드 잘라서 hs4에 넣어주기
india_exported_list['HS4'] = india_exported_list['HS'].str.slice(0, 4)


india_exported_list.head()

# %%
no_exported_id = india_exported_list[(india_exported_list['Exported value in 2017'] == 0)
                    & (india_exported_list['Exported value in 2018'] == 0)
                    & (india_exported_list['Exported value in 2019'] == 0)
                    & (india_exported_list['Exported value in 2020'] == 0)
                    & (india_exported_list['Exported value in 2021'] == 0)].index

# 거래품목 없는 인덱스 제거
india_exported_list = india_exported_list.drop(no_exported_id)
india_exported_list.isnull().sum()

# %%
add_BEC = india_exported_list[india_exported_list['BEC'].isnull()]
# NaN값을 채워지기 위해 hs타입 형변환??
# add_BEC['HS'] = add_BEC['HS'].astype('float')
add_BEC

# 행을 늘려주기 위한 변수
hs4_count = hs4_bec.groupby('HS4').count()

# BEC 코드를 새로 부여하기 위해 기존 BEC 행 제거
add_BEC.drop(['BEC'], axis=1, inplace=True)

add_BEC.head()

# %%
## hs4 와 bec 개수 
hs4_bec_count = hs4_bec
# hs4와 bec 겹치는 행제거
hs4_bec_count.drop_duplicates(inplace=True)

# hs4별 bec 개수 데이터 프레임 : hs4_count 
hs4_count = hs4_bec_count.groupby('HS4').count()

# %%
hs4_count

# %%
hs4_count.loc[101]

# %%
add_BEC_index = (add_BEC.index).to_list()
hs4_count_index = (hs4_count.index).to_list()

### 행 늘리기 - how
# 1. 늘려야하는 행들 확인
# 2. n개로 행 늘려주기
for i in add_BEC_index:
    
    cur_hs4 = int(add_BEC.loc[i, 'HS4'])
    for j in hs4_count_index:
        j_item = int(j)
        count = int(hs4_count.loc[j_item])       # count개수만큼 행 추가
        # print(hs4Temp)
        #print(count, jIndex, com_key)
        if j_item == 3824 & cur_hs4 == 3824:
            print(count ,"hs4=",cur_hs4,"  ",j_item)
            
        if count > 1 and cur_hs4 == j_item:  # 추가해야할 행이 2개이상이고, com_key와 hs4Tmep이 같을 경우
            for m in range(count):  # count 개수만큼 행 추가
                add_BEC = pd.concat([add_BEC, add_BEC.loc[[i]]], ignore_index=True)
                    

# 금액 나누기
for i in add_BEC_index:
    com_key = int(add_BEC.loc[i, 'HS4'])
    for j in hs4_count_index:
        count = int(hs4_count.loc[j])       # count개수만큼 행 추가
        hs4Temp = int(j)
        if (count > 1) & (com_key == hs4Temp):
            for m in range(count):      # count 개수만큼 금액 나누기            
                add_BEC.loc[i,'Exported value in 2012'] = (add_BEC.loc[i, 'Exported value in 2012'] / count)
                add_BEC.loc[i,'Exported value in 2013'] = (add_BEC.loc[i, 'Exported value in 2013'] / count)
                add_BEC.loc[i,'Exported value in 2014'] = (add_BEC.loc[i, 'Exported value in 2014'] / count)
                add_BEC.loc[i,'Exported value in 2015'] = (add_BEC.loc[i, 'Exported value in 2015'] / count)
                add_BEC.loc[i,'Exported value in 2016'] = (add_BEC.loc[i, 'Exported value in 2016'] / count)
                add_BEC.loc[i,'Exported value in 2017'] = (add_BEC.loc[i, 'Exported value in 2017'] / count)
                add_BEC.loc[i,'Exported value in 2018'] = (add_BEC.loc[i, 'Exported value in 2018'] / count)
                add_BEC.loc[i,'Exported value in 2019'] = (add_BEC.loc[i, 'Exported value in 2019'] / count)
                add_BEC.loc[i,'Exported value in 2020'] = (add_BEC.loc[i, 'Exported value in 2020'] / count)
                add_BEC.loc[i,'Exported value in 2021'] = (add_BEC.loc[i, 'Exported value in 2021'] / count)



