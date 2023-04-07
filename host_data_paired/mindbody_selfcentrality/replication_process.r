library(haven)
# select file (OSF_S1)
df <- read_sav("yoga_replication.sav")

completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

# Calculate Self-centrality
library(ltm)
library(sjstats)
# df2 <- completeFun(df,5:8)
# cronbach.alpha(df2[,c(5:8)])
df_sc = df[,5:8]
df$SC <- 0
for (j in 1:nrow(df_sc)){
  if (sum(!is.na(df_sc[j,]))>3){
    df$SC[j] = mean(as.numeric(df_sc[j,]), na.rm=TRUE)
  }else{
    df$SC[j] = NA
  }
}

# Calculate BTA
# df2 <- completeFun(df,9:12)
# cronbach.alpha(df2[,c(9:12)])
# df$BTA_Basic <- mean_n(df[,c(9:12)],3)
df_bta = df[,9:12]
df$BTA_Basic <- 0
for (j in 1:nrow(df_bta)){
  if (sum(!is.na(df_bta[j,]))>3){
    df$BTA_Basic[j] = mean(as.numeric(df_bta[j,]), na.rm=TRUE)
  }else{
    df$BTA_Basic[j] = NA
  }
}

# df2 <- completeFun(df,13:14)
# cronbach.alpha(df2[,c(13:14)])
# df$BTA_Exp <- mean_n(df[,c(13:14)],1)
df_bta = df[,13:14]
df$BTA_Exp <- 0
for (j in 1:nrow(df_bta)){
  if (sum(!is.na(df_bta[j,]))>1){
    df$BTA_Exp[j] = mean(as.numeric(df_bta[j,]), na.rm=TRUE)
  }else{
    df$BTA_Exp[j] = NA
  }
}

cor.test(df$BTA_Basic,df$BTA_Exp)
library(lavaan)

# one-f
one.model <- ' pooled  =~ BTA_1 + BTA_2 + BTA_3 + BTA_4 + BTA_5 + BTA_6'
fit <- cfa(one.model, data=df,std.lv=TRUE)
summary(fit, fit.measures=TRUE,standardized=TRUE)
# two-f
two.model <- ' f1  =~ BTA_1 + BTA_2 + BTA_3 + BTA_4
f2 =~ BTA_5 + BTA_6'
fit2 <- cfa(two.model, data=df, std.lv=TRUE)
summary(fit2, fit.measures=TRUE,standardized=TRUE)
anova(fit,fit2)

# Calculate Narcissism
# df2 <- completeFun(df,16:19)
# cronbach.alpha(df2[,c(16:19)])
# df$Narcissism <- mean_n(df[,c(16:19)],3)
df_nc = df[,16:19]
df$Narcissism <- 0
for (j in 1:nrow(df_nc)){
  if (sum(!is.na(df_nc[j,]))>3){
    df$Narcissism[j] = mean(as.numeric(df_nc[j,]), na.rm=TRUE)
  }else{
    df$Narcissism[j] = NA
  }
}

# Split out people who did not attend
library(dplyr)
df <- df %>% filter((attendance == 1) | (attendance == 2))

#load packages
library(foreign, pos=4)
library(psych)
library(GPArotation)
library(lme4)
library(car)
library(mediation)
library(lavaan)
library(BayesFactor)
library(coda)

datR <- df

#standardize variables
datR$z.cen <- scale(datR$SC)
datR$z.bta <- scale(datR$BTA_Basic)
datR$z.btaex <- scale(datR$BTA_Exp)
datR$z.cni <- scale(datR$Narcissism)
datR$z.se <- scale(datR$Selfesteem_1)

mod <- 'z.g =~ z.bta + z.cni + z.se'
fit <- cfa(mod, data=datR, missing = "FIML",std.lv=T) 
summary(fit, fit.measures=T, standardized=T) 
z.g <- scale(predict(fit, newdata = datR)) 
datR <- cbind(data.frame(datR),z.g)

mod <- 'z.g2 =~ z.bta + z.cni'
fit <- cfa(mod, data=datR, missing = "FIML",std.lv=T) 
summary(fit, fit.measures=T, standardized=T) 
z.g2 <- scale(predict(fit, newdata = datR)) 
datR <- cbind(data.frame(datR),z.g2) 

