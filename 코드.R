### 개화군의 결과도 알고 싶다면
### 코드의 "생장길이" 를 개화군으로 수정해주시면 됩니다.



# 필요한 라이브러리 로드
library(readxl)
library(dplyr)

# 엑셀 파일 경로
file_path <- "C:/Users/qnsgh/OneDrive/바탕 화면/배포용/작재2 생육 데이터(개체별, R특화).xlsx"

# 시트 목록
sheet_names <- c("1-1", "1-2", "1-4", "1-5", "5-2", "5-3", "5-4", "5-5")

# 데이터 로딩 및 열 이름 수정 (공백이나 특수문자 제거)
data <- lapply(sheet_names, function(sheet) {
  sheet_data <- read_excel(file_path, sheet = sheet)
  
  # 열 이름에서 공백, 괄호, 'cm' 제거
  colnames(sheet_data) <- gsub(" ", "", colnames(sheet_data))  # 공백 제거
  colnames(sheet_data) <- gsub("\\(", "", colnames(sheet_data))  # 괄호 제거
  colnames(sheet_data) <- gsub("\\)", "", colnames(sheet_data))  # 괄호 제거
  colnames(sheet_data) <- gsub("cm", "", colnames(sheet_data))  # 'cm' 제거
  
  # 생장길이 열의 타입을 숫자형으로 변환
  sheet_data$생장길이 <- as.numeric(sheet_data$생장길이)  # '생장길이' 열을 숫자형으로 변환
  return(sheet_data)
})

# 데이터를 하나의 데이터 프레임으로 결합
combined_data <- bind_rows(data, .id = "sheet")

# 배지 위치와 캐노피에 따른 그룹 나누기
combined_data$group <- ifelse(combined_data$sheet %in% c("1-1", "1-2", "1-4", "1-5"), "group1", "group2")


# 생장길이에 대한 t-test
height_group_t_test <- t.test(생장길이 ~ group, data = combined_data)

# 결과를 텍스트 파일로 저장
writeLines(c(
             "개화군에 대한 t-test 결과:", capture.output(flowering_group_t_test)),
           "C:/Users/qnsgh/OneDrive/바탕 화면/생장길이t-test.txt")

# 결과 출력
list(
  height_t_test = height_t_test,
  flowering_group_t_test = flowering_group_t_test
)

