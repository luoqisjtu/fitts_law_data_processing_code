# Draw histogram——success_rate/throughput/contact time/break_rate
library(Rmisc)
library(ggplot2)
library(grDevices)


all_data<-read.csv("outcome_metrics_bar_chart_all_supplement.csv")
all_data

head(all_data)


#calculate
#sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("filter","model","metrics","state")) # state-healthy/amputee
sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("model","metrics","state")) 
tgc <- sub_data[sub_data$state=="healthy" & sub_data$metrics=="throughput",]    #throughput/success_rate/break_rate
# tgc <- sub_data[sub_data$metrics=="success_rate",]    #throughput/success_rate/break_rate
tgc



p <- ggplot(data = tgc, aes(x=filter,y=var_value, fill = model))  
p <- p + geom_bar( stat="identity",width=0.85,position="dodge") 

p <- p + geom_errorbar(aes(ymin=var_value-se, ymax=var_value+se),width = 0.1,position = position_dodge(width=0.85))

p <- p + labs(x=" ",y="var_value\n",title = "S\n") #title = "S3\n"
p <- p + theme(axis.title.y=element_text(angle=90,colour="black",size=20))
p <- p + geom_text(aes(y = 1,label=filter))

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
