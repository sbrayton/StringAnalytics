##df.new = as.data.frame(lapply(cams_test, function(x) ifelse(is.na(x), 0, 1)))
library(stringdist)
library(readxl)


cams_test <- read_excel("doc1.xlsx")


for(i in 1:nrow(cams_test)) {
  #row <- cams_test[i,]
  namestochk <- cams_test[i,1]
#   
# ##I don't need this since I am doing a contains search right after this.
#   # colnum <- match(namestochk,names(cams_test))
#   # cams_test[i,colnum] <- 1
#   
# ## get where contains
#   
#   #what I will do is use grep to get find the column that contain the value I am looking for
#   grepColMatch <- grepl(namestochk, names(cams_test))
#   
#   #here I want the index numbers of the true values, so I will melt them together so that I can get the index #
#   #there is probably a cleaner way to do this.
#   require(reshape2)
#   df <- melt(data.frame(i,grepColMatch))
#   df$variable<-NULL
#   
#   #give me a vector of all the index numbers where there was a contains or an exact match for the current name I am checking
#   ind.2 <- which(df=="TRUE")
#   
#   #update the cells in the matrix that have a match on contains.
#   for (fuzzy in ind.2) {
#     
#     cams_test[i,fuzzy] <- 1
#     
#   }
#   
##Now that I have updated the matrix with the exact match, I want to get the distance of those that are not an exact
  
  d <- stringdist(namestochk,names(cams_test), method="jw") # String edit distance (use your favorite function here)
  df<-NULL
  df <- melt(data.frame(names(cams_test),d))
  df$variable<-NULL  
  
  #give me a vector of all the index numbers where there was a contains or an exact match for the current name I am checking
  ind.2 <- which(df$value<=.15) 
  
  for (distInx in ind.2) {
    
    if (is.na(cams_test[i,distInx])) {
      cams_test[i,distInx] <- df$value[distInx]
    }
    
    
  }  

 
}

#here I want to remove na values before I export to a file

cams_test[is.na(cams_test)] <- 0

# 
# write.csv(cams_test, file = "camsMatch.csv",row.names=FALSE)
# 
# 


