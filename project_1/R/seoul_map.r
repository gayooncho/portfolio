# https://givitallugot.github.io/articles/2020-03/R-visualization-1-seoulmap
# 참조

install.packages("ggmap")
install.packages("ggplot2")
install.packages("raster")
install.packages("rgeos")
install.packages("maptools")
install.packages("rgdal")

library(ggmap)
library(ggplot2)
library(raster)
library(rgeos)
library(maptools)
library(rgdal)

# 지도 시각화

# 시각화 대상이 되는 내 데이터 셋 + 지도 그림 데이터 셋 = merge_data -> ggplot에 대입
# 내 데이터셋
df = read.csv(file = "data_comb.csv")
head(df)
# 필요없는 변수 제거
df <- subset(df, select = -c(X))

# 서울 지역구 아이디 df
seoul_id = read.csv(file = "seoul_id.csv")

# 시군구명을 중심으로 아이디 추가
names(seoul_id) <- c("District", "id")
head(seoul_id)

df_id <- merge(seoul_id, df)
df_id

#Crime데이터로 해보기

# 지리 정보 데이터셋
map <- shapefile("LARD_ADM_SECT_SGG_서울/LARD_ADM_SECT_SGG_11.shp") # 경고 메세지 뜨지만 지도는 제대로 뜸
library(dplyr)
map@polygons[[1]]@Polygons[[1]]@coords %>% head(n = 10L)
plot(map)
head(map)

# map을 spTransform()함수 이용하여 좌표계 변환 진행
map <- spTransform(map, CRSobj = CRS("+proj=longlat +ellps=WGS84 +no_defs"))
# map을 data frame으로 변환 fortify()함수 사용
seoul_map <- fortify(map, region="ADM_SECT_C")
View(seoul_map)

str(seoul_map)
# id num으로 변경
seoul_map$id <- as.numeric(seoul_map$id)
# id가 11740이하가 서울시 구에 해당 (서울시 데이터만 추출)
seoul_map <- seoul_map[seoul_map$id <= 11740,]

# 시각화 할 자료와 seoul_map 을 id로 합치기
seoul_data <- merge(seoul_map, df_id, by = "id")
head(seoul_data)


### 지도 그리기
ggplot() + geom_polygon(data = seoul_data, aes(x=long, y=lat, group=group), fill = "#ffffff", color="black")

#Crime데이터로 해보기 <- 굳이 필요 X
df_crime <- subset(df, select = c(District,Crime))
df_crime

df_crime_id <- merge(seoul_id, df_crime)
seoul_crime_data <- merge(seoul_map, df_crime_id, by = "id")

# fill 값에 기준이 되는 데이터를 넣어서 지도에 색을 넣을 수 있음
ggplot() + geom_polygon(data = seoul_data, aes(x=long, y=lat, group=group, fill = Oneperson))
# ggplot() + geom_polygon(data = seoul_crime_data, aes(x = long, y = lat, group = group, fill = A))
