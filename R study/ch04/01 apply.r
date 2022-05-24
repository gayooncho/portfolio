### apply()
# 행렬의 행 또는 열 방향으로 특정 함수를 적용하는 데 사용

# 01
d <- matrix(1:9, ncol = 3)

# 이 행렬의 각 행의 합을 구하려면 apply를 행별로 (MARGIN에 1을 지정) 처리하되 각 행에 대해 sum 함수 호출
apply(d, 1, sum)


# iris data 활용
head(iris)

#Sepal.Length, Sepla.Width, Petal.Length, Petal.Width 합 확인
apply(iris[, 1:4], 2, sum) 

# 행 또는 열의 합 또는 평균의 계산은 빈번히 사용되므로 rowSums(), rowMeans() 등 함수 활용


# apply()를 통해 구한 계산을 colSums()로 수행
colSums(iris[, 1:4])


### lapply()
# 리스트를 반환하는 특징이 있는 apply계열 함수

# 데이터 프레임을 처리한 결과를 리스트로 얻은 뒤 해당 리스트를 다시 데이터 프레임으로 변환할 필요가 있을 수 있음
#   1.unlist()통해 리스트를 벡터로 변환
#   2.matrix()를 사용해 벡터를 행렬로 변환
#   3.as.data.frame()을 사용해 행렬을 데이터 프레임으로 변환
#   4.names()를 사용해 리스트로부터 변수명을 얻어와 데이터 프레임의 각 컬럼에 이름을 부여

# iris data의 각 결럼에 대한 평균을 lapply()로 구한 뒤 이 결과를 다시 데이터 프레임으로 변환
d <- as.data.frame(matrix(unlist(lapply(iris[, 1:4], mean)), ncol=4, byrow=TRUE))

names(d) <- names(iris[, 1:4])
d

# do.call() 사용해 변환 
# lapply()가 반환한 리스트 내의 각 컬럼별 계산 결과가 들어있음
# 이를 새로운 데이터 프레임의 컬럼들로 합치키 위해 cbind()사용
data.frame(do.call(cbind, lapply(iris[, 1:4], mean)))


# unlist() → matirx()를 거쳐 data.frame으로 변환하는 방법 문제점
#   unlist()는 벡터를 반환하는데, 벡터에는 한 가지 데이터 타입만 저장 
# 따라서 데이터가 혼합된 경우 do.call()사용
#   하지만 do.call(rbind...) 방식은 속도가 느림 → rbindlist()활용


### sapply()
# lapply와 유사하지만 리스트 대신 행렬, 벡터 등의 데이터 타입으로 결과 반환

# iris 컬럼별 평균 구하는 경우
lapply(iris[, 1:4], mean)       # 리스트 반환

sapply(iris[, 1:4], mean)       # 벡터 반환



# sapply()에서 반환한 벡터는 as.data.frame()을 사용해 데이터 프레임으로 변환 할 수 있음
# t(x)를 사용해 벡터의 행과 열을 바꿔주지 않으면 기대한 것과 다른 모양의 데이터 프레임을 얻게 됨

# iris 컬럼별 평균을 sapply()를 사용해 벡터로 구한 뒤 이를 다시 데이터 프레임으로 변환
x <- sapply(iris[, 1:4], mean)
as.data.frame(x)

as.data.frame(t(x))

# iris 의 숫자형 값들에 대해 각 값이 3보다 큰지 여불르 판단
# FUN의 반환 값이 길이가 1보다 큰 벡터이기 때문에 sapply의 수행 결과는 행렬
y <- sapply(iris[, 1:4], function(x) {x > 3 })
class(y)    #matrix
head(y)


### tapply()
# 그룹별로 함수를 적용하기 위한 apply계열 함수

# iris에서 Species 별 Sepal.Length의 평균
tapply(iris$Sepal.Length, iris$Species, mean)

# tapply()클러스터링 알고리즘을 수행한 후 같은 클러스터에 속한 데이터들의 
# x 좌표의 평균, y좌표의 평균을 계산하는 데 사용할 수 있음

### mapply()
#  sapply()와 유사하지만 다수의 인자를 함수에 넘긴다는 점에서 차이가 있음

# 평균 0, 표준 편차 1을 따르는 난수 10개 발생
rnorm(10, 0, 1)

mapply(rnorm, c(1, 2, 3), c(0, 10, 100), c(1, 1, 1))

# iris의 각 컬럼의 평균
mapply(mean, iris[, 1:4])




