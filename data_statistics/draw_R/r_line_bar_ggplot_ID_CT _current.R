# Draw line chart (linear regression line)——CT-ID             #rm(list=ls()) ??????????????????
library(Rmisc)
library(ggplot2)
library(grDevices)
# library(gridExtra)

all_data<-read.csv("CT_line_chart_data_grip.csv")
all_data
head(all_data)

#calculate          
# sub_data <- summarySE(all_data, measurevar="CT", groupvars=c("model","filter","number","ID","state" ))  #"state" #分析单个受试者或多个受试者对比时加上"subjeCT"
sub_data <- summarySE(all_data, measurevar="CT", groupvars=c("model","ID"))  #"number"

demo_data <- sub_data
# demo_data <- sub_data[sub_data$model =="model1",]
# demo_data <- sub_data[sub_data$filter=="butterworth" & sub_data$subjeCT=="S3" & (sub_data$model =="off" | sub_data$model =="on"),]
# demo_data <- sub_data[sub_data$filter=="bayes" & sub_data$state=="amputee" & sub_data$model =="off",]
demo_data

pc_data <- sub_data[sub_data$model =="model1",]
bc_data <- sub_data[sub_data$model =="model3",]
cc_data <- sub_data[sub_data$model =="model4",]



# model1-proportional control
model.lm <- lm(CT ~ ID,pc_data)
summary(model.lm)

list_corr_pc <- list(a = format(coef(model.lm)[1], digits = 3),
                       b = format((coef(model.lm)[2]), digits = 3),
                       r2 = format(summary(model.lm)$r.squared, digits = 3),
                       p = format(summary(model.lm)$coefficients[2,4], digits = 3))
eq_pc <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p,list_corr_pc)


# model3-biomimetic control
model.lm <- lm(CT ~ ID,bc_data)
summary(model.lm)

list_corr_bc <- list(a = format(coef(model.lm)[1], digits = 3),
                      b = format((coef(model.lm)[2]), digits = 3),
                      r2 = format(summary(model.lm)$r.squared, digits = 3),
                      p = format(summary(model.lm)$coefficients[2,4], digits = 3))
eq_bc <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p,list_corr_bc)


# model4-contralateral hand control
model.lm <- lm(CT ~ ID, cc_data)
summary(model.lm)

list_corr_cc <- list(a = format(coef(model.lm)[1], digits = 3),
          b = format(abs(coef(model.lm)[2]), digits = 3),
          r2 = format(summary(model.lm)$r.squared, digits = 3),
          p = format(summary(model.lm)$coefficients[2,4], digits = 3))
eq_cc <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p, list_corr_cc)


# paste equation
txt_eq_pc = paste('y=',list_corr_pc$a,'+',list_corr_pc$b,'*x','  r^2=',list_corr_pc$r2,'  p=',list_corr_pc$p);
txt_eq_bc = paste('y=',list_corr_bc$a,'+',list_corr_bc$b,'*x','  r^2=',list_corr_bc$r2,'  p=',list_corr_bc$p);
txt_eq_cc = paste('y=',list_corr_cc$a,'+',list_corr_cc$b,'*x','  r^2=',list_corr_cc$r2,'  p=',list_corr_cc$p);


# plot
p <- ggplot(demo_data, aes(x=ID, y=CT,shape=model, color=model)) +
  geom_errorbar(aes(ymin=CT-sd, ymax=CT+sd), width=.1) +
  # geom_line(position=position_dodge(0.2)) + # Dodge lines by 0.2
  geom_point(size=2)+
  geom_smooth(method="lm", se=FALSE, fullrange=TRUE) +  #添加回归线
# geom_smooth(method = "lm", se=FALSE, color="red", formula = y ~ x)

  
  # lable
  labs(title = paste('pc:',txt_eq_pc,'\n','bc:',txt_eq_bc,'\n','cc:',txt_eq_cc) )+
  theme(plot.title=element_text(hjust=0.5, size=10))+
  
  xlab("ID\n") + 
  theme(axis.title.x=element_text(face="italic", colour="black", size=18)) +
  ylab("CT(s)\n")+
  theme(axis.title.y=element_text(angle=90, face="italic", colour="black",size=18)) +
  
  xlim(3.5,6) +
  ylim(0,15) +
   
  theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  
  theme(axis.text.x = element_text(hjust=0.5, vjust=1, size=14)) +
  theme(axis.text.y = element_text(angle=90, hjust=0.5, vjust=1, size=14)) +
  
  theme(panel.border = element_blank())
  # p_remove_border
p

# ggsave(paste("E:\\correlation_results\\",indep_var,"VS",func_var,"_",task,".png",sep=""),p,width = 4,height = 3 )
# ggsave(paste("E:\\correlation_results\\",indep_var,"VS",func_var,"_",task,".eps",sep=""),p,width = 4,height = 3 )



