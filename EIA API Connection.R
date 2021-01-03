# Connecting to EIA API

# install.packages(c("httr", "jsonlite"))

library(httr)
library(jsonlite)

key <- 'dc1de54d5800a76b0e84950e9eef64e7'
padd_key <- list('PET.MCRRIP12.M','PET.MCRRIP22.M',
                 'PET.MCRRIP32.M','PET.MCRRIP42.M',
                 'PET.MCRRIP52.M')
startdate <- "2010-01-01" #YYYY-MM-DD
enddate <- "2020-01-01" #YYYY-MM-DD

j = 0
for (i in padd_key) {

  url <- paste('http://api.eia.gov/series/?api_key=',key,'&series_id=',i,sep="")
  
  res <- GET(url)
  
  json_data <- fromJSON(rawToChar(res$content))
  data <- data.frame(json_data$series$data)
  data$Year <- substr(data$X1,1,4)
  data$Month <- substr(data$X1,5,6)
  data$Day <- 1
  
  data$Date <- as.Date(paste(data$Year, data$Month, data$Day, sep='-'))
  colnames(data)[2]  <- json_data$series$name
  data <- data[-c(1,3,4,5)]
  
  if (j == 0){
    data_final <- data
  }
  else{
    data_final <- merge(data_final,data,by="Date")
  }
  
  j = j + 1
}

data_final <- subset(data_final, Date >= startdate & Date <= enddate)
