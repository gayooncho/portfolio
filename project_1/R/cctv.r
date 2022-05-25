library(ggplot2)
library(tidyverse)

file_out <- "C:/project1/cctv.csv"

cctv <- read.csv(file = "C:/project1/cctv.csv")

#cctv 연도별로 데이터 추출
cctv <- cctv[, c(1, 6, 11, 16, 21, 26, 31)]

head(cctv)

str(cctv)

# 숫자 계산 및 그래프를 원활하게 그리기 위해 [,] 제거
cctv$y2016 <- gsub("[,]", "", cctv$y2016)
str(cctv)

cctv$y2017 <- gsub("[,]", "", cctv$y2017)
cctv$y2018 <- gsub("[,]", "", cctv$y2018)
cctv$y2019 <- gsub("[,]", "", cctv$y2019)
cctv$y2020 <- gsub("[,]", "", cctv$y2020)
cctv$y2021 <- gsub("[,]", "", cctv$y2021)
str(cctv)

# chr 데이터타입 num으로 변환
cctv$y2016 <- as.numeric(cctv$y2016)
str(cctv)

cctv$y2017 <- as.numeric(cctv$y2017)
cctv$y2018 <- as.numeric(cctv$y2018)
cctv$y2019 <- as.numeric(cctv$y2019)
cctv$y2020 <- as.numeric(cctv$y2020)
cctv$y2021 <- as.numeric(cctv$y2021)
str(cctv)

class(cctv)


# 데이터프레임을 csv로 내보내기
write_csv(cctv,"cctv_change.csv", Encoding("utf-8"))
