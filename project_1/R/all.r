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
