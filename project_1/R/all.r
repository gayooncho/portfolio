police <- read.csv(file = "C:/project1/police_seoul.csv")

police
# 열 이름 변경 police_count, district
names(police) <- c("Police", "District")

# district 에 '서울'문자 제거
police$District <- gsub('서울 ','', police$District)
police

# 열 배열 변경
str(police)

police <- police[c(2,1)]
police


write.csv(police,"police_seoul.csv")

### 
# 서울시 면적 데이터 가져오기
seoul_area = read.csv(file = "C:/project1/seoul_area_gu.csv")

# 1. 새로운 데이터 프레임에 disctric, area, cctv
cctv_var_df <- data.frame(district = seoul_area$district
                            , area = seoul_area$area
                            , cctv = cctv$y2020)
cctv_var_df

# 2. 파생변수 추가 (cctv_var)
# cctv 개수는 정수로 변환을 위해 반올림
cctv_var_df$cctv_var <- round(cctv_var_df$cctv/cctv_var_df$area)
cctv_var_df

write.csv(cctv_var_df,"cctv_var_df.csv")

### 변수 통합
police = read.csv(file = "C:/project1/police_seoul.csv")
cctv = read.csv(file = "C:/project1/CCTV_seoul.csv")
one_house = read.csv(file = "C:/project1/Oneperson.csv")
pub = read.csv(file = "C:/project1/pub_seoul.csv")
crime  = read.csv(file = "C:/project1/crime_seoul.csv")

head(police)
head(cctv)
head(one_house)
head(pub)
head(crime)

# join 사용
library(plyr)
df = join_all(list(police, cctv, one_house, pub, crime), by="District", type = "full")
df <- subset(df, select = -c(X, District))
df

write.csv(df, "data_comb.csv")

###
# 계산을 위해 District 제거
new <- subset(new, select = -c(District))

# 이상치 확인
boxplot(new$Police)
boxplot(new$CCTV)
boxplot(new$Pub)
boxplot(new$Oneperson)
boxplot(new$Crime)

# 이상치 데이터 중구 데이터 제거
noju <- new[-24,]
noju

## 상관관계 확인
cor(new_df)
cor(noju_df)

library(PerformanceAnalytics)
chart.Correlation(new_df, histogram =, pch="+")
chart.Correlation(noju_df, histogram =, pch="+")

###
#유의하지 않은 변수 제거 - Police제거
new_po <- subset(new, select = -c(Police))

### vir 다중 공산성에 문제 있는지 확인
# install.packages("car")
library(car)
sqrt(vif(noju_lm))

# 회귀분석
## 중구제거
noju_lm <- lm(Crime ~ Oneperson + CCTV + Pub, data = new_po)
summary(noju_lm)

###
# 군집화
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

# 의사결정나무 <- 거의 불가
# install.packages("C50")
# library(C50)

# 경찰 없는 데이터
# cluster_df <- as.vector(cluster_df)
num <- c(1:25)
num

cluster_data <- data.frame(num, cluster_df)
str(cluster_data)
cluster_data

