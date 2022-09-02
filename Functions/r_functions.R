data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

data_summary_med <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = median(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

data_summary_grp <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sem = std.error(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

data_summary_count <- function(data, varname, groupnames){
  
  require(plyr)
  
  summary_func <- function(x, col){
    c(count = length(x[[col]]))
  }
  
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("count" = varname))
  return(data_sum)
}

call_libraries <- function(){
  library(rcompanion)
  library(psych)
  library(lme4)
  library(car) 
  library(ggplot2)
  library(reshape)
  library(plotrix)
  library(gdata)
  library(miscTools)
  library(tidyr)
  library(gridExtra)
  library(nlme)
  library(cowplot)
  library(JM)
  library(multcomp)
  library(FSA)
  library(pbkrtest)
  library(MuMIn)
  library(nloptr)
  library(progress)
  library(lsr)
  library(dplyr)
  library(quickpsy)
  library(ggpubr)
  library(pracma)
  library(effects)
  library(ggsci)
  library(ggthemes)
  library(reader)
  library(stringr)
}




