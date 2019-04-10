# demo1 <- read.csv("http://www.ats.ucla.edu/stat/data/demo1.csv")

demo1 <- read.csv("E:\\Nutstore\\fitts_law\\data_analysis\\huzixiang_pd_data1.csv")

library(lmerTest)
demo1.lmer1 <- lmer (log(MT) ~ tremor + (1|trial) + (1|s), data=demo1)
anova(demo1.lmer1)
summary(demo1.lmer1)

