df = read.csv(file = "data_comb.csv")
head(df)
df

df <- subset(df, select = -c(X))

# 이상치 제거  <- 중구
noju_df <- df[-24,]
noju_df

# 상관관계
noju_data <- subset(noju_df, select = -c(District))
cor(noju_data)

library(PerformanceAnalytics)
chart.Correlation(noju_data, histogram =, pch="+")

# library(ggcorrplot)
# ggcorrplot(cor(noju_data))

# 회귀분석
summary(lm(Crime ~ CCTV + Oneperson + Pub + Police, data = noju_df))
# CCTV > Oneperson > Pub 
# 결정계수 0.6302
# Police는 유의 x

# Kmeans 군집화 - Police 제거
nopo_df <- subset(df, select = -c(Police))
nopo_df
nopo_df_scale = scale(nopo_df)
library(NbClust)
nbC <- NbClust(nopo_df_scale, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 15)

nbC$Best.nc
# 가장 적절한 군집 개수
table(nbC$Best.nc[1,])  # 3개

clustering_km <- kmeans(nopo_df_scale, centers = 3, nstart = 15)
cluster_df <- clustering_km$cluster
clustering_km$centers
clustering_km$size

library(cluster)
clusplot(x = df_scale,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")

# Kmeans 군집화 - 중구 없이
noju_scale = scale(noju_data)
library(NbClust)
nbC <- NbClust(noju_scale, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 1)

nbC$Best.nc
# 가장 적절한 군집 개수
table(nbC$Best.nc[1,])  # 2개 중구가 없기 때문에

clustering_km <- kmeans(noju_scale, centers = 2, nstart = 15)
clustering_km$cluster
clustering_km$centers
clustering_km$size

library(cluster)
clusplot(x = noju_scale,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")


## Kmeans 군집화 - 중구 포함
df <- subset(df, select = -c(District))
df
df_scale = scale(df)
library(NbClust)
nbC <- NbClust(df_scale, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 10)

nbC$Best.nc
# 가장 적절한 군집 개수
table(nbC$Best.nc[1,])  # 4개

clustering_km <- kmeans(df_scale, centers = 4, nstart = 15)
clustering_km$cluster
clustering_km$centers
clustering_km$size

library(cluster)
clusplot(x = df_scale,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")

# 의사결정나무
install.packages("C50")
library(C50)

# 경찰 없는 데이터
# cluster_df <- as.vector(cluster_df)
num <- c(1:25)
num

cluster_data <- data.frame(num, cluster_df)
str(cluster_data)
cluster_data
# new_cluster <- nopo_df[]

# 군집별 구 분리
cluster_1 <- cluster_data[cluster_data$cluster_df == 1,]
cluster_1

cluster_2 <- cluster_data[cluster_data$cluster_df == 2,]
cluster_2
str(cluster_2)

cluster_3 <- cluster_data[cluster_data$cluster_df == 3,]
cluster_3

# 기존 데이터베이스에서 cluster별 데이터베이스 만들기
nopo_df
nopo_num_df <- data.frame(nopo_df, num)
nopo_num_df

cluster1_df <- nopo_num_df[cluster_1$num,]
cluster1_df

cluster2_df <- nopo_num_df[cluster_2$num,]
cluster2_df

cluster3_df <- nopo_num_df[cluster_3$num,]
cluster3_df

# 3개로 군집 분류
# Kmeans 다시 시작
set.seed(123)
cluster2_df <- subset(cluster2_df, select = -c(num))
cluster2_df_scale = scale(cluster2_df)
library(NbClust)
set.seed(123)
nbC <- NbClust(cluster2_df_scale, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 10)

nbC$Best.nc
# 가장 적절한 군집 개수
table(nbC$Best.nc[1,])  # 3개

clustering_km <- kmeans(cluster2_df_scale, centers = 4, nstart = 15)
important_area <- clustering_km$cluster
clustering_km$centers
clustering_km$size

library(cluster)
clusplot(x = cluster2_df_scale,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")


important_area
# 5, 11, 12 관악구, 동대문구, 동작구
# 군집중 가장 1인가구수가 높고 cctv 비율이 낮으며 범죄율이 높은곳
