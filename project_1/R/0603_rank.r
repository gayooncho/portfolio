### 안전지수 계산해보기?
# 지역안전지수 = 100 - (위해지표 + 취약지표 - 경감지표)
# 위해지표 - crime
# 경감지표 - cctv 
# 취약지표 - oneperson, pub
# 가중치 - 위해지표 50% == 0.5
#        - 취약지표 + 경감지표 = 50%
#        - oneperson(0.083) + pub(0.167) - cctv(0.25) = 0.5
#         유의확률에 따른 계산


# 안전지수 = 100 - {(0.5 x 면적당 5대 범죄 발생건수)
#                + (0.083 x 면적당 1인가구)
#                + (0.167 x 면적당 유흥주점)
#                - (0.25 x 면적당 cctv 개수 )}

df = read.csv(file = "data_comb.csv")
head(df)
# df_scale = scale(df)

df <- subset(df, select = -c(X))
df_nod <- df
df_nod <- subset(df, select = -c(District))

# head(df_scale)
# class(df_scale)
# df_scale <- as.data.frame(df_scale)
# 안전지수 계산
df_nod$safety_var <- round(100 - ((0.5 * df_nod$Crime)  # 위해지표
                            + (0.083 * df_nod$Oneperson)  # 취약지표
                            + (0.167 * df_nod$Pub)      # 취약지표
                            - (0.25 * df_nod$CCTV)))    # 경감지표

# df_scale$safety_var <- round(100 - ((0.5 * df_scale$Crime) 
#                             + (0.083 * df_scale$Oneperson) 
#                             + (0.167 * df_scale$Pub)
#                             - (0.25 * df_scale$CCTV)))

# df_scale$safety_var <- round(100 - df_scale)

df
df_nod
df_nod$District <- df$District


df_nod$Rank <- round(rank(df_nod$safety_var))

library(doBy)
orderBy(~Rank, df_nod)
df_nod
# 동대문구, 동작구, 관악구, 중구 ...

write.csv(df_nod, file = "df_rank.csv")
