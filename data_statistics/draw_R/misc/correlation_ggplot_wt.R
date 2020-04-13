# Draw line chart (linear regression line)
library(Rmisc)
library(ggplot2)
library(grDevices)

all_data <-read.csv("fes_data_delta.csv")
group1 = 'sham' 
group2 = 'fes' 

indep_choose<- c('fugl_meyer',
              'sim_vector_pca','sim_timeprofile_pca','sim_combine_pca',
              'sim_vector','sim_timeprofile','sim_combine')

func_choose<- c('pkvel','bell_error','duration',
              'hand_endpoint','shoulder_flex','elbow_flex')

task_choose<- c('fr','lr')

for (i in 2:7) {
  
  task = task_choose[2]
  for (j in 1:6){
    
    indep_var = indep_choose[i]
    func_var = func_choose[j]
    
    subdata_sham <- all_data[(all_data$task == task) & (all_data$group == group1),]
    subdata_fes <- all_data[(all_data$task == task) & (all_data$group == group2),]
    subdata_all <- all_data[(all_data$task == task),]
    data_sham = subdata_sham[,c(indep_var,func_var)]
    data_fes = subdata_fes[,c(indep_var,func_var)]
    data_all = subdata_all[,c(indep_var,func_var,'group')]
    
    #calculate          
    
    # colour="#000099" À¶É«
    # colour="#CC0000" ºìÉ«
    # colour="black" ºÚÉ«
    
    # lm(y~x)
    # sham
    x<- c(data_sham[,1])
    y<- c(data_sham[,2])
    model.lm <- lm(y~x)
    summary(model.lm)
    
    list_corr_sham <- list(a = format(coef(model.lm)[1], digits = 3),
                           b = format((coef(model.lm)[2]), digits = 3),
                           r2 = format(summary(model.lm)$r.squared, digits = 3),
                           p = format(summary(model.lm)$coefficients[2,4], digits = 3))
    eq_sham <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p,list_corr_sham)
    
    # fes
    x<- c(data_fes[,1])
    y<- c(data_fes[,2])
    model.lm <- lm(y~x)
    summary(model.lm)
    
    list_corr_fes <- list(a = format(coef(model.lm)[1], digits = 3),
                          b = format((coef(model.lm)[2]), digits = 3),
                          r2 = format(summary(model.lm)$r.squared, digits = 3),
                          p = format(summary(model.lm)$coefficients[2,4], digits = 3))
    eq_fes <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p,list_corr_fes)
    
    # sham + fes
    x<- c(data_all[,1])
    y<- c(data_all[,2])
    model.lm <- lm(y~x)
    summary(model.lm)
    
    list_corr_all <- list(a = format(coef(model.lm)[1], digits = 3),
                          b = format((coef(model.lm)[2]), digits = 3),
                          r2 = format(summary(model.lm)$r.squared, digits = 3),
                          p = format(summary(model.lm)$coefficients[2,4], digits = 3))
    eq_all <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p,list_corr_all)
    
    # paste equation
    txt_eq_sham = paste('y=',list_corr_sham$a,'+',list_corr_sham$b,'*x','  r^2=',list_corr_sham$r2,'  p=',list_corr_sham$p);
    txt_eq_fes = paste('y=',list_corr_fes$a,'+',list_corr_fes$b,'*x','  r^2=',list_corr_fes$r2,'  p=',list_corr_fes$p);
    txt_eq_all = paste('y=',list_corr_all$a,'+',list_corr_all$b,'*x','  r^2=',list_corr_all$r2,'  p=',list_corr_all$p);
    
    # plot
    p <- ggplot(data_all,aes(x,y,color=group))+
      geom_point(size=2)+
      geom_smooth(method='lm', se=FALSE,colour="black")+
      geom_smooth(method='lm', se=FALSE)+
      
      # lable
      labs(title = paste('sham:',txt_eq_sham,'\n','fes:',txt_eq_fes,'\n','all:',txt_eq_all) )+
      theme(plot.title=element_text(hjust=0.5, size=10))+
      ylab(func_var)+
      xlab(indep_var)+
      #xlim(-3,20) +
      #ylim(-0.03,0.03) +
      
      theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) +
      theme(panel.background = element_blank()) +
      theme(axis.line = element_line(colour = "black")) +
      
      theme(axis.text.x = element_text(hjust=0.5, vjust=1, size=10)) +
      theme(axis.text.y = element_text(angle=90, hjust=0.5, vjust=1, size=10)) +
      
      theme(axis.title.x=element_text(face="italic", colour="black", size=14)) +
      theme(axis.title.y=element_text(angle= 90, face="italic", colour="black",size=14)) +
      
      #remove_border
      theme(panel.border = element_blank()) +
      geom_smooth(method=lm, se=FALSE,colour="black")
    
    ggsave(paste("E:\\correlation_results\\",indep_var,"VS",func_var,"_",task,".png",sep=""),p,width = 4,height = 3 )
    ggsave(paste("E:\\correlation_results\\",indep_var,"VS",func_var,"_",task,".eps",sep=""),p,width = 4,height = 3 )
    
  }
}



















