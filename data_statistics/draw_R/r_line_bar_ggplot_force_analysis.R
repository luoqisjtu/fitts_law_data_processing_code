# Draw line chart ¡ª¡ªvar_value-ID
library(Rmisc)
library(ggplot2)
library(grDevices)


all_data<-read.csv("force_similarity_S7.csv")          #var_value_line_chart_data_S6.csv
all_data

head(all_data)


#calculate
# sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("filter","model","IDre"))  #"number"
# demo_data <- sub_data[sub_data$filter=="ba",]
sub_data <- summarySE(all_data, measurevar="var_value", groupvars=c("model","IDre"))  #"number"
demo_data <- sub_data 
demo_data



p <-ggplot(demo_data, aes(x=model, y=var_value,shape=factor(IDre),color=factor(IDre))) +         #color=factor(IDre)
  # geom_errorbar(aes(ymin=var_value-sd, ymax=var_value+sd), width=.1) +
  geom_point(aes(x = model, y = var_value),size=3)+                         #color="blue",   
  geom_line(aes(model, var_value, group = IDre),size=1)                     #col=c("blue") 


p1 <- p +
  labs(title = "S") +
  theme(plot.title=element_text(hjust=0.5)) +
  geom_text(aes(y = 1,label='')) + ######label=filter  label=''

  theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +

  theme(axis.text.x = element_text(hjust=0.5, vjust=1, size=14)) +
  theme(axis.text.y = element_text(angle=90, hjust=0.5, vjust=1, size=14)) +

  xlab("ID\n") +
  theme(axis.title.x=element_text(face="italic", colour="black", size=18)) +
  ylab("var_value\n")+
  theme(axis.title.y=element_text(angle=90, face="italic", colour="black",size=18)) +

  theme(panel.border = element_blank())
# p_remove_border

p1














