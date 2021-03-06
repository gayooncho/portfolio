#===================================================================
### 위험지역 순위 계산해보기
# 지역안전지수 = 100 - (위해지표 + 취약지표 - 경감지표)
# 위해지표 - crime
# 경감지표 - cctv 
# 취약지표 - oneperson, pub
# 가중치 - 위해지표 50% == 0.5
#        - 취약지표 + 경감지표 = 50%
#        - oneperson(0.083) + pub(0.167) - cctv(0.25) = 0.5

# 안전지수 = 100 - {(0.5 x 면적당 5대 범죄 발생건수)
#                + (0.083 x 면적당 1인가구)
#                + (0.167 x 면적당 유흥주점)
#                - (0.25 x 면적당 cctv 개수 )}
#===================================================================

#===================================================================
# 파일 불러오기
#===================================================================
df = read.csv(file = "data_comb.csv")
head(df)

#===================================================================
# 불필요한 열 제거
#===================================================================
df <- subset(df, select = -c(X))
df_safety <- df
df_safety <- subset(df, select = -c(district))

#===================================================================
# 안전지수 계산
#===================================================================
df_safety$safety_var <- round(100 - ((0.5 * df_safety$crime)  # 위해지표
                            + (0.083 * df_safety$oneperson)  # 취약지표
                            + (0.167 * df_safety$pub)      # 취약지표
                            - (0.25 * df_safety$cctv)))    # 경감지표

#===================================================================
# 원시 데이터에서 구 이름 추출하여 안전지수 데이터에 추가
#===================================================================
df_safety$district <- df$district
head(df_safety)

#===================================================================
# rank 함수를 통해 위험한 지역순으로 정렬
#===================================================================
df_safety$rank <- round(rank(df_safety$safety_var))

library(doBy)
orderBy(~rank, df_nod)

