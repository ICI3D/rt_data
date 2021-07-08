library(lubridate)

#aggregation scheme for reporting weekly on Monday

res$wday <- wday(res$date)
counter <- 0

for(i in 1:nrow(res)){
  if(res$wday[i]==2){
         res$agg[i]=counter+res$new_case[i]
          counter=0} else{
            res$agg[i]=0
            counter=counter+res$new_case[i]  
          }
  
}

