library(rvest)

request <- c("MIRT000019","MIRT001950")

seq <- function(mima){
  url <- paste0("http://mirtarbase.mbc.nctu.edu.tw/php/detail.php?mirtid=", mima,"#target")
  
  a <- htmltools::HTML(url)
  predict <- read_html(a)%>% xml_find_all('//*[@style="background-color:yellow"]')%>%html_text()%>%
    gsub("[^A-Za-z]","",.)
  confirm <- read_html(a)%>% xml_find_all('//*[@style="background-color:blue"]')%>%html_text()%>%
    gsub("[^A-Za-z]","",.)
  
  confirm <- ifelse(length(confirm)==0,"NA",confirm)
  tmp <- data.frame(predict=predict,confirm=confirm,mir=mima)
  print(paste0(mima," is done"))
}

test <- lapply(request,seq)
result <- do.call(rbind,test)
write.table(result,"result.txt",row.names = F,quote=F)