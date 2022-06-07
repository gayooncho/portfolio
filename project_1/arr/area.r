#=========================================================
# csv 파일 가져오기
#=========================================================
area = read.csv(file = "C:/project1/seoul_area.csv", header = T)

#=========================================================
# 필요한 열 추출 (자치구, 면적)
# 데이터의 2, 3번째 열 추출
#=========================================================
area <- area[, c(2, 3)]

#=========================================================
# 인덱스 이름 변경 (자치구 열을 인덱스로 변경)
#=========================================================
rownames(area) = area$자치구

#=========================================================
# 1 행 제거 / # 1 열 제거
#=========================================================
area <- area[-1, ]
area <- subset(area, select = -c(자치구))

#=========================================================
# 데이터 타입 변환 (면적데이터를 num으로 )
#=========================================================
area$면적 <- as.numeric(area$면적)

# csv로 데이터 내보내기
write.csv(area, "area.csv")