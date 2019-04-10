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

# ToothGrowth$dose<-factor(ToothGrowth$dose,ordered = T)  #ԭ���ݼ�dose����Ϊ�ַ����������Ƿ������ӣ���dose����ת��Ϊ��������

# ����
table(ToothGrowth$supp,ToothGrowth$dose)
aggregate(ToothGrowth$len,by=list(ToothGrowth$supp,ToothGrowth$dose),FUN=mean)   #ԭ���ݼ�dose����Ϊ�ַ����������Ƿ�������
class(ToothGrowth$dose)    #�鿴���ݽṹ
ToothGrowth$dose<-factor(ToothGrowth$dose)     #��dose����ת��Ϊ��������
class(ToothGrowth$dose)



#1�����ط������
# 1.1 ��̬�Լ���
with(ToothGrowth,tapply(len, dose, shapiro.test))   #Shapiro-Wilk����

# 1.2 �������Լ���    
leveneTest(len~dose,ToothGrowth)   #�������ݿ���bartlett.test,3���3��������leveneTest

# 1.3 ������ANOVA
AOV1 <- aov(len~dose,ToothGrowth)
summary(AOV1)

# 1.4 ģ�����
res1<-residuals(AOV1)
res1<-AOV1$residuals
shapiro.test(res1)
ggqqplot(res1)
leveneTest(res1~dose,ToothGrowth)

# 1.5 �����Ƚ�
# TukeyHSD(AOV1)
# ����
Tu<-TukeyHSD(AOV1)
P <- Tu$dose[,4]
format(P,scientific = F)

# 1.6��ͼ
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



#2 Kruskal Wallis����       �����ݲ�������̬�ֲ�ʱ�����÷ǲ���Kruskal Wallis����
kruskal.test(len~dose,ToothGrowth)
with(ToothGrowth,pairwise.wilcox.test(len,dose,exact = F))



#3 ˫���ط������
#3.1 ˫����ANOVA
AOV2 <- aov(len~dose*supp,ToothGrowth)
AOV2 <- aov(len~dose+supp+dose:supp,ToothGrowth)
summary(AOV2)

# ����
# AOV2=lm(len ~ supp*dose,data=ToothGrowth)
# anova(AOV2)
# summary(AOV2)  #summary�������Կ�������ͳ����ֵ������p

#3.2 ���ģ��
res2<-residuals(AOV2)
shapiro.test(res2)
ggqqplot(res2)
leveneTest(res2~dose*supp,ToothGrowth)

#3.3 �����Ƚ�    post-hoc test                              
TukeyHSD(AOV2,'dose:supp')         


#3.4 ��ͼ
ggplot(ToothGrowth,aes(x = dose,y = len,fill = supp)) +
  stat_boxplot(geom = 'errorbar')+
  geom_boxplot() 
