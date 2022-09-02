rm(list = ls())

## TO DO:
# Load dataset 
# Plot gaze position data based on timestamps 
# Baseline substraction of pupil positions based on target location 
# Scan path with timestamp 

######################
#LOAD IN LIBRARIES 
######################

source("/Users/newxjy/Dropbox/VICE/JT/DEUBAL/Functions/r_functions.R")
call_libraries()
text_size <- 25
axis_text <- 18
th <- theme_pubclean(base_family = "Helvetica")  + theme(panel.grid.major = element_blank(), 
                                                         panel.grid.minor = element_blank(), 
                                                         strip.background = element_blank(), 
                                                         panel.spacing.x=unit(1.5, "lines"),
                                                         axis.line = element_line(colour = "black", size = 1), 
                                                         legend.position = "right", 
                                                         text=element_text(size= text_size, family="Helvetica"), 
                                                         strip.text.x = element_text(size=text_size, face="bold"), 
                                                         axis.text.x = element_text(size = axis_text), 
                                                         axis.text.y = element_text(size = axis_text), 
                                                         axis.title.y = element_text(margin = margin(t = 0, r = 8, b = 0, l = 0)), 
                                                         axis.title.x = element_text(vjust=-0.3), 
                                                         axis.ticks.length=unit(0.25,"cm"))


######################
# CLEAN DATA FILES
######################

gaze <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Data/April28_2020/Eyetracking/001/exports/000/surfaces/fixations_on_surface_WM.csv", header=T, sep=",")
trial30 <- pupil[13428:13648,]

plot(gaze$norm_pos_x, gaze$norm_pos_y)

# Load data and define variables 
datafile1 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V1_SUB1.csv", header=T, sep=",")
datafile2.1 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V2.1_SUB1.csv", header=T, sep=",")
datafile2.2 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V2.2_SUB1.csv", header=T, sep=",")
datafile2.3 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V2.3_SUB1.csv", header=T, sep=",")
datafile2.4 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V2.4_SUB1.csv", header=T, sep=",")
datafile2.5 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V2.5_SUB1.csv", header=T, sep=",")
datafile3 <- read.csv("/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/EXP1_V3_SUB1.csv", header=T, sep=",")

dim(datafile1)
dim(datafile2.1)
dim(datafile2.2)
dim(datafile2.3)
dim(datafile2.4)
dim(datafile2.5)
dim(datafile3)

baseline <- datafile1
rotation <- rbind(datafile2.1,datafile2.2, datafile2.3,datafile2.4, datafile2.5)
baseline <- datafile3
TOTAL_SUBJ1 <- rbind(datafile1, datafile2.1,datafile2.2, datafile2.3,datafile2.4, datafile2.5, datafile3)
dim(TOTAL_SUBJ1)

write.csv(TOTAL_SUBJ1,"/Users/newxjy/Dropbox/VICE/JT/STRATEGY/Analyze/April28_2020/TOTAL_SUBJ1.csv")

rotation$TN <- 1:300
TOTAL_SUBJ1$TN <- 1:372
for(si in 1:31){
  TOTAL_SUBJ1$CN[((si-1)*12+1):(12*si)] <- si
}
######################
# PLOT HAND ANGLE
######################

# Baseline substraction
TOTAL_SUBJ1$hand <- TOTAL_SUBJ1$hand_theta
targets <- unique(TOTAL_SUBJ1$ti)
num.tar <- length(targets)
num.sub <- length(unique(TOTAL_SUBJ1$SN))

for (si in 1:num.sub){
  for(tar in 1:num.tar){
    idx <- TOTAL_SUBJ1$SN == si & TOTAL_SUBJ1$ti == targets[tar] & TOTAL_SUBJ1$TN >= 1 & TOTAL_SUBJ1$TN <= 36
    hand_mean <- mean(TOTAL_SUBJ1$hand[idx], na.rm = TRUE)
    print(hand_mean)
    
    idx_ti <- TOTAL_SUBJ1$SN == si & TOTAL_SUBJ1$ti == targets[tar]
    TOTAL_SUBJ1$hand[idx_ti] <- TOTAL_SUBJ1$hand[idx_ti] - hand_mean
  }
}

#Plot hand angle
## Single subject
ggplot(TOTAL_SUBJ1, aes(x = TN, y = hand, color = factor(SN))) + 
  geom_line() + 
  #facet_grid(.~ti) +
  labs(color = "SN") +
  xlab("Trial Number") +
  ylab("Hand") +
  ggtitle("DAY1") +
  geom_hline(yintercept=-75, linetype="dashed", color = "black") +
  geom_vline(xintercept= 36, linetype="dashed", color = "black") +
  geom_vline(xintercept= 336, linetype="dashed", color = "black") 

#Average hand angle by cycle
TOTAL_SUBJ1$avg_hand <- NA
for(ji in 1:31){
  TOTAL_SUBJ1$avg_hand[((ji-1)*12+1)] <- mean(TOTAL_SUBJ1$hand[((ji-1)*12+1):(12*ji)])
}

ggplot(TOTAL_SUBJ1, aes(x = TN, y = avg_hand, color = factor(SN))) + 
  geom_point() + 
  labs(color = "SN") +
  xlab("Trial Number") +
  ylab("Movement angle") +
  ggtitle("DAY1") +
  geom_hline(yintercept=-75, linetype="dashed", color = "black") +
  geom_vline(xintercept= 36, linetype="dashed", color = "black") +
  geom_vline(xintercept= 336, linetype="dashed", color = "black") 

######################
# PLOT RT
######################
TOTAL_SUBJ1$avg_RT <- NA
for(ti in 1:31){
  TOTAL_SUBJ1$avg_RT[((ti-1)*12+1)] <- mean(TOTAL_SUBJ1$RT[((ti-1)*12+1):(12*ti)])
}

ggplot(TOTAL_SUBJ1, aes(x = TN, y = avg_RT, color = factor(SN))) + 
  geom_point() + 
  stat_smooth() +
  labs(color = "SN") +
  xlab("Trial Number") +
  ylab("RT (s)") +
  ggtitle("DAY1") +
  geom_vline(xintercept= 36, linetype="dashed", color = "black") +
  geom_vline(xintercept= 336, linetype="dashed", color = "black") 


