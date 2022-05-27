df = read.csv(file = "data_comb.csv")

df

# 문자열 제거 District
df <- subset(df, select = -c(X, District))

pairs(df)
cor(df)
library(ggcorrplot)
ggcorrplot(cor(df))

# Oneperson의 단위수가 크기 때문에 boxplot을 위해 제거
df_oneD <- subset(df, select = -c(Oneperson))

# 각각 데이터의 이상치 확인
boxplot(df$Police)
boxplot(df$CCTV)
boxplot(df$Pub)
boxplot(df$Oneperson)
boxplot(df$Crime)

