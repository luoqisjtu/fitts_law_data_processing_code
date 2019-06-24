library(Rmisc)
library(ggplot2)
library(grDevices)


tg<-read.csv("D:\\Luoqi\\fitts_law\\fitts_all_result_analysis\\conjoint_analysis_results\\RT_bar_chart_left_S3.csv")
tg


#tg <- ToothGrowth
head(tg)


#calculate
tgc <- summarySE(tg, measurevar="RT", groupvars=c("brittleness","neuromorphic"))
tgc


# model<-c('1','2')

# rate<-c(0.972,0.972,0.778)
# data1<-data.frame(model,rate)
# colnames(data1)<-c('model','rate')
# p <- ggplot(data = data1, aes(x=model,y=rate))         

p <- ggplot(data = tgc, aes(x=brittleness,y=RT, fill = neuromorphic))  
p <- p + geom_bar( stat="identity",width=0.6,position="dodge") 

p <- p + geom_errorbar(aes(ymin=RT-se, ymax=RT+se),width = 0.1,position = position_dodge(width=0.6))

p <- p + labs(x=" ",y="RT\n",title = "S3\n") 
p <- p + theme(axis.title.y=element_text(angle=90,colour="black",size=20))

# p <- p + geom_text(aes(label=brittleness),position = position_dodge(width=0.4),vjust=-1.5)#图注或数据显示在上面

p <- p + theme( plot.title = element_text(size = 20, face = "bold"))
p <- p + theme(plot.title=element_text(hjust=0.5)) 

p <- p + theme(axis.text.x = element_text(hjust=0.5, vjust=1,colour="black", size=18)) 
p <- p + theme(axis.text.y = element_text(hjust=1, vjust=0.5, size=14)) 


p <- p + theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) 
p <- p + theme(panel.background = element_blank()) 
p <- p + theme(axis.line = element_line(colour = "black")) 

p
###demo end###
