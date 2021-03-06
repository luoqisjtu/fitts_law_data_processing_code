library(Rmisc)
library(ggplot2)
library(grDevices)

all_data<-read.csv("outcome_metrics_bar_chart_S7.csv")    #     outcome_metrics_bar_chart_S1.csv  functional_task_outcome_metrics_S1.csv   force_rmse_S3.csv
all_data

head(all_data)


#calculate (outcome_metrics_anlysis)    # Draw histogram——success_rate/throughput/contact var_value/break_rate
#========================================================================================================
# sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("filter","model","metrics","state")) # state-healthy/amputee
sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("model","metrics"))  #metrics  task
# demo_data <- sub_data[sub_data$state=="amputee" & sub_data$metrics=="re_throughput",]    #throughput/success_rate/break_rate/re_throughput
demo_data <- sub_data[sub_data$metrics=="break_rate",]
# demo_data <- sub_data[sub_data$task=="crt",]   #crt/nhp
demo_data

p <- ggplot(data = demo_data, aes(x='',y=var_value, fill = model))  ###### one factor/condition
# p <- ggplot(data = demo_data, aes(x=filter,y=var_value, fill = model))  ###### x=filter     two factor/condition
p <- p + geom_bar( stat="identity",width=0.85,position="dodge")
p <- p + geom_errorbar(aes(ymin=var_value-sd, ymax=var_value+sd),width = 0.1,position = position_dodge(width=0.85))



#calculate (force_metircs_anlysis)
#=======================================================================================================
# sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("model","ID","IDre"))  #"number",
# demo_data <- sub_data
# demo_data
# 
# p <- ggplot(data = demo_data, aes(x=IDre,y=var_value, fill = model))  ###### one factor/condition
# p <- p + geom_bar( stat="identity",width=0.65,position="dodge")
# p <- p + geom_errorbar(aes(ymin=var_value-sd, ymax=var_value+sd),width = 0.3,position = position_dodge(width=0.65))
#==========================================================================================================


p <- p + labs(x=" ",y="var_value\n",title = "S\n") #title = "S3\n"   var_value  Blocks/min   8-side die  Nine hole peg   Clothespin relocation
p <- p + theme(axis.title.y=element_text(angle=90,colour="black",size=20))
p <- p + geom_text(aes(y = 1,label='')) ######label=filter  label=''
        
# p <- p + geom_text(aes(label=brittleness),position = position_dodge(width=0.4),vjust=-1.5)#图注或数据显示在上面

p <- p + theme( plot.title = element_text(size = 20, face = "bold"))
p <- p + theme(plot.title=element_text(hjust=0.5)) 

p <- p + theme(axis.text.x = element_text(hjust=0.5, vjust=1,colour="black", size=18)) 
p <- p + theme(axis.text.y = element_text(hjust=1, vjust=0.5, size=14)) 


p <- p + theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) 
p <- p + theme(panel.background = element_blank()) 
p <- p + theme(axis.line = element_line(colour = "black")) 

p
###demo_data end###
