
rate<-c(0.611,0.722,0.528,0.556)
barplot(rate,main="SR-S3")

labs=c("Species1","Species2","Species3", "Species4")

barplot(rate,col=c("steelblue","sandybrown","mediumturquoise"),ylim=c(0,1),width=1,space=1,ylab="%(......)",las=1)
text(x=seq(1.5,25.5,by=2),y=-0.15, srt = 0, adj = 1, labels = labs,xpd = TRUE)