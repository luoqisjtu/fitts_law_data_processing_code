rm(list = ls())
library(ggpubr)
library(ggsci)
library(ggsignif)
library(car)
library(userfriendlyscience)
library(Rmisc)
library(grDevices)
library(lmerTest)


data("ToothGrowth")

# ToothGrowth$dose<-factor(ToothGrowth$dose,ordered = T)  #原数据集dose向量为字符向量，不是分组因子，将dose向量转化为因子向量

# 或者
table(ToothGrowth$supp,ToothGrowth$dose)
aggregate(ToothGrowth$len,by=list(ToothGrowth$supp,ToothGrowth$dose),FUN=mean)   #原数据集dose向量为字符向量，不是分组因子
class(ToothGrowth$dose)    #查看数据结构
ToothGrowth$dose<-factor(ToothGrowth$dose)     #将dose向量转化为因子向量
class(ToothGrowth$dose)



#1单因素方差分析
# 1.1 正态性检验
with(ToothGrowth,tapply(len, dose, shapiro.test))   #Shapiro-Wilk检验

# 1.2 方差齐性检验    
leveneTest(len~dose,ToothGrowth)   #两组数据可用bartlett.test,3组或3组以上用leveneTest

# 1.3 单因素ANOVA
AOV1 <- aov(len~dose,ToothGrowth)
summary(AOV1)

# 1.4 模型诊断
res1<-residuals(AOV1)
res1<-AOV1$residuals
shapiro.test(res1)
ggqqplot(res1)
leveneTest(res1~dose,ToothGrowth)

# 1.5 两两比较
# TukeyHSD(AOV1)
# 或者
Tu<-TukeyHSD(AOV1)
P <- Tu$dose[,4]
format(P,scientific = F)

# 1.6作图
ggboxplot(ToothGrowth,x = 'dose',y = 'len',fill = 'dose',palette = 'npg') +
  stat_compare_means(method = 'anova')

comp <- list(c('0.5','1'),c('0.5','2'),c('1','2'))
mytheme <- theme_classic2(base_size = 16)
ggplot(ToothGrowth,aes(x = dose,y = len,fill = dose))+
  stat_boxplot(geom = 'errorbar')+
  geom_boxplot() +
  geom_point(size = 2,alpha = 0.6) +
  geom_signif(comparisons = comp,
              y_position = c(36,40,38),
              annotations = format(unname(P),scientiic = T,digits = 3))+     #annotations = c('200e-8','***','<0.001'))
  labs(x = NULL,y = 'Tooth Length(cm)',title = 'Tooth Growth',fill = 'Dose(mg/d)') +
  scale_fill_npg()+
  mytheme



#2 Kruskal Wallis检验       当数据不符合正态分布时，则用非参数Kruskal Wallis检验
kruskal.test(len~dose,ToothGrowth)
with(ToothGrowth,pairwise.wilcox.test(len,dose,exact = F))



#3 双因素方差分析
#3.1 双因素ANOVA
AOV2 <- aov(len~dose*supp,ToothGrowth)
AOV2 <- aov(len~dose+supp+dose:supp,ToothGrowth)
summary(AOV2)

# 或者
# AOV2=lm(len ~ supp*dose,data=ToothGrowth)
# anova(AOV2)
# summary(AOV2)  #summary函数可以看到最后的统计量值，包含p

#3.2 诊断模型
res2<-residuals(AOV2)
shapiro.test(res2)
ggqqplot(res2)
leveneTest(res2~dose*supp,ToothGrowth)

#3.3 两两比较    post-hoc test                              
TukeyHSD(AOV2,'dose:supp')         


#3.4 作图
ggplot(ToothGrowth,aes(x = dose,y = len,fill = supp)) +
  stat_boxplot(geom = 'errorbar')+
  geom_boxplot() 