#group-mean center variables
datR$z.cen.grp <- datR$z.cen - (ave(datR$z.cen, datR$PID)) 
datR$z.g.grp <- datR$z.g - (ave(datR$z.g, datR$PID)) 
datR$z.g2.grp <- datR$z.g2 - (ave(datR$z.g2, datR$PID)) 
datR$z.cni.grp <- datR$z.cni - (ave(datR$z.cni, datR$PID)) 
datR$z.se.grp <- datR$z.se - (ave(datR$z.se, datR$PID))
datR$z.bta.grp <- datR$z.bta - (ave(datR$z.bta, datR$PID)) 

#define PID and cond as factors
datR$PID <- as.factor(datR$PID)
datR$attendance <- as.factor(datR$attendance)
datR$attendance <- ifelse(datR$attendance == 2, 1, 0)
datR$z.imp <- datR$z.cen
datR$cond <- datR$attendance
datR$vpn <- datR$PID


# process data
keep_names = c( "cond", "vpn" , "Wave", "attendance", "gender", "age",
                "z.cen", "z.bta", "z.btaex", "z.cni", "z.se" , "z.g", "z.g2" ,
                "z.cen.grp", "z.g.grp", "z.g2.grp", "z.cni.grp", "z.se.grp", "z.bta.grp")
datR = datR[, keep_names]
colnames(datR) = c( "condition", "participant_id" , "wave", "surveyed_after_yoga_session",  
                    "sex", "age",
                    "z_self_centrality", "z_better_than_average", "z_exp_better_than_average", 
                    "z_communal_narcissism", "z_self_esteem" , "z_g_factor", "z_g_factor_well_being" ,
                    "z_grouped_self_centrality", "z_grouped_g_factor", "z_grouped_g_factor_well_being", 
                    "z_grouped_communal_narcissism", "z_grouped_self_esteem", "z_grouped_better_than_average")
datR$sex[datR$sex==2] = 01
write.csv(datR, "yoga_replication_cleaned.csv")

### meditation 
datR <- read.csv("OSF_S2.csv")

#### BTA CFAs
# one-f
one.model <- ' pooled  =~ bta01 + bta02 + bta03 + bta04 + bta05 + bta06 + bta07 + bta08 + bta09 + bta10 + bta11 + bta12 + bta13 + bta14 + bta15 + bta16'
fit <- cfa(one.model, data=datR,std.lv=TRUE)
summary(fit, fit.measures=TRUE,standardized=TRUE)
# two-f
two.model <- ' f1  =~ bta01 + bta02 + bta03 + bta04 + bta05 + bta06 + bta07 + bta08 + bta09 + bta10
f2 =~ bta11 + bta12 + bta13 + bta14 + bta15 + bta16'
fit2 <- cfa(two.model, data=datR, std.lv=TRUE)
summary(fit2, fit.measures=TRUE,standardized=TRUE)
anova(fit,fit2)

# one-f
one.model <- ' pooled  =~ cni01 + cni02 + cni03 + cni04 + cni05 + cni06 + cni07 + cni08 + cni09 + cni10 + cni11 + cni12 + cni13 + cni14 + cni15 + cni16 + cni17 + cni18 + cni19 + cni20 + cni21 + cni22'
fit <- cfa(one.model, data=datR,std.lv=TRUE)
summary(fit, fit.measures=TRUE,standardized=TRUE)
# two-f
two.model <- ' f1  =~ cni01 + cni02 + cni03 + cni04 + cni05 + cni06 + cni07 + cni08 + cni09 + cni10 + cni11 + cni12 + cni13 + cni14 + cni15 + cni16
f2 =~ cni17 + cni18 + cni19 + cni20 + cni21 + cni22'
fit2 <- cfa(two.model, data=datR, std.lv=TRUE)
summary(fit2, fit.measures=TRUE,standardized=TRUE)
anova(fit,fit2)

############# OPTIONAL! REMOVAL OF INEXPERIENCED STUDY 2 PARTICIPANTS! 
# Choice A
# datR <- datR %>% filter(NoZero == 0)
# Choice A
# datR <- datR %>% filter(NoSD == 0)
# Choice A
# datR <- datR %>% filter(NoSDorNA == 0)

