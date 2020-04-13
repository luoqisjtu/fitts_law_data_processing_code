library(Rmisc)
library(ggplot2)
library(grDevices)


tg<-read.csv("D:\\Luoqi\\fitts_law\\experiement_results\\S1_lq_2018_12_9\\RT_bar_chart_left_S1.csv")
tg


#tg <- ToothGrowth
head(tg)


#calculate
tgc <- summarySE(tg, measurevar="RT", groupvars=c("brittleness"))
tgc


model<-c('n','y')

# rate<-c(0.972,0.972,0.778)
# data1<-data.frame(model,rate)
# colnames(data1)<-c('model','rate')
# p <- ggplot(data = data1, aes(x=model,y=rate))

p <- ggplot(data = tgc, aes(x=model,y=RT))  
p <- p + geom_bar( stat="identity" , width = 0.4, fill = "cornflowerblue") 

p <- p + geom_errorbar(aes(ymin=RT-se, ymax=RT+se),width = 0.1,position = position_dodge(width=0.5) )

#p <- p + labs(x="",y="TP\n",title = "S1\n") 
p <- p + labs(x="",y="RT\n",title = "S1\n") 
p <- p + theme(axis.title.y=element_text(angle=90,colour="black",size=20))

p <- p + theme( plot.title = element_text(size = 20, face = "bold"))
p <- p + theme(plot.title=element_text(hjust=0.5)) 

p <- p + theme(axis.text.x = element_text(hjust=0.5, vjust=1,colour="black", size=18)) 
p <- p + theme(axis.text.y = element_text(hjust=1, vjust=0.5, size=14)) 


p <- p + theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) 
p <- p + theme(panel.background = element_blank()) 
p <- p + theme(axis.line = element_line(colour = "black")) 

p
###demo end###
