rep1.dat = read_sav("/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/Pain_S1pilot_Czechia.sav")
rep2.dat = read_sav("/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/Pain_S2registered_Slovakia.sav")
org.dat = read_sav("/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/org_data_exp2.sav")

colnames(rep1.dat) = tolower(colnames(rep1.dat))
rep1.dat = rep1.dat[,c(1:3, 11:12, 15:52, 4:10)]


colnames(rep2.dat) = tolower(colnames(rep2.dat))
rep2.dat = rep2.dat %>% mutate(cooperation = (lottery1 + lottery2 + lottery3 + lottery4 + lottery5 + lottery6)/6)
rep2.dat = rep2.dat[,colnames(rep1.dat)]

colnames(rep1.dat)[4] = "subage"
colnames(rep2.dat)[4] = "subage"

org.dat = org.dat %>% mutate(cooperation = (lottery1 + lottery2 + lottery3 + lottery4 + lottery5 + lottery6)/6, 
                             groupnr = groupnumber, age = subage)
org.dat = org.dat[,c(colnames(rep1.dat), "groupsize", "subbornaus", "subbornloc", "subausyears", "subefl")]

org.dat$subgender = 1 * (org.dat$subgender == 1)
rep1.dat$subgender = 1 * (rep1.dat$subgender == 1)
rep2.dat$subgender = 1 * (rep2.dat$subgender == 1)

write.csv(rep1.dat, "/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/replication1_clean.csv")
write.csv(rep2.dat, "/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/replication2_clean.csv")
write.csv(org.dat, "/Users/ying/Desktop/Stanford/Research/Dominik/decomposition/datsets/pain_coop/rep/original_clean.csv")
