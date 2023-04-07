org1.dat = read.csv("./yoga_original.csv")
dat = org1.dat

#load packages
library(psych)
library(lme4)
library(car)
library(mediation)
library(lavaan)
library(BayesFactor)
library(coda)

#compute means
dat$imp <- rowMeans(dat[c("imp01","imp02","imp03","imp04")], na.rm = T)
dat$bta <- rowMeans(dat[c("bta01","bta02","bta03","bta04")], na.rm = T)
dat$cni <- rowMeans(dat[c("cni01","cni02","cni03","cni04")], na.rm = T)
dat$npi <- rowMeans(dat[c("npi01","npi02","npi03","npi04")], na.rm = T)

#t-test bta
dat.contr <- subset(dat, subset = cond == 0)
dat.vpn <- aggregate(bta ~ vpn, dat.contr, mean)
t.test(dat.vpn$bta,mu=6)
remove(dat.contr,dat.vpn)
#standardize variables
dat$z.imp <- scale(dat$imp)
dat$z.bta <- scale(dat$bta)
dat$z.cni <- scale(dat$cni)
dat$z.npi <- scale(dat$npi)
dat$z.se <- scale(dat$se)
#beginners vs. advanced
dat.b <- aggregate(pra ~ vpn, dat, mean)
mean(dat.b$pra, na.rm = T)
sd(dat.b$pra, na.rm = T)
dat.b$z.pra <- scale(dat.b$pra)
dat.b$pra <-NULL
dat <- merge(dat, dat.b, by = "vpn", all = T)
remove(dat.b)


#self-enhancement g-factor
mod <- 'z.g =~ z.bta + z.cni + z.se'
fit <- cfa(mod, data=dat, missing = "FIML")
summary(fit, fit.measures=T, standardized=T)
z.g <- scale(predict(fit, newdata = dat))
dat <- data.frame(dat,z.g)
remove(fit,z.g,mod)
#self-enhancement g-factor for well-being analysis (without self-esteem)
mod <- 'z.g2 =~ 1*z.bta + 1*z.cni'
fit <- cfa(mod, data=dat, missing = "FIML")
summary(fit, fit.measures=T, standardized=T)
z.g2 <- scale(predict(fit, newdata = dat))
dat <- data.frame(dat,z.g2)
remove(fit,z.g2,mod)

#group-mean center variables
dat$z.imp.grp <- dat$z.imp - (ave(dat$z.imp, dat$vpn))
dat$z.g2.grp <- dat$z.g2 - (ave(dat$z.g2, dat$vpn))
#define vpn and cond as factors
dat$vpn <- as.factor(dat$vpn)
dat$cond <- as.factor(dat$cond)
#write output to file
dat = dat[,c("cond", "vpn", "mzp", "age", "sex", "z.imp", "z.bta", "z.cni", "z.npi", 
             "z.se", "z.pra", "z.g", "z.g2", "z.imp.grp", "z.g2.grp" )]
colnames(dat) = c("condition", "participant_id", "assessment_time", "age", "sex", 
                  "z_self_centrality", "z_better_than_average", "z_communal_narcissism", "z_agentic_narcissism",
                  "z_self_esteem", "z_practice_years", "z_g_factor", "z_g_factor_well_being", 
                  "z_grouped_self_centrality", "z_grouped_g_factor_well_being")
write.csv(dat, "yoga_original_cleaned.csv")

##### meditation 
dat <- read.csv(url("https://madata.bib.uni-mannheim.de/266/2/meditation.csv"),
                header = T, sep = ",")
#descriptives: N and n
dat.mzp <- aggregate(mzp ~ vpn, dat, mean)
dat.yoga <- subset(dat, cond == 1)
dat.cont <- subset(dat, cond == 0)
nrow(dat)
nrow(dat.mzp)
nrow(dat) / nrow(dat.mzp)
nrow(dat.yoga)
nrow(dat.cont)

