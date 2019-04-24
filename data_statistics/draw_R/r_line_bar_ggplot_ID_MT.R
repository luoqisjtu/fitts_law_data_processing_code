# Draw line chart (linear regression line)——MT-ID
library(Rmisc)
library(ggplot2)
library(grDevices)


all_data<-read.csv("D:\\Luoqi\\fitts_law\\fitts_all_result_analysis\\conjoint_analysis_results\\MT_line_chart_data_all_supplement.csv")
all_data

head(all_data)


#calculate          
sub_data <- summarySE(all_data, measurevar="MT", groupvars=c("model","filter","number","ID","state" ))  #"state" #分析单个受试者或多个受试者对比时加上"subject"

# tgc <- sub_data[sub_data$filter=="bayes",]
tgc <- sub_data[sub_data$filter=="bayes" & sub_data$state=="amputee",]
# tgc <- sub_data[sub_data$filter=="butterworth" & sub_data$subject=="S3" & (sub_data$model =="off" | sub_data$model =="on"),]
# tgc <- sub_data[sub_data$filter=="butterworth" & sub_data$state=="amputee" & sub_data$model =="on",]

tgc



p <- ggplot(tgc, aes(x=ID, y=MT,shape=model, color=model)) +
  geom_errorbar(aes(ymin=MT-se, ymax=MT+se), width=.1) +
  # geom_line(position=position_dodge(0.2)) + # Dodge lines by 0.2
  geom_point(size=2)+
  geom_smooth(method="lm", se=FALSE, fullrange=TRUE)  #添加回归线
  # geom_smooth(method = "lm", se=FALSE, color="red", formula = y ~ x)


model.lm <- lm(MT ~ ID, data = tgc)
summary(model.lm)

l <- list(a = format(coef(model.lm)[1], digits = 3),
          b = format(abs(coef(model.lm)[2]), digits = 3),
          r2 = format(summary(model.lm)$r.squared, digits = 3),
          p = format(summary(model.lm)$coefficients[2,4], digits = 3))


eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p, l)
# eq2 <- substitute(italic(y) == a2 + b2 %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p2, l)

p1 <- p + geom_text(aes(x = 6, y = 15, label = as.character(as.expression(eq))), parse = TRUE, hjust=1, vjust=1) +
  # geom_text(aes(x = 6, y = 15, label = as.charaMTer(as.expression(eq2))), parse = TRUE, hjust=1, vjust=1) +
  labs(title = "S") +
  theme(plot.title=element_text(hjust=0.5)) +
  
  # xlim(3.5,6) +
  # ylim(0,15) +
   
  theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  
  theme(axis.text.x = element_text(hjust=0.5, vjust=1, size=14)) +
  theme(axis.text.y = element_text(angle=90, hjust=0.5, vjust=1, size=14)) +
  
  xlab("ID\n") + 
  theme(axis.title.x=element_text(face="italic", colour="black", size=18)) +
  ylab("MT(s)\n")+
  theme(axis.title.y=element_text(angle=90, face="italic", colour="black",size=18)) +
  
  theme(panel.border = element_blank())
  # p_remove_border
                                   
p1














