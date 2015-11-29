saveflim <- function(fname, dir){
    
    #function to extract information from a file
    extract <- function(filename){
        amplif <- scan(filename, skip=1, nlines=4, what="numeric")
        time <- scan(filename, skip=10, nline=1, what="numeric")
        
        data <- data.frame(amp_1 = as.numeric(amplif[3]),
                           lft_1 = as.numeric(amplif[6]),
                           amp_2 = as.numeric(amplif[9]),
                           lft_2 = as.numeric(amplif[12]),
                           tau_amp = as.numeric(time[2]))}
    
    #opening files and applying extract function
        files_list <- list.files(dir, pattern="\\.dat")  
        index <- seq_along(files_list)
        data <- sapply(files_list[index], function(x) extract(paste(dir, x, sep='/')), 
                       simplify = FALSE) #lapply - no row names (more clean)
        datamerged <- do.call(rbind.data.frame, data)
        
if(!("xlsx" %in% installed.packages())) {install.packages("xlsx")}
   else require(xlsx)
    
saveRDS(datamerged, file=paste(fname, "rds", sep="."))
write.csv(datamerged, file=paste(fname, "csv", sep="."))
write.xlsx(datamerged, file=paste(fname, "xlsx", sep="."))
}

#function to delete outliers

outoutliers <- function (df, x=6){

    if(!("outliers" %in% installed.packages())) {install.packages("outliers")}
        else require(outliers)
    if(!("dplyr" %in% installed.packages())) {install.packages("dplyr")}
    else require(dplyr)

outliers <- scores(df[,x], type="z", prob=.95)

newdf <- dplyr::filter(df, !outliers)

message(cat("The outliers are (with 95% confidence):\n", df[outliers, x], "\n",
            rep("-", 20)), "\n", 
            "The mean and median with outliers are respectively: ", 
            round(mean(df[,x]), 2), " ; ", median(df[,x]), "\n",
            "The mean and median without outliers are respectively: ", 
            round(mean(newdf[,x]), 2), " ; " ,median(newdf[,x]))
return(newdf)
}