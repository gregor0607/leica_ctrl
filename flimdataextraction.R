saveflim <- function(fname, dir){
    
    #function to extract information from a file
    
    extract <- function(filename){
        scanneddata <- scan(filename, skip=1, what="numeric")
        s <- seq(34, length(scanneddata), 5)
        
        if (max(as.numeric(scanneddata[s]))>9750){
        data <- data.frame(amp_1 = as.numeric(scanneddata[3]),
                           lft_1 = as.numeric(scanneddata[6]),
                           amp_2 = as.numeric(scanneddata[9]),
                           lft_2 = as.numeric(scanneddata[12]),
                           tau_amp = as.numeric(scanneddata[22]))}}
    
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

outoutliers <- function (df, x=6, p=.95){

    if(!("outliers" %in% installed.packages())) {install.packages("outliers")}
        else require(outliers)
    if(!("dplyr" %in% installed.packages())) {install.packages("dplyr")}
    else require(dplyr)

outliers <- scores(df[,x], type="z", prob=p)

newdf <- dplyr::filter(df, !outliers)

message(cat("The outliers for", p*100 ,"% confidence interval are:\n", 
            df[outliers, x], "\n",
            rep("-", 20)), "\n", 
            "The mean and median with outliers are respectively: ", 
            round(mean(df[,x]), 2), " ; ", median(df[,x]), "\n",
            "The mean and median without outliers are respectively: ", 
            round(mean(newdf[,x]), 2), " ; " ,median(newdf[,x]))
return(newdf)
}

#simple function to extract and compare two sets of data (donor and from FLIM). means of variable are compared

compare <- function(donor, FLIM){
    
    data <- data.frame(amp_1 = c(mean(donor$amp_1, na.rm = T), mean(FLIM$amp_1)), 
                       lft_1 = c(mean(donor$lft_1, na.rm = T), mean(FLIM$lft_1)), 
                       amp_2 = c(mean(donor$amp_2, na.rm = T), mean(FLIM$amp_2)), 
                       lft_2 = c(mean(donor$lft_2, na.rm = T), mean(FLIM$lft_2)),
                       tau_amp = c(mean(donor$tau_amp), mean(FLIM$tau_amp)),
                       row.names = c(substitute(donor), substitute(FLIM)))
    print((t.test(donor$tau_amp, FLIM$tau_amp)))
    return(data)
}