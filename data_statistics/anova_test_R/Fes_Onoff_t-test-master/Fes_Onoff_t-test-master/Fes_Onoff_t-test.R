#setwd("~/Dropbox/cmn.OnGoing/OnOff experiments")
library(ggplot2)
source("functions.R")

# Dr.Niu's file: tab_fes_pkvel.csv 
# subject: S05-S11
# P_Value of before and after the intervention
pk_vel <- read.csv("tab_fes_pkvel.csv")
subdata1 <- pk_vel[pk_vel$Side =="FR" & (pk_vel$Subject =="S08_2" | pk_vel$Subject =="S08_3"),]
t.test(subdata1$Pk_Vel[subdata1$Subject=="S08_2"], subdata1$Pk_Vel[subdata1$Subject !="S08_2"], alternative="less")


# Dr.Niu¡®s files: Vel_Peak_OnOff_new.csv 
# subject: F01-F05
# Do the comparision of P_Value in Type0 and Type 2-4
all_data <- read.csv("Vel_Peak_OnOff_new.csv")
all_data$Type_all <- factor(all_data$Type_all)
handxy <- all_data[all_data$Var_all=="handxy",]
subdata1 <- handxy[handxy$Task_all=="FR" & handxy$Subn_all=="F05" & (handxy$Type_all=="0" | handxy$Type_all=="4"),]
t.test(subdata1$Peak_all[subdata1$Type_all=="0"], subdata1$Peak_all[subdata1$Type_all!="0"], alternative="less")


# Tong¡®s file: 'Tong_OnOff.csv'
# # subject: S02,S03,S04
# Do the comparision of P_Value in sham(0) and waveform 1-5
all_data <- read.csv("Tong_OnOff.csv")
subdata1 <- all_data[all_data$Task=="FR" & all_data$Subject=="S03" & (all_data$Type=="0" | all_data$Type=="4"),]
t.test(subdata1$Pk_Vel[subdata1$Type=="0"], subdata1$Pk_Vel[subdata1$Type!="0"], alternative="less")


wilcox.test(subdata1$Peak_all[subdata1$Type_all=="0"], subdata1$Peak_all[subdata1$Type_all!="0"],paired=FALSE) 


fit.1 <- lm(Peak_all ~ Type_all, data=subdata1) 
summary(fit.1)



# dfm$diff <- dfm$after - dfm$before




fit.0 <- lmer(Peak_all ~ Type_all + (1|Subn_all/Trial_all), data=fr_data) 
summary(fit.0)
tgc <- summarySE(all_data, measurevar="fm_ul_diff", groupvars=c("group"))
pd <- position_dodge(0.1) # move them .05 to the left and right

ggplot(all_data, aes(x=group, y=fm_ul_diff)) + 
  geom_boxplot()

ggplot(all_data, aes(x=group, y=adl_diff)) + 
  geom_boxplot()

### Baseline test using Chi-square
# Entering the data into vectors
mk_gender = c(7, 6, 13)
rtms_gender = c(8, 6, 14)
total = c(15, 12, 27)



# combining the row vectors in matrices, then converting the matrix into a data frame
tbl = as.data.frame(rbind(mk_gender, rtms_gender, total))

# assigning column names to this data frame
names(tbl) = c('male', 'female', 'subtotal')

chisq.test(tbl)

