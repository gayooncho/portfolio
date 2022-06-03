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
