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

#1 succes_rate/throughput/overshoot双因素方差分析
sub_data1<-read.csv("force_rmse_S1.csv")   #outcome_metrics_bar_chart_S1.csv
# demo1 <- sub_data1[sub_data1$state=="amputee" & sub_data1$metrics=="success_rate",]    #throughput/success_rate/break_rate
# demo1 <- sub_data1[sub_data1$task=="bbt",]    #bbt/nhp
demo1 <- sub_data1
demo1



#1.1 正态性检验
with(demo1,tapply(var_value,model,shapiro.test))   #Shapiro-Wilk检验

#1.2 方差齐性检验    
leveneTest(var_value~model,demo1)   #两组数据可用bartlett.test,3组或3组以上用leveneTest

#1.3 单因素ANOVA
AOV1 <- aov(var_value~model,demo1)
summary(AOV1)
TukeyHSD(AOV1)  #两两比较(pairwise comparison)    post-hoc test

#1.4 双因素方差分析aov
AOV1 <- aov(var_value~filter*model,demo1)
summary(AOV1)
model.tables(AOV1,"means")

sum = summarySE(demo1, measurevar="break_rate", groupvars=c("filter","model"))
sum

#1.5 双因素方差分析lm,anova
AOV1=lm(var_value~filter*model,data=demo1)
anova(AOV1)
summary(AOV1)  #summary函数可以看到最后的统计量值，包含p值

#1.6 双因素方差分析lmer,anova
AOV1 <- lmer (var_value ~ model + (1|filter), data=demo1)
anova(AOV1)
summary(AOV1)

#1.7 双因素方差分析glm,anova
AOV1 <- glm(var_value~filter*model, data = demo1)
anova(AOV1)
summary(AOV1)

#1.8 两两比较(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV1,'filter:model')  




#2 CT-ID双因素方差分析
sub_data2<-read.csv("CT_line_chart_data_all.csv")
demo2 <- sub_data2[sub_data2$state=="amputee",]
demo2

#2.1 正态性检验
with(demo2,tapply(CT, model, shapiro.test))   #Shapiro-Wilk检验

#2.2 方差齐性检验    
leveneTest(CT~model,demo2)   #两组数据可用bartlett.test,3组或3组以上用leveneTest

#2.3 双因素方差分析aov
AOV2 <- aov(CT ~ filter*model,demo2)
summary(AOV2)

#2.4 双因素方差分析lm,anova
AOV2=lm(CT ~ filter + model + filter:model,data=demo2)
anova(AOV2)
summary(AOV2)  

#2.5 双因素方差分析lmer,anova 
AOV2 <- lmer(CT ~ model +  filter +(1|ID), data=demo2)
anova(AOV2)
summary(AOV2)

#2.6 两两比较(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV2,'filter:model') 







