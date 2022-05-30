# kmeans 평균 군집 분석 

df = read.csv(file = "data_comb.csv")
head(df)

# 필요없는 변수 제거
df <- subset(df, select = -c(District))

# 변수들 표준편차 0, 평균1로 표준화
df = scale(df)
df

# NbClust() :  최적의 군집개수를 알려주는 다양한 지표 제공
install.packages("NbClust")
library(NbClust)
set.seed(123)
nbC <- NbClust(df, distance = "euclidean", method = "kmeans", min.nc = 2, max.nc = 10)

nbC$Best.nc
table(nbC$Best.nc[1,])

#4개 또는 9개

set.seed(123)
clustering_km <- kmeans(df, centers = 4, nstart = 5)
clustering_km$cluster
clustering_km$centers
clustering_km$size


library(cluster)
clusplot(x = df,
        clus = clustering_km$cluster,
        color = TRUE, shade = TRUE,
        labels = 2, lines = 0, main = "Cluster Plot")
