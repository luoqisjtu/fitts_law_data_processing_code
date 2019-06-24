library(Rmisc)
library(ggplot2)
library(grDevices)
#data

#fHandle=file.choose()
#read.csv(fHandle,header=TRUE)

tg<-read.csv("D:\\Luoqi\\fitts_law\\conjoint_analysis_results\\MT_line_chart_data_ba_S1-4.csv")
tg


#tg <- ToothGrowth
head(tg)


#calculate
#tgc <- summarySE(tg, measurevar="len", groupvars=c("supp","dose"))

tgc <- summarySE(tg, measurevar="MT", groupvars=c("model","number","ID"))
tgc


#plot
# pd <- position_dodge(0.1) # move them .05 to the left and right
# p <- ggplot(tgc, aes(x=ID, y=MT), color=number) +
#   geom_errorbar(aes(ymin=MT-se, ymax=MT+se), width=.1, position=pd) +
# #  geom_line() +
#   geom_point(position=pd) +
#   geom_smooth(method = "lm", se=FALSE, color="red", formula = y ~ x)



p <- ggplot(tgc, aes(x=ID, y=MT,shape=model, color=model)) +
  geom_errorbar(aes(ymin=MT-se, ymax=MT+se), width=.1) +
  # geom_line(position=position_dodge(0.2)) + # Dodge lines by 0.2
  geom_point(size=2)+
  geom_smooth(method="lm", se=FALSE, fullrange=TRUE)  #Ìí¼Ó»Ø¹éÏß
  # geom_smooth(method = "lm", se=FALSE, color="red", formula = y ~ x)
 
# lm_eqn <- function(data){
#   m <- lm(y ~ x, data=tgc);
#   eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
#                    list(a = format(coef(m)[1], digits = 2),
#                         b = format(coef(m)[2], digits = 2),
#                         r2 = format(summary(m)$r.squared, digits = 3)))
#   as.character(as.expression(eq));
# }
# 
# # p1 <- p + geom_text(x = 6, y = 20, label = lm_eqn(tgc), parse = TRUE)
# p1 <- p + geom_text(aes(x = 6, y = 20, label = lm_eqn(lm(y ~ x, data=tgc))), parse = TRUE)
# p1


# model.lm <- lm(MT ~ ID, data = tgc)
# summary(model.lm)

# l <- list(a = format(coef(model.lm)[1], digits = 3),
#           b = format(abs(coef(model.lm)[2]), digits = 3),
#           r2 = format(summary(model.lm)$r.squared, digits = 3),
#           p = format(summary(model.lm)$coefficients[2,4], digits = 3))
# 
# eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2~","~italic(P)~"="~p, l)



equation = function(tgc) { 
  mod = lm(MT ~ ID,data=tgc) 
  mod_sum = summary(mod) 
  formula = sprintf("y= %.3f %+.3f*x", coef(mod)[1], coef(mod)[2]) 
  r = mod_sum$r.squared 
  r2 = sprintf("r2= %.3f", r) 
  x = cor.test(~ID + MT,data=tgc) 
  r0 = sprintf("r= %.3f", x[4]) 
  p1 = pf(mod_sum$fstatistic[1],mod_sum$fstatistic[2],mod_sum$fstatistic[3],lower.tail=F) 
p =sprintf("p = %.3f", p1) 
n0 = length(mod_sum$residual) 
n1 = sprintf("N = %.f", n0) 
data.frame(formula=formula, r=r0,r2=r2, p=p,n=n1, stringsAsFactors=FALSE) 
} 

equation_end = ddply(tgc, c("model"), equation)



# ggplot(tgc, aes(x, y, color=model)) + 
#   geom_point() + 
#   geom_smooth(fill=NA) + show.legend = F
#   geom_text(data=equation_end, aes(x=c(-1,-1), y=c(3,4), label=formula), show_guide=F)

# 
# annotate("text", c(2,6), c(0,15), label=equation_end$formula)



p1 <- p + geom_text(data=equation_end, aes(x=c(1,6), y=c(0,15), label=formula)) +
  # labs(title = "Amputated side (brittleness)") +
  # labs(title = "Contralateral side(no brittleness)") +
  labs(title = "S3-No brittleness") +
  # theme_set(theme_bw()) +
  theme(plot.title=element_text(hjust=0.5)) +
   
  theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank()) +
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  
  theme(axis.text.x = element_text(hjust=1, vjust=1, size=14)) +
  theme(axis.text.y = element_text(angle=90, hjust=1, vjust=1, size=14)) +
  
  xlab("ID\n") + 
  theme(axis.title.x=element_text(face="italic", colour="black", size=18)) +
  ylab("MT(s)-Mark\n")+
  theme(axis.title.y=element_text(angle=90, face="italic", colour="black",size=18)) +
  
  theme(panel.border = element_blank())
  # p_remove_border
                                   
p1