remove(dat.mzp,dat.yoga,dat.cont)
#descriptives: age
dat.age <- aggregate(age ~ vpn, dat, mean)
mean(dat.age$age)
sd(dat.age$age)
remove(dat.age)
#descriptives: sex
dat.sex <- aggregate(sex ~ vpn, dat, mean)
100*prop.table(table(dat.sex$sex))
remove(dat.sex)
#descriptives: yoga expertise (in months)
dat.pra <- aggregate(pra ~ vpn, dat, mean)
dat.pra$exp <- dat.pra$pra/12
mean(dat.pra$exp)
sd(dat.pra$exp)
remove(dat.pra)
#compute means
dat$imp <- rowMeans(dat[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")], na.rm = T)
dat$bta <- rowMeans(dat[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")], na.rm = T)
dat$cni <- rowMeans(dat[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")], na.rm = T)
dat$se <- rowMeans(dat[c("rse01","rse02r","rse03","rse04","rse05r","rse06r","rse07","rse08r","rse09r","rse10")], na.rm = T)
dat$aff <- rowMeans(dat[c("aff01","aff02","aff03","aff04","aff05r","aff06r","aff07r","aff08r","aff09r")], na.rm = T)
dat$swl <- rowMeans(dat[c("swl01","swl02","swl03","swl04","swl05")], na.rm = T)
dat$hed <- rowMeans(dat[c("aff","swl")], na.rm = T)
dat$eud <- rowMeans(dat[c("eud01","eud02r","eud03r","eud04","eud05","eud06r","eud07r","eud08","eud09","eud10r","eud011","eud12r")], na.rm = T)
dat$eqe <- rowMeans(dat[c("msca_senh","msce_senh")], na.rm = T)
dat$ocq <- rowMeans(dat[c("ocq_bias_med_mv","ocq_bias_com_mv")], na.rm = T)
#preparation for alpha computation per assessment
mzp.1 <- subset(dat, subset = mzp == 1)
mzp.2 <- subset(dat, subset = mzp == 2)
mzp.3 <- subset(dat, subset = mzp == 3)
mzp.4 <- subset(dat, subset = mzp == 4)
#alpha: self-centrality (average: .90)
alpha(data.frame(mzp.1[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])) #.87
alpha(data.frame(mzp.2[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])) #.91
alpha(data.frame(mzp.3[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])) #.91
alpha(data.frame(mzp.4[c("imp01","imp02","imp03","imp04","imp05","imp06","imp07","imp08","imp09","imp10")])) #.89
#alpha: better-than-average (average: .93)

alpha(data.frame(mzp.1[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])) #.91
alpha(data.frame(mzp.2[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])) #.91
alpha(data.frame(mzp.3[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])) #.94
alpha(data.frame(mzp.4[c("bta01","bta02","bta03","bta04","bta05","bta06","bta07","bta08","bta09","bta10")])) #.95
#alpha: communal narcissism (average: .94)
alpha(data.frame(mzp.1[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")])) #.92
alpha(data.frame(mzp.2[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")])) #.94
alpha(data.frame(mzp.3[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")])) #.95
alpha(data.frame(mzp.4[c("cni01","cni02","cni03","cni04","cni05","cni06","cni07","cni08","cni09","cni10","cni11","cni12","cni13","cni14","cni15","cni16")])) #.93
#alpha: self-esteem (average: .94)
alpha(data.frame(mzp.1[c("rse01","rse02r","rse03","rse04","rse05r","rse06r","rse07","rse08r","rse09r","rse10")])) #.92
alpha(data.frame(mzp.2[c("rse01","rse02r","rse03","rse04","rse05r","rse06r","rse07","rse08r","rse09r","rse10")])) #.93
alpha(data.frame(mzp.3[c("rse01","rse02r","rse03","rse04","rse05r","rse06r","rse07","rse08r","rse09r","rse10")])) #.95
alpha(data.frame(mzp.4[c("rse01","rse02r","rse03","rse04","rse05r","rse06r","rse07","rse08r","rse09r","rse10")])) #.94
#alpha: hedonic well-being - affective component (average: .93)
alpha(data.frame(mzp.1[c("aff01","aff02","aff03","aff04","aff05r","aff06r","aff07r", "aff08r","aff09r")])) #.91
alpha(data.frame(mzp.2[c("aff01","aff02","aff03","aff04","aff05r","aff06r","aff07r","aff08r","aff09r")])) #.95
alpha(data.frame(mzp.3[c("aff01","aff02","aff03","aff04","aff05r","aff06r","aff07r","aff08r","aff09r")])) #.92
alpha(data.frame(mzp.4[c("aff01","aff02","aff03","aff04","aff05r","aff06r","aff07r","aff08r","aff09r")])) #.92
#alpha: hedonic well-being - cognitive component (average: .88)
alpha(data.frame(mzp.1[c("swl01","swl02","swl03","swl04","swl05")])) #.88
alpha(data.frame(mzp.2[c("swl01","swl02","swl03","swl04","swl05")])) #.88
alpha(data.frame(mzp.3[c("swl01","swl02","swl03","swl04","swl05")])) #.90
alpha(data.frame(mzp.4[c("swl01","swl02","swl03","swl04","swl05")])) #.87
#correlation: affective and cognitive components of hedonic well-being (average:.72)
lm(scale(mzp.1$aff) ~ scale(mzp.1$swl)) #.73
lm(scale(mzp.2$aff) ~ scale(mzp.2$swl)) #.74
lm(scale(mzp.3$aff) ~ scale(mzp.3$swl)) #.74
lm(scale(mzp.4$aff) ~ scale(mzp.4$swl)) #.68
#alpha: eudemonic well-being (average: .83)
alpha(data.frame(mzp.1[c("eud01","eud02r","eud03r","eud04","eud05","eud06r","eud07r","eud08","eud09","eud10r","eud011","eud12r")])) #.82
alpha(data.frame(mzp.2[c("eud01","eud02r","eud03r","eud04","eud05","eud06r","eud07r","eud08","eud09","eud10r","eud011","eud12r")])) #.84
alpha(data.frame(mzp.3[c("eud01","eud02r","eud03r","eud04","eud05","eud06r","eud07r","eud08","eud09","eud10r","eud011","eud12r")])) #.83
alpha(data.frame(mzp.4[c("eud01","eud02r","eud03r","eud04","eud05","eud06r","eud07r","eud08","eud09","eud10r","eud011","eud12r")])) #.83
#alpha: eq-enhancement (average: .62)
alpha(data.frame(mzp.1[c("msca_senh","msce_senh")])) #.53
alpha(data.frame(mzp.2[c("msca_senh","msce_senh")])) #.67
alpha(data.frame(mzp.3[c("msca_senh","msce_senh")])) #.70
alpha(data.frame(mzp.4[c("msca_senh","msce_senh")])) #.58
#alpha: over-claiming (average: .35)
alpha(data.frame(mzp.1[c("ocq_bias_med_mv","ocq_bias_com_mv")])) #.43
alpha(data.frame(mzp.2[c("ocq_bias_med_mv","ocq_bias_com_mv")])) #.36
alpha(data.frame(mzp.3[c("ocq_bias_med_mv","ocq_bias_com_mv")])) #.52
alpha(data.frame(mzp.4[c("ocq_bias_med_mv","ocq_bias_com_mv")])) #.08
remove(mzp.1,mzp.2,mzp.3,mzp.4)
#t-test bta
dat.contr <- subset(dat, subset = cond == 0)
dat.vpn <- aggregate(bta ~ vpn, dat.contr, mean)
t.test(dat.vpn$bta,mu=41)
remove(dat.contr,dat.vpn)
#standardize variables
dat$z.imp <- scale(dat$imp)
dat$z.bta <- scale(dat$bta)
dat$z.cni <- scale(dat$cni)
dat$z.se <- scale(dat$se)
dat$z.hed <- scale(dat$hed)
dat$z.eud <- scale(dat$eud)
dat$z.eqe <- scale(dat$eqe)
dat$z.ocq <- scale(dat$ocq)
#beginners vs. advanced
dat.b <- aggregate(pra ~ vpn, dat, mean)
mean(dat.b$pra, na.rm = T)
sd(dat.b$pra, na.rm = T)
dat.b$z.pra <- scale(dat.b$pra)
dat.b$z.pra.max <- dat.b$z.pra - 1
dat.b$z.pra.min <- dat.b$z.pra + 1
dat.b$pra <-NULL
dat <- merge(dat, dat.b, by = "vpn", all = T)
remove(dat.b)
#self-enhancement g-factor
mod <- 'z.g =~ z.bta + z.cni + z.se'
fit <- cfa(mod, data=dat, missing = "FIML")
summary(fit, fit.measures=T, standardized=T)
z.g <- scale(predict(fit, newdata = dat))
dat <- data.frame(dat,z.g)
remove(fit,z.g,mod)
#self-enhancement g-factor for well-being analysis (without self-esteem)
mod <- 'z.g2 =~ 1*z.bta + 1*z.cni'
fit <- cfa(mod, data=dat, missing = "FIML")
summary(fit, fit.measures=T, standardized=T)
z.g2 <- scale(predict(fit, newdata = dat))
dat <- data.frame(dat,z.g2)
remove(fit,z.g2,mod)
#self-enhancement g-factor, including additional measures (see online supplement S6)
mod <- 'z.g3 =~ z.bta + z.cni + z.se + z.eqe + z.ocq'
fit <- cfa(mod, data=dat, missing = "FIML")
summary(fit, fit.measures=T, standardized=T)
z.g3 <- scale(predict(fit, newdata = dat))
dat <- data.frame(dat,z.g3)
remove(fit,z.g3,mod)
#group-mean center variables
dat$z.imp.grp <- dat$z.imp - (ave(dat$z.imp, dat$vpn))
dat$z.g.grp <- dat$z.g - (ave(dat$z.g, dat$vpn))
dat$z.g2.grp <- dat$z.g2 - (ave(dat$z.g2, dat$vpn))
#define vpn and cond as factors
dat$vpn <- as.factor(dat$vpn)
dat$cond <- as.factor(dat$cond)

# rename columns
# dat = dat[,c("cond", "vpn", "mzp", "age", "sex", "z.imp", "z.bta", "z.cni", "z.npi", 
#              "z.se", "z.pra", "z.g", "z.g2", "z.imp.grp", "z.g2.grp" )]
dat = dat[, c("cond", "vpn", "mzp",  "age", "sex", "z.pra", "z.imp", "z.bta", "z.cni", "z.se", 
              "z.hed", "z.eud", "z.eqe", "z.ocq", 
              "z.g", "z.g2", "z.g3", "z.imp.grp", "z.g.grp", "z.g2.grp")]
# colnames(dat) = c("condition", "participant_id", "assessment_time", "age", "sex", 
#                   "z_self_centrality", "z_better_than_average", "z_communal_narcissism", "z_agentic_narcissism",
#                   "z_self_esteem", "z_practice_years", "z_g_factor", "z_g_factor_well_being", 
#                   "z_grouped_self_centrality", "z_grouped_g_factor_well_being")
colnames(dat) = c("condition", "participant_id", "assessment_time", "age", "sex", 
                  "z_practice_years", "z_self_centrality", "z_better_than_average", 
                  "z_communal_narcissism", "z_self_esteem", 
                  "z_hedonic_well_being", "z_eudemonic_well_being", "z_eq_enhancement", "z_over_claiming", 
                  "z_g_factor", "z_g_factor_well_being", "z_g_factor_5measure", 
                  "z_grouped_self_centrality", "z_grouped_g_factor", "z_grouped_g_factor_well_being")
write.csv(dat, "meditation_original_cleaned.csv")
