rm(list = ls())
library(ggpubr)
library(ggsci)
library(ggsignif)
library(car)
library(userfriendlyscience)
library(Rmisc)
library(grDevices)
library(lmerTest)
library(nlme)
library(multcomp)

#1 succes_rate/throughput/overshoot双因素重复测量方差分析
sub_data1<-read.csv("outcome_metrics_bar_chart_all_supplement.csv")
demo1 <- sub_data1[sub_data1$state=="amputee" & sub_data1$metrics=="success_rate",]    #throughput/success_rate/overshoot
demo1



############################################################方法1：
summary(aov(var_value ~ filter*model + Error(subject/(filter*model)), data=demo1))

# Lme.mod <- lme(var_value ~ filter*model, random=list(number=pdBlocked(list(~1, pdIdent(~filter-1), pdIdent(~model-1)))), data=demo1)
# anova(Lme.mod)

demo1$filtermodel=interaction(demo1$filter,demo1$model)

Lme.mod <- lme(var_value ~ filtermodel, random=~1|subject,
               correlation=corCompSymm(form=~1|subject),
               data=demo1)

anova(Lme.mod)
summary(glht(Lme.mod, linfct=mcp(filtermodel="Tukey")))     #post-hoc test


############################################################方法2：
demo1 <- within(demo1, {
  filter <- factor(filter)
  model <- factor(model)
  subject <- factor(subject)
})

demo1.mean <- aggregate(demo1$var_value,
                         by = list(demo1$filter, demo1$model, demo1$subject),
                         FUN = 'mean')
colnames(demo1.mean) <- c("filter","model","subject","var_value")
demo1.mean <- demo1.mean[order(demo1.mean$subject), ]
head(demo1.mean)
var_value.aov <- with(demo1.mean, aov(var_value ~ filter*model+Error(subject/(filter*model))))
summary(var_value.aov)


############################################################方法3：
w1b1<-subset(demo1)
fit <- aov(var_value ~ filter*model + Error(subject/(filter*model)), w1b1)
summary(fit)


############################################################方法4：
butterworth1 <- demo1[demo1$filter=="butterworth"& demo1$model=="off",]
bayes1 <- demo1[demo1$filter=="bayes"& demo1$model=="off",]
butterworth2 <- demo1[demo1$filter=="butterworth"& demo1$model=="on",]
bayes2 <- demo1[demo1$filter=="bayes"& demo1$model=="on",]

varlueBind <- cbind(butterworth1,butterworth2,bayes1,bayes2)
varlueModel <- lm(varlueBind ~ 1)
analysis <- Anova(varlueModel, idata = demo1, idesign = ~filter*model)
summary(analysis)








