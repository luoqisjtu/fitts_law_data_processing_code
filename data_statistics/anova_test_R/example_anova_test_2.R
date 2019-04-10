#Two-way anova analysis 
library(Rmisc)
library(ggplot2)
library(grDevices)
library(lmerTest)

all_data<-read.csv("poisons.csv")     #data("ToothGrowth")
all_data
head(all_data)


#calculate
demo1 <- summarySE(all_data, measurevar="time", groupvars=c("poison","treat"))
demo1

#aov
anova_one_way <- aov(time~poison, data = demo1)
summary(anova_one_way)

demo1.aov <- aov(time ~ poison + treat, data = demo1)
summary(demo1.aov)


#lmer
demo1.lmer <- lmer(time ~ (1|poison) + (1|treat), data=demo1)
summary(demo1.lmer)


#anova
demo1.anova <- lmer(time ~ (1|poison) + (1|treat), data=demo1)
anova(demo1.anova)
summary(demo1.anova)



res=lm(time ~ poison * treat,data=demo1)
anova(res)
summary(res)  #summary函数可以看到最后的统计量值，包含p值

