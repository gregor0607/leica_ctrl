plotting <- function(plotname, d, b1, b1G){

png(paste(plotname, ".png"), width=500, height=500, units="px")
#dev.new(width=14, height=10)
par(mar=c(8, 8, 8, 6), xpd=TRUE)
boxplot(d, at=1, xlim=c(0,4), ylim=c(2.80, 3.1), outline=FALSE, col="yellow", ylab="Fluorescence lifetime [ns]")
points(1, mean(d))
title("Average mCitrine lifetimes", line="1")
text(1, 2.95, paste("n=", length(d)), cex=0.8)
text(1.5, y=mean(d), labels=paste(round(mean(d), 2), "ns"), cex=.8)
boxplot(b1, at=2, add=TRUE, outline=FALSE, col="red")
points(2, mean(b1))
text(2, 2.80, paste("n=", length(b1)), cex=0.8)
text(2.5, y=mean(b1), labels=paste(round(mean(b1), 2), "ns"), cex=.8)
boxplot(b1G, at=3, add=TRUE, col="green")
points(3, mean(b1G))
text(3, 2.84, paste("n=", length(b1G)), cex=0.8)
text(3.5, y=mean(b1G), labels=paste(round(mean(b1G), 2), "ns"), cex=.8)
legend(x="bottom", legend=c("mCitrine","mCitirine + mCherry", "mCitirine + mCherry + GppNHp"), 
       fill=c("yellow","red", "green"), bty="o", inset=c(0,-0.25), cex=1)
dev.off()
}