#compute means
datR$imp <- rowMeans(datR[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")], na.rm = T)
datR$bta <- rowMeans(datR[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")], na.rm = T)
datR$cni <- rowMeans(datR[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")], na.rm = T)
#expansion items
datR$impex <- rowMeans(datR[c("imp11","imp12","imp13","imp14","imp15","imp16")], na.rm = T)
datR$btaex <- rowMeans(datR[c("bta11","bta12","bta13","bta14","bta15","bta16")], na.rm = T)
datR$cniex <- rowMeans(datR[c("cni17","cni18","cni19","cni20","cni21","cni22")], na.rm = T)
#Rescale Rosenberg
datR$rse3r <- 100 - datR$rse3
datR$rse5r <- 100 - datR$rse5
datR$rse8r <- 100 - datR$rse8
datR$rse9r <- 100 - datR$rse9
datR$rse10r <- 100 - datR$rse10
datR$se <- rowMeans(datR[c("rse1","rse2","rse3r","rse4","rse5r","rse6","rse7","rse8","rse9r","rse10r")], na.rm = T)
#Rescale Hedonic wellbeing #5, 6, 7, 8, 9 --> 2, 4, 6, 8, 9 in ours
datR$aff02r <- 100 - datR$aff02
datR$aff04r <- 100 - datR$aff04
datR$aff06r <- 100 - datR$aff06
datR$aff08r <- 100 - datR$aff08
datR$aff09r <- 100 - datR$aff09
datR$aff <- rowMeans(datR[c("aff01","aff02r","aff03","aff04r","aff05","aff06r","aff07","aff08r" ,"aff09r")], na.rm = T)
datR$swl <- rowMeans(datR[c("swl01","swl02","swl03","swl04","swl05")], na.rm = T) 
datR$hed <- rowMeans(datR[c("aff","swl")], na.rm = T)
#Rescale Eudemonic wellbeing #2, 3, 6, 7, 10, 12 --> 2, 4, 6, 7, 9, 11 in ours
datR$eud02r <- 100 - datR$eud02
datR$eud04r <- 100 - datR$eud04
datR$eud06r <- 100 - datR$eud06
datR$eud07r <- 100 - datR$eud07
datR$eud09r <- 100 - datR$eud09
datR$eud11r <- 100 - datR$eud11
datR$eud <- rowMeans(datR[c("eud01","eud02r","eud03","eud04r","eud05","eud06r","eud07r","eud08","eud09r","eud10","eud11r","eud12")], na.rm = T)

#preparation for alpha computation per assessment 
mzp.1 <- subset(datR, subset = mzp == 1)
mzp.2 <- subset(datR, subset = mzp == 2)
mzp.3 <- subset(datR, subset = mzp == 3) 
mzp.4 <- subset(datR, subset = mzp == 4)

#alpha: self-centrality
omega(mzp.1[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])  
omega(mzp.2[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])  
omega(mzp.3[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])  
omega(mzp.4[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")]) 

#alpha: better-than-average
omega(mzp.1[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")]) 
omega(mzp.2[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])
omega(mzp.3[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])
omega(mzp.4[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])

#alpha: communal narcissism 
omega(mzp.1[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")])
omega(mzp.2[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")]) 
omega(mzp.3[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")]) 
omega(mzp.4[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")]) 

#alpha: self-esteem
omega(mzp.1[c("rse1","rse2","rse3r","rse4","rse5r","rse6","rse7","rse8","rse9r","rse10r")], na.rm = T) 
omega(mzp.2[c("rse1","rse2","rse3r","rse4","rse5r","rse6","rse7","rse8","rse9r","rse10r")])
omega(mzp.3[c("rse1","rse2","rse3r","rse4","rse5r","rse6","rse7","rse8","rse9r","rse10r")]) 
omega(mzp.4[c("rse1","rse2","rse3r","rse4","rse5r","rse6","rse7","rse8","rse9r","rse10r")], na.rm = T) 

#alpha: hedonic well-being - affective component
omega(mzp.1[c("aff01","aff02r","aff03","aff04r","aff05","aff06r","aff07","aff08r" ,"aff09r")], na.rm = T)
omega(mzp.2[c("aff01","aff02r","aff03","aff04r","aff05","aff06r","aff07","aff08r" ,"aff09r")], na.rm = T)
omega(mzp.3[c("aff01","aff02r","aff03","aff04r","aff05","aff06r","aff07","aff08r" ,"aff09r")], na.rm = T) 
omega(mzp.4[c("aff01","aff02r","aff03","aff04r","aff05","aff06r","aff07","aff08r" ,"aff09r")], na.rm = T) 

#alpha: hedonic well-being - cognitive component
omega(mzp.1[c("swl01","swl02","swl03","swl04","swl05")])
omega(mzp.2[c("swl01","swl02","swl03","swl04","swl05")])
omega(mzp.3[c("swl01","swl02","swl03","swl04","swl05")])
omega(mzp.4[c("swl01","swl02","swl03","swl04","swl05")])

#correlation: affective and cognitive components of hedonic well-being
lm(scale(mzp.1$aff) ~ scale(mzp.1$swl))
lm(scale(mzp.2$aff) ~ scale(mzp.2$swl))
lm(scale(mzp.3$aff) ~ scale(mzp.3$swl))
lm(scale(mzp.4$aff) ~ scale(mzp.4$swl))

#alpha: eudemonic well-being
omega(mzp.1[c("eud01","eud02r","eud03","eud04r","eud05","eud06r","eud07r","eud08","eud09r","eud10","eud11r","eud12")]) 
omega(mzp.2[c("eud01","eud02r","eud03","eud04r","eud05","eud06r","eud07r","eud08","eud09r","eud10","eud11r","eud12")])
omega(mzp.3[c("eud01","eud02r","eud03","eud04r","eud05","eud06r","eud07r","eud08","eud09r","eud10","eud11r","eud12")]) 
omega(mzp.4[c("eud01","eud02r","eud03","eud04r","eud05","eud06r","eud07r","eud08","eud09r","eud10","eud11r","eud12")]) 

#alpha: expansion self-centrality
omega(mzp.1[c("imp11","imp12","imp13","imp14","imp15","imp16")]) 
omega(mzp.2[c("imp11","imp12","imp13","imp14","imp15","imp16")])
omega(mzp.3[c("imp11","imp12","imp13","imp14","imp15","imp16")]) 
omega(mzp.4[c("imp11","imp12","imp13","imp14","imp15","imp16")]) 

#alpha: expansion BTA
omega(mzp.1[c("bta11","bta12","bta13","bta14","bta15","bta16")]) 
omega(mzp.2[c("bta11","bta12","bta13","bta14","bta15","bta16")])
omega(mzp.3[c("bta11","bta12","bta13","bta14","bta15","bta16")]) 
omega(mzp.4[c("bta11","bta12","bta13","bta14","bta15","bta16")])

#alpha: expansion communal narcissism (communal goals)
omega(mzp.1[c("cni17","cni18","cni19","cni20","cni21","cni22")]) 
omega(mzp.2[c("cni17","cni18","cni19","cni20","cni21","cni22")])
omega(mzp.3[c("cni17","cni18","cni19","cni20","cni21","cni22")]) 
omega(mzp.4[c("cni17","cni18","cni19","cni20","cni21","cni22")])

#standardize variables
datR$z.imp <- scale(datR$imp)
datR$z.bta <- scale(datR$bta)
datR$z.cni <- scale(datR$cni)
datR$z.se <- scale(datR$se)
datR$z.hed <- scale(datR$hed)
datR$z.eud <- scale(datR$eud)
datR$z.impex <- scale(datR$impex)
datR$z.btaex <- scale(datR$btaex)
datR$z.cniex <- scale(datR$cniex)
datR$z.bta11 <- scale(datR$bta11)
datR$z.bta12 <- scale(datR$bta12)
datR$z.bta13 <- scale(datR$bta13)
datR$z.bta14 <- scale(datR$bta14)
datR$z.bta15 <- scale(datR$bta15)
datR$z.bta16 <- scale(datR$bta16)


# output datasets
keep_names = c('cond','vpn','mzp', 'ethnic', 'gender','age',  
               'z.imp','z.bta','z.cni','z.se','z.hed','z.eud','z.impex',
               'z.btaex','z.cniex', 'z.exp', 
               'z.g','z.g2','z.imp.grp','z.g.grp','z.g2.grp')
dat = datR[,keep_names]
colnames(dat) = c("condition", "participant_id", "assessment_time", "enthicity", "sex", "age", 
                  "z_self_centrality", "z_better_than_average", "z_communal_narcissism", "z_self_esteem", 
                  "z_hedonic_well_being", "z_eudemonic_well_being", "z_exp_self_centrality",
                  "z_expansion_better_than_average", "z_expansion_communal_narcissimism", "z_practice_years", 
                  "z_g_factor", "z_g_factor_well_being", "z_grouped_self_centrality", 
                  "z_grouped_g_factor", "z_grouped_g_factor_well_being" )


write.csv(dat, "meditation_replication_cleaned.csv")
