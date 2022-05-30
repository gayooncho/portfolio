# Kmeans another
df = read.csv(file = "data_comb.csv")
head(df)

# 필요없는 변수 제거
df <- subset(df, select = -c(X))

head(df)

# 1. scale 
# District 제거
df_D <- subset(df, select = -c(District))
df_scale <- scale(df_D)

head(df_scale)

# 2. 거리 구하기
df_D <- dist(df_scale)

# 3. clusters 구하기
# install.packages("factoextra")
library(factoextra)
fviz_nbclust(df_scale, kmeans, method = "wss") + labs(subtitle = "Elbow method")

# Kmeans
km_out <- kmeans(df_scale, centers = 4, nstart = 100)
print(km_out)

km_clusters <- km_out$cluster

rownames(df_scale) <- paste(df$District)
df_scale

# 시각화 
fviz_cluster(list(data  = df_scale, cluster = km_clusters))
table(km_clusters, df$District)


