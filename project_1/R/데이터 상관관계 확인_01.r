df = read.csv(file = "data_comb.csv")

df

# 문자열 제거 District
df <- subset(df, select = -c(X, District))

pairs(df)
cor(df)
library(ggcorrplot)
ggcorrplot(cor(df))

# 각각 데이터의 이상치 확인
boxplot(df$Police)
boxplot(df$CCTV)
boxplot(df$Pub)
boxplot(df$Oneperson)
boxplot(df$Crime)

# 이상치 데이터 -중구- 제거
df_noju <- df[-24,]
df_noju
df_noju <- subset(df_noju, select = -c(X, District))

# 피어슨 상관계수 확인
cor(df_noju, method = "pearson")

# 차트에 밀도 곡선, 상관성, 유의확률(별표)추가
# 상관성, P값 정규분표 시각화? - 모수 검정 조건??
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
chart.Correlation(df_noju, histogram =, pch="+")

# 참조 
# https://kerpect.tistory.com/152
