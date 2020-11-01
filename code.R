library(rvest)
library(stringr)
library(data.table)

request <- c("MIRT003240","MIRT004055","MIRT006216")

seq <- function(mima){
  url <- paste0("http://mirtarbase.mbc.nctu.edu.tw/php/detail.php?mirtid=", mima,"#target")
  
  print(paste("processing ",mima))
  
  a <- htmltools::HTML(url)
  # predict <- read_html(a)%>% xml_find_all('//*[@style="background-color:yellow"]')%>%html_text()%>%
  #   gsub("[^A-Za-z]","",.)
  confirm <- read_html(a)%>% xml_find_all('//*[@style="background-color:blue"]')%>%html_text()%>%
    gsub("[^A-Za-z]","",.)
  
  refid <- read_html(a)%>% xml_find_all('//*[@id="blueDream"]/table/tbody/*/td/font/pre')%>%html_text()%>%str_split("\\|")%>%
    .[[1]]%>%.[2]
  
  symbol <- read_html(a)%>% xml_find_all('//*[@id="blueDream"]/table/tbody/*/td/font/pre')%>%html_text()%>%str_split("\\|")%>%.[[1]]%>%
    .[1]%>%gsub(">","",.)
  
  if (length(confirm)>0){
    result <- data.frame(confirm,mima,refid,symbol)
  }else{
    result <- data.frame(confirm="NA",mima,refid,symbol)
  }
  
  return(result)
  
  
}

test <- lapply(request,seq)
result <- do.call(rbind,test)
write.table(result,"confirm.txt",row.names = F,quote=F,sep='\t')
