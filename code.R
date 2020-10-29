library(rvest)

request <- c("MIRT302435")

seq <- function(mima){
  url <- paste0("http://mirtarbase.mbc.nctu.edu.tw/php/detail.php?mirtid=", mima,"#target")
  
  print(paste("processing ",mima))
  
  a <- htmltools::HTML(url)
  predict <- read_html(a)%>% xml_find_all('//*[@style="background-color:yellow"]')%>%html_text()%>%
    gsub("[^A-Za-z]","",.)
  confirm <- read_html(a)%>% xml_find_all('//*[@style="background-color:blue"]')%>%html_text()%>%
    gsub("[^A-Za-z]","",.)
  
  predict <- ifelse(length(predict)==0,"NA",predict)
  confirm <- ifelse(length(confirm)==0,"NA",confirm)
  tmp <- data.frame(predict=predict,confirm=confirm,mir=mima)
  

}

test <- lapply(request,seq)
result <- do.call(rbind,test)
write.table(result,"result.txt",row.names = F,quote=F)
