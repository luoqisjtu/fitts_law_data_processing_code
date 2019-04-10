library(ggplot2)
source("functions.R")

# file: MT data 
# subject: 
# P_Value of before and after the intervention (neuromorphic on/off)
MT_data <- read.csv("D:\\Luoqi\\fitts_law\\data_analysis\\MT_line_chart_data_ba_S1-4.csv")
subdata1 <- MT_data[(MT_data$model =="off" | MT_data$model =="on"),]
t.test(subdata1$MT[subdata1$model=="off"], subdata1$MT[subdata1$model=="on"], alternative="less")


# files: successs rate data
# subject: 
# Do the comparision of P_Value in neuromorphic on and neuromorphic off
all_data <- read.csv("D:\\Luoqi\\fitts_law\\data_analysis\\success_rate_bar_chart_S1-4.csv")
subdata1 <- all_data[all_data$filter =="bw" & (all_data$model =="off" | all_data$model =="on"),]
t.test(subdata1$rate[subdata1$model=="off"], subdata1$rate[subdata1$model=="on"], alternative="less")
