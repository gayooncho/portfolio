df = read.csv(file = "data_comb.csv")
head(df)

#========================================================
# 상관관계 확인
#========================================================
# 불필요한 열 제거
#========================================================
df <- subset(df, select = -c(X, District))

#========================================================
# 상관관계 확인
#========================================================
cor(df, method = "pearson")

#========================================================
# 산점행렬도 그래프를 통한 데이터 분석
#========================================================
library(PerformanceAnalytics)
chart.Correlation(df, histogram =, pch="+")

#========================================================
### 회귀분석
#========================================================
# 통계 분석 (ANOVA) F-통계량 확인
#========================================================
df_lm <- (lm(df$crime ~ df$cctv + df$oneperson + df$pub, df$police, data = df))

anova(df_lm)
#========================================================
# P-value 값이 0.05보다 큰 police를 제외한 나머지 변수들은 회귀모델 구축에 유의미한 영향력을 가짐
#========================================================


#========================================================
# vir 다중 공산성 확인
#========================================================
install.packages("car")
library(car)
vif(df_lm)
#========================================================
# vif 값이 10보다 작기 때문에 서로 각각의 변수들과 상관 정도가 높지 않아서 회귀 분석 모델 결과 분석 시 부정적 영향을 미치지 않음
#========================================================

#========================================================
# 다중 회귀분석
#========================================================
summary(df_lm)

#========================================================
# 변수 선택법 - 전진선택법, 후진소거법, 단계별 선택법
#========================================================
step(df_lm, scope = list(lower = ~1, upper = ~df$CCTV + df$Oneperson + df$Pub + df$Police), direction = "forward")

step(df_lm, scope = list(lower = ~1, upper = ~df$CCTV + df$Oneperson + df$Pub + df$Police), direction = "backward")

step(df_lm, scope = list(lower = ~1, upper = ~df$CCTV + df$Oneperson + df$Pub + df$Police), direction = "forward")

#========================================================
# crime에 영향을 미치는 요인은 pub, cctv, oneperson 변수로 확인
#========================================================


#========================================================
# K-means 군집화
#========================================================

#========================================================
# 다중 회귀분석에서 유의하지 않은 변수 제거
#========================================================
df <- subset(df,select = -c(police))

#========================================================
# 표준편차 0, 평균1로 표준화
#========================================================
df_scale = scale(df)
head(df_scale)

#========================================================
# NbClust() :  최적의 군집개수를 알려주는 다양한 지표 제공
#========================================================
install.packages("NbClust")
library(NbClust)
set.seed(123)

#========================================================
# 유클리드 거리 / kmeans 군집 / 최소 군집 2개, 최대 군집 10개
#========================================================
nbC <- NbClust(df_scale, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 10)

#========================================================
# 최적의 군집개수 확인
#========================================================
nbC$Best.nc
table(nbC$Best.nc[1,])

#========================================================
# 3개 군집으로 분류
#========================================================
clustering_km <- kmeans(df_scale, centers = 3, nstart = 15)
clustering_km$cluster
clustering_km$centers
clustering_km$size

#========================================================
# 군집데이터 시각화
#========================================================
library(cluster)
clusplot(x = df,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")

