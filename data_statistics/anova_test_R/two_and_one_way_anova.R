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
library(PMCMR)
library(DescTools)
library(FSA)

#1 succes_rate/throughput/overshoot单双因素方差分析
sub_data<-read.csv("CT_line_chart_data_single_finger.csv")   #outcome_metrics_bar_chart_S2.csv   force_rms_roughness_S2.csv
# demo_data <- sub_data[sub_data$state=="amputee" & sub_data$metrics=="success_rate",]    #throughput/success_rate/break_rate/re_throughput
# demo_data <- sub_data[sub_data$task=="bbt",]    #bbt/nhp
demo_data <- sub_data
# demo_data <- sub_data[sub_data$metrics=="success_rate",]
demo_data

# 1 =========================================================================
#非参数检验 kruskal-wallis test
kruskal.test(CT~model, data = demo_data)

#kruskal-wallis三种两两比较方法
#1.1
posthoc.kruskal.nemenyi.test(CT~model, data = demo_data)
#1.2
NemenyiTest(CT~model, data = demo_data)    #适用于各组观察例数相等时
#1.3
dunnTest(CT~model, data = demo_data,method="bonferroni")   #适用于各组观察例数不等时



# 2 ============================================================================
#2.1 正态性检验
with(demo_data,tapply(CT,model,shapiro.test))   #Shapiro-Wilk检验

#2.2 方差齐性检验    
leveneTest(CT~model,demo_data)   #两组数据可用bartlett.test,3组或3组以上用leveneTest

#2.3 单因素ANOVA
AOV1 <- aov(CT~model,demo_data)
summary(AOV1)
TukeyHSD(AOV1)  #两两比较(pairwise comparison)    post-hoc test

#2.4 双因素方差分析aov
AOV1 <- aov(CT~filter*model,demo_data)
summary(AOV1)
model.tables(AOV1,"means")

sum = summarySE(demo_data, measurevar="break_rate", groupvars=c("filter","model"))
sum

#2.5 双因素方差分析lm,anova
AOV1=lm(CT~filter*model,data=demo_data)
anova(AOV1)
summary(AOV1)  #summary函数可以看到最后的统计量值，包含p值

#2.6 双因素方差分析lmer,anova
AOV1 <- lmer (CT ~ model + (1|filter), data=demo_data)
anova(AOV1)
summary(AOV1)

#2.7 双因素方差分析glm,anova
AOV1 <- glm(CT~filter*model, data = demo_data)
anova(AOV1)
summary(AOV1)

#2.8 两两比较(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV1,'filter:model')  


# 3 ==========================================================================================
#CT-ID双因素方差分析
sub_data2<-read.csv("CT_line_chart_data_all.csv")
demo2 <- sub_data2[sub_data2$state=="amputee",]
demo2

#3.1 正态性检验
with(demo2,tapply(CT, model, shapiro.test))   #Shapiro-Wilk检验

#3.2 方差齐性检验    
leveneTest(CT~model,demo2)   #两组数据可用bartlett.test,3组或3组以上用leveneTest

#3.3 双因素方差分析aov
AOV2 <- aov(CT ~ filter*model,demo2)
summary(AOV2)

#3.4 双因素方差分析lm,anova
AOV2=lm(CT ~ filter + model + filter:model,data=demo2)
anova(AOV2)
summary(AOV2)  

#3.5 双因素方差分析lmer,anova 
AOV2 <- lmer(CT ~ model +  filter +(1|ID), data=demo2)
anova(AOV2)
summary(AOV2)

#3.6 两两比较(pairwise comparison)    post-hoc test                              
TukeyHSD(AOV2,'filter:model') 







