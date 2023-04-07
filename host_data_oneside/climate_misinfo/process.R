rep.dat = read_sav("1. OSF Raw dataset 2019..sav")
colnames(rep.dat)

rep.dat$Gender_female = 1 * (rep.dat$Gender == 2)
rep.dat$Education_college = 1 * (rep.dat$Educ %in% c(2,3,4))
rep.dat$Party_democrat = 1 * (rep.dat$Party == 1)

write.csv(rep.dat, "replication_cleaned.csv")

org.dat = data.frame("Gender_female" = 0.56, 
                     "Education_college" = 0.5,
                     "Party_democrat" = 0.37)
write.csv(org.dat, "original_cleaned.csv")
