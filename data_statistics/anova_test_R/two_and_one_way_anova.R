rm(list = ls())
library(ggpubr)
library(ggsci)
library(ggsignif)
library(car)
library(userfriendlyscience)
library(Rmisc)
library(grDevices)
library(lmerTes)
library(nlme)

#1 succes_rate/throughput/overshoot˫���ط������
sub_data1<-read.csv("force_rmse_S1.csv")   #outcome_metrics_bar_chart_S1.csv
# demo1 <- sub_data1[sub_data1$state=="amputee" & sub_data1$metrics=="success_rate",]    #throughput/success_rate/break_rate
# demo1 <- sub_data1[sub_data1$task=="bbt",]    #bbt/nhp
demo1 <- sub_data1
demo1



#1.1 ��̬�Լ���
with(demo1,tapply(var_value,model,shapiro.test))   #Shapiro-Wilk����

#1.2 �������Լ���    
leveneTest(var_value~model,demo1)   #�������ݿ���bartlett.test,3���3��������leveneTest

#1.3 ������ANOVA
AOV1 <- aov(var_value~model,demo1)
summary(AOV1)
TukeyHSD(AOV1)  #�����Ƚ�(pairwise comparison)    post-hoc test

#1.4 ˫���ط������aov
AOV1 <- aov(var_value~filter*model,demo1)
summary(AOV1)
model.tables(AOV1,"means")

sum = summarySE(demo1, measurevar="break_rate", groupvars=c("filter","model"))
sum

#1.5 ˫���ط������lm,anova
AOV1=lm(var_value~filter*model,data=demo1)
anova(AOV1)
summary(AOV1)  #summary�������Կ�������ͳ����ֵ������pֵ

#1.6 ˫���ط������lmer,anova
AOV1 <- lmer (var_value ~ model + (1|filter), data=demo1)
anova(AOV1)
summary(AOV1)

#1.7 ˫���ط������glm,anova
AOV1 <- glm(var_value~filter*model, data = demo1)
anova(AOV1)
summary(AOV1)

#1.8 �����Ƚ�(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV1,'filter:model')  




#2 CT-ID˫���ط������
sub_data2<-read.csv("CT_line_chart_data_all.csv")
demo2 <- sub_data2[sub_data2$state=="amputee",]
demo2

#2.1 ��̬�Լ���
with(demo2,tapply(CT, model, shapiro.test))   #Shapiro-Wilk����

#2.2 �������Լ���    
leveneTest(CT~model,demo2)   #�������ݿ���bartlett.test,3���3��������leveneTest

#2.3 ˫���ط������aov
AOV2 <- aov(CT ~ filter*model,demo2)
summary(AOV2)

#2.4 ˫���ط������lm,anova
AOV2=lm(CT ~ filter + model + filter:model,data=demo2)
anova(AOV2)
summary(AOV2)  

#2.5 ˫���ط������lmer,anova 
AOV2 <- lmer(CT ~ model +  filter +(1|ID), data=demo2)
anova(AOV2)
summary(AOV2)

#2.6 �����Ƚ�(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV2,'filter:model') 






