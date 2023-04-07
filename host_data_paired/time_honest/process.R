# original data 
org.dat = read.csv("./DataOriginalStudies.csv", sep=';') %>% filter(Experiment == 2)
# Gender == 2 is female
org.dat$Gender = 1 * (org.dat$Gender == 1)
colnames(org.dat)[2] = "Treatment"
org.dat = org.dat[,colnames(org.dat)[c(1,2,4,5,7:24)]]

library(readxl)

# experiment 1
rep1.data = read_excel("Raw Data PDR1.xlsx", sheet=1)
rep1.data = rep1.data[-c(1,2),]
rep1.df = read.csv("Final_Data_PDR1.csv", row.names = NULL, sep=';')

rep1.merge = rep1.data
# rep1.merge = rep1.df
rep1.merge$Response.time = ""
rep1.merge$Response.time[!is.na(rep1.data$`Q15_Last Click`)] = rep1.data$`Q15_Last Click`[!is.na(rep1.data$`Q15_Last Click`)]
rep1.merge$Response.time[!is.na(rep1.data$`Q14_Last Click`)] = rep1.data$`Q14_Last Click`[!is.na(rep1.data$`Q14_Last Click`)]
rep1.merge$Response.time = as.numeric(rep1.merge$Response.time)

rep1.df$Response.time = as.numeric(sapply(rep1.df$Response.time, 
                                          function(x) str_replace(x, ",", ".")))

# merge outcome 
rep1.merge$Reported.outcome = ""
rep1.merge$Reported.outcome[!is.na(rep1.data$Dice_Outcome_No_Time_1)] = rep1.data$Dice_Outcome_No_Time_1[!is.na(rep1.data$Dice_Outcome_No_Time_1)]
rep1.merge$Reported.outcome[!is.na(rep1.data$Dice_Outcome_Time_Pr_1)] = rep1.data$Dice_Outcome_Time_Pr_1[!is.na(rep1.data$Dice_Outcome_Time_Pr_1)]
rep1.merge$Reported.outcome = as.numeric(rep1.merge$Reported.outcome)


# for identification across datasets
rep1.merge.df = rep1.df
rep1.merge.df$combined = mapply(function(x,y,z,w,v) paste(x,y,z,w,v), 
                             rep1.merge.df$Response.time, rep1.merge.df$Reported.outcome, 
                             rep1.merge.df$TP, 
                             rep1.merge.df$The.ratio.between.the.dice.roll.and.the.possible.reward.is...,
                             rep1.merge.df$What.is.the.chance.that.you.will.get.the.reward.)
rep1.merge$combined = mapply(function(x,y,z,w,v) paste(x,y,z,w,v),
                             rep1.merge$Response.time, rep1.merge$Reported.outcome,
                             1 * (rep1.merge$FL_4_DO == "Timepressureblock1"), 
                             rep1.merge$Q22,
                             rep1.merge$Q28_1)
# merged
rep1.joined = left_join(rep1.merge.df, rep1.merge, by = "combined")                             
rep1.joined = rep1.joined[rep1.joined$Exclusion == 0,]

# select variables
rep1.joined = rep1.joined[,c(1,2,4,5,6,7,8,9,10,11,13,15,44:58)]
rename.mood <- function(x){
  if (x == "Slightly feel"){return(2)}
  if (x == "Definitely feel"){return(4)}
  if (x == "Do not feel"){return(1)}
  if (x == 'Definitely do not feel'){return(0)}
}
for (j in 13:27){
  rep1.joined[,j] = sapply(rep1.joined[,j], rename.mood)
}
colnames(rep1.joined)[13:27] = c("Lively", "Peppy", "Happy", "Loving", "Caring", "Drowsy", "Tired", "Nervous", 
                                 "Calm", "Gloomy", "Fed_up", "Sad", "Jittery", "Grouchy", "Content")
# Gender = 1 is female 
rep1.joined$Gender = 1 * (rep1.joined$Gender == 2)
colnames(rep1.joined)[1] = "Dice_report"
colnames(rep1.joined)[3] = "Treatment"
colnames(rep1.joined)[2] = "Report_time"


org.dat = org.dat[,c(c("Gender", "Treatment", "Dice_report", "Report_time", "happy", "loving", "tired", "calm", "gloomy", "bored", "sad", "satisfied"), 
                     c("Cheerful", "active",  "active2",  "tired2", "angry", "tense", "angry2", "pos_mood", "neg_mood"))]

first_cols = c("Gender", "Treatment", "Dice_report", "Report_time", "Happy", "Loving", "Tired", "Calm", 
               "Gloomy", "Fed_up", "Sad", "Content")
rep1.joined = rep1.joined[,c(first_cols, setdiff(colnames(rep1.joined), first_cols))]
colnames(org.dat)[1:12] = colnames(rep1.joined)[1:12]

write.csv(org.dat, "original_cleaned.csv")
write.csv(rep1.joined, "replication1_cleaned.csv")



# experiment 2
rep2.data = read_excel("PDR2_Raw_Data.xlsx", sheet=1) 
rep2.df = read_excel("PDR2_Final_Data.xlsx", sheet=1)
rep2.df = rep2.df[rep2.df$Exclusion==0,]
colnames(rep2.df)[c(19,20,21,22)] = c("What.is.the.chance.that.you.will.get.the.reward." ,
                                      "Several.students.will.receive.a.monetary.reward.for.the.dice.under.cup.game.",
                                      "My.dice.role.was.fully.anonymous.only.I.could.know.what.I.rolled.",
                                      "The.ratio.between.the.dice.roll.and.the.possible.reward.is...")
rep2.cols = c("SexQ", "Condition", "reported.roll", "Time", 
              "The.ratio.between.the.dice.roll.and.the.possible.reward.is...",               
              "What.is.the.chance.that.you.will.get.the.reward." ,    
              "My.dice.role.was.fully.anonymous.only.I.could.know.what.I.rolled.",
              "Several.students.will.receive.a.monetary.reward.for.the.dice.under.cup.game.",
              "Age", "MotherTongue", "Nationality", "Study")
rep2.df = rep2.df[,c(rep2.cols, setdiff(colnames(rep2.df), rep2.cols))]
rep2.df = rep2.df[,-c(13:25)]
rep2.df = rep2.df[,-c(15,16,17)]
colnames(rep2.df)[1:4] = c("Gender", "Treatment", "Dice_report", "Report_time")

write.csv(rep2.df, "replication2_cleaned.csv")
