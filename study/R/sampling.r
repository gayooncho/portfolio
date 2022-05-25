
### 표본 추출

# 단순 임의 추출 (Simple Random Sampling)
# sample() 함수 사용

# 1~10 까지의 수에서 5개를 비복원 추출
sample(1:10, 5)

# 1~10 까지의 수에서 복원 추출로 5개의 표본 뽑기
sample(1:10, 5, replace = TRUE)
# 복원 추출이므로 같은 뽑힐 수 있음


# 가중치를 고려한 표본 추출
# prob파라미터 사용

# 1~10까지의 수에서 각각 1에서 10까지 가중치를 주어 복원추출
sample(1:10, 5, replace = TRUE, prob = 1:10)
# 가중치가 큰 표본이 더 많이 뽑힘


# 층화 임의 추출 (Stratified Random Sampling)
# sampling::strata() 함수 사용

# iris data  비복원 단순 임의 추출을 사용해 각 종별로 3개씩 표본 추출
install.packages("sampling")
library(sampling)
x <- strata(c("Species"), size = c(3, 3, 3), method = "srswor", data = iris)

getdata(iris, x)

# strata() 층별로 다른 수의 표본을 추출할 수 있음
strata(c("Species"), size = c(3, 1, 1), method = "srswr", data = iris)

# strata() 다수의 층을 기준으로 데이터 추출가능
# iris에서 Species2 라는 이름으로 또라는 층을 만들고, (Species, Species2)의 각 층마다 1개씩 표본 추출
iris$Species2 <- rep(1:2, 75)   # 1, 2, 1, 2 ... 1, 2
strata(c("Species", "Species2"), size = c(1, 1, 1, 1, 1, 1), method = "srswr", data = iris)


# 계통 추출
# 임의 위치에서 시작해 매 k번째 항목을 표본으로 추출하는 방법
# doBy package의 sampleBy(formula, frac = 0.1, replace = FALSE, data = parent.frame(), systematric = FALSE)
# 계통 추출을 하려면 systematic 인자에 TRUE를 지정


