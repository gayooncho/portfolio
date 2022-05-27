### 데이터 통합

# 데이터 목록 (불러오기)
# cctv
# onehouse
# police
# pub
# crime
# 

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
df <- subset(df, select = -c(X))
df

write.csv(df, "data_comb.csv")

