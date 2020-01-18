library(Rmisc)
library(ggplot2)
library(grDevices)


sub_data<-read.csv("CT_line_chart_data_single_finger.csv")   #outcome_metrics_bar_chart_S2.csv   force_rms_roughness_S2.csv
demo_data <- sub_data
demo_data


par(mfrow=c(1,2))
# boxplot(var_value~model,data = demo_data,main="car mileage data",xlab="number of cylinders",
#         ylab="miles per gallon")
boxplot(CT~model,data = demo_data, notch=FALSE,outline=TRUE,border=c("red","green","blue"),       #±ß¿òÑÕÉ«-border; Ìî³äÉ«-col=c(¡°purple¡±,¡±green¡±,¡±blue¡±)  col=rainbow(3),
        pars = list(boxwex = 0.6, staplewex = 0.5, outwex = 0.5),           #range = 5,
        ylim = c(0, 15), 
        main="three model",xlab="model",ylab="Completion Time (s)")  