# demo1 <- read.csv("http://www.ats.ucla.edu/stat/data/demo1.csv")

demo1 <- read.csv("D:\\Luoqi\\fitts_law\\local_fitts_law_data_processing_code\\data_statistics\\two_way_repeated_measures_anova\\huzixiang_pd_data.csv")

library(lmerTest)
demo1.lmer1 <- lmer (log(MT) ~ tremor + (1|trial) + (1+ tremor|subject), data=demo1)
anova(demo1.lmer1)
summary(demo1.lmer1)

demo1.lmer2 <- lmer (log(MT) ~ PSD + (1|trial) + (1+ PSD|subject), data=demo1)
anova(demo1.lmer2)
summary(demo1.lmer2)

demo1.lmer3 <- lmer (log(RT) ~ tremor + (1|trial) + (1+ tremor|subject), data=demo1)
anova(demo1.lmer3)
summary(demo1.lmer3)


demo1.lmer4 <- lmer (log(RT) ~ PSD + (1|trial) + (1+ PSD|subject), data=demo1)
anova(demo1.lmer4)
summary(demo1.lmer4)
