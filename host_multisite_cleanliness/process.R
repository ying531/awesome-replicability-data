library(haven)
library(readxl)


df1 = read_sav("data1.sav") 
df1 = df1 %>% mutate(sex = 1 * (sex == 1), # 1 = male, 
                     check_enjoy = Enjoy,
                     check_sweet = sweet,
                     check_bitter = bitter, 
                     check_neutral = neutral,
                     check_disgusting = disgusting, 
                     check_regular = enjoyregularly,
                     policonserv = 1 * (dummypolitical==2),
                     poliliberal = 1 * (dummypolitical==1),
                     years_college = yrscollege
)


df2 = read_sav("data2.sav")  
df2 = df2 %>% #drop_na(mean_vignettes_100) %>% 
  mutate(dummybitter = (condition == 1)*1,
         dummywater = (condition == 3) *1, 
         dummysweet = (condition == 2) *1, 
         javg = mean_vignettes_100,
         sex = 1 * (sex == 1),
         age = age,
         ## political orientation is inferred from "post_replication_recipe.pdf" in the OSF repo by sentences:
         ## "In  the replication only six  participants  were  classified  as  conservative." and 
         ## "Furthermore,two conservative participants  were  excluded from  analysis because theycorrectly  guessed the hypothesis.
         ## The  remaining sample  of four  conservative and 52  liberal participants .."
         # > table(df2$pol.orientation[df2$Include == 0]) 
         # 2  4 
         # 4  40
         # > table(df2$pol.orientation) 
         # 1  2  3  4 
         # 8  6  5 46 
         policonserv = 1 * (pol.orientation == 2),
         poliliberal = 1 * (pol.orientation == 4),
         # check_enjoy = check_enjoy,
         # check_sweet = check_sweet,
         check_bitter = check_herb,
         # check_neutral = check_neutral,
         # check_disgusting = check_disgusting, 
         check_regular = check_enjrgl
  ) 

# formulas <- list(mean_vignettes_100 ~ dummybitter,  
# mean_vignettes_100 ~ dummybitter + sex + sex * dummybitter,
# mean_vignettes_100 ~ dummybitter + age + age * dummybitter)
# calm(formulas, data = df2, target = "dummybitter")

df3 = read_sav("data3.sav") 
# some of the variables are confirmed via "final_syntax.sps" file in the OSF repository
df3 = df3 %>% mutate(dummybitter = (Condition == 2)*1,
                     dummywater = (Condition == 0) *1, 
                     dummysweet = (Condition == 1) *1, 
                     javg = (Bob +Frank + George + Arnold + Robert + Tim)*100/VignetteLineLength/6,
                     sex = 1* (Sex == 1),
                     age = Age,
                     ### conservative/liberal are identified by "Method_Results_Discussion.docx" using the following sentence:
                     ## "After excluding the 11 participants that correctly guessed this study’s hypothesis, 
                     ## 3 participants identified as being politically conservative, 
                     ## and 20 identified as being politically liberal" and 
                     ## "Because a large number of non-excluded participants identified as “other” (n = 16)"
                     ## > table(df3$PoliticalOrientation[df3$`filter_$`==1])
                     ## 0  1  2  3  4 
                     ## 3 20  6  2 16 
                     policonserv = 1 * (PoliticalOrientation == 0),
                     poliliberal = 1 * (PoliticalOrientation == 1),
                     # poliother = 1 * (PoliticalOrientation == 4),
                     # manipulation check
                     check_enjoy = Beverage1, 
                     check_sweet = Beverage2,
                     check_bitter = Beverage3,
                     check_neutral = Beverage4,
                     check_disgusting = Beverage5,
                     check_regular = Beverage6
)

df4 = read.csv("data4.csv", header =TRUE)
colnames(df4) = df4[1,]
df4 = df4[2:nrow(df4),]
df4 = df4 %>% mutate(dummybitter = (C == "B") * 1, 
                     dummywater = (C == "W") * 1, 
                     dummysweet = (C == "J") * 1,
                     javg = (as.numeric(moral_bob) + as.numeric(moral_frank) + 
                               as.numeric(moral_george) + as.numeric(moral_arnold) + 
                               as.numeric(moral_robert) + as.numeric(moral_tim))/6/1.4, # original measurement is out of 14mm
                     sex = 1 * (sex == "M"),
                     age = as.numeric(age),
                     policonserv = 1 * (politics0 == "Conservative"),
                     poliliberal = 1 * (politics0 %in% c('Liberal', 'Libertarian', 'Libeterian')), 
                     check_enjoy = bev_enjoy, 
                     check_sweet = bev_sweet, 
                     check_bitter = bev_bitter,
                     check_neutral = bev_neutral,
                     check_disgusting = bev_disgust,
                     check_regular = bev_enjoyreg
) 

df5 = read_excel("data5.xls")
df5 = df5 %>% mutate(dummybitter = (Drink == 'bitter') *1, 
                     dummywater = (Drink == 'water') * 1, 
                     dummysweet = (Drink == 'sweet') * 1, 
                     javg = (`Bob  (cm)` + `George (cm)` + 
                               `Frank (cm)` + `Congressman (cm)`+ 
                               `Robert (cm)` +`Tim (cm)`)*100/14/6, # original measurement is out of 14cm
                     sex = 1 * (Sex == "M"),
                     age = as.numeric(Age),
                     poliliberal = (Politics == "Liberal"),
                     policonserv = (Politics == 'Conservative'),
                     check_enjoy = Enjoy, 
                     check_sweet = sweet,
                     check_bitter = bitter, 
                     check_neutral = Neutral,
                     check_disgusting = Disgusting, 
                     check_regular = `Enjoy Reg`)

df6 = read_sav("data6.sav")
df6 = df6 %>% mutate(dummybitter = (Condition == 2)*1, 
                     dummywater = (Condition == 1) * 1,
                     dummysweet = (Condition == 3) * 1, 
                     javg = (Bob + Frank + George + Arnold + Robert + Tim) * 100/14/6, # original measurement is out of 14mm
                     sex = Sex,
                     age = Age,
                     poliliberal = (PoliticalOrientationcoded == 1)*1,
                     policonserv = (PoliticalOrientationcoded == 0)*1,
                     # poliother = (PoliticalOrientationcoded > 1) *1,
                     check_enjoy = Beverage1,
                     check_sweet = Beverage2,
                     check_bitter = Beverage3,
                     check_neutral = Beverage4,
                     check_disgusting = Beverage5,
                     check_regular = Beverage6)

df7 = read.csv("data7.csv")
df7.demo = read.csv("data7_demographic.csv")
df7 = df7 %>% left_join(df7.demo, by = "newID", suffix = c("", ".y"))
df7$age[df7$age==-99] = NA
df7 = df7 %>% mutate(dummybitter = (conditionlabel == 'bitter')*1, 
                     dummywater = (conditionlabel == 'neutral') * 1,
                     dummysweet = (conditionlabel == 'sweet') * 1, 
                     javg = moralwrongness.y,
                     sex = 1 * (sex %in% c("Male", "M", "male")),
                     age = age,
                     # political inferred from "motorstudy_data_demographics.csv" in OSF repo
                     poliliberal = (political_coded == 4)*1,
                     policonserv = (political_coded == 1)*1,
                     check_enjoy = renjoybev_1,
                     check_sweet = rsweet_1,
                     check_bitter = rbitter_1,
                     check_neutral = rneutral_1,
                     check_disgusting = rdisgusting_1,
                     check_regular = renjoyreg_1
)


df8 = read.csv("data8_same1.csv") # already coded experiment
df8 = df8 %>% mutate(javg = javg,
                     sex = 1 * (sex %in% c("1", "1 (m) ")),
                     poliliberal = dummypolitical %in% c("1", "1 (liberal) "),
                     policonserv = dummypolitical %in% c("2", "2 (conservative) "),
                     check_enjoy = enjoy,
                     check_sweet = sweet,
                     check_bitter = bitter,
                     check_neutral = neutral,
                     check_disgusting = disgusting,
                     check_regular = enjoyregularly)

df9 = read_sav("data9.sav")
df9$Bob_1[is.na(df9$Bob_1)] = df9$Bob_1.0[is.na(df9$Bob_1)]
df9$Frank_1[is.na(df9$Frank_1)] = df9$Frank_1.0[is.na(df9$Frank_1)]
df9$George_1[is.na(df9$George_1)] = df9$George_1.0[is.na(df9$George_1)]
df9$Arnold_1[is.na(df9$Arnold_1)] = df9$Arnold_1.0[is.na(df9$Arnold_1)]
df9$Robert_1[is.na(df9$Robert_1)] = df9$Robert_1.0[is.na(df9$Robert_1)]
df9$Tim_1[is.na(df9$Tim_1)] = df9$Tim_1.0[is.na(df9$Tim_1)]
df9 = df9 %>% mutate(dummybitter = (Condition == 3)*1, # inferred from questionnaire questions
                     dummywater = (Condition == 1)*1, 
                     dummysweet = (Condition == 2)*1, 
                     javg = (Bob_1+Frank_1+George_1+Arnold_1+Robert_1+Tim_1)/6,
                     sex = 1 * (Gender == 1),
                     age = as.numeric(Age),
                     policonserv = (Polideo == 1)*1, # inferred from questionnaire
                     # polineutral = (Polideo ==2) *1,
                     poliliberal = (Polideo ==3) *1,
                     check_enjoy = Enjoy,
                     check_sweet = Sweet,
                     check_bitter = Bitter,
                     check_neutral = Neutral,
                     check_disgusting = Disgusting, 
                     check_regular = Enjoy_regularly)

df10 = read_sav("data10_BdH.sav")
colnames(df10) = tolower(colnames(df10))
df10 = df10 %>% mutate(javg = avgjudg, 
                       policonserv = (politorient == "right"),
                       poliliberal = (politorient == 'left')) %>% drop_na(javg) %>%
  mutate(sex = 1 * (q1.0 == "male"),
         age = q2.1,
         check_enjoy = q2.0,
         check_sweet = q3.0,
         check_bitter = q4.0,
         check_neutral = q5,
         check_disgusting = q6,
         check_regular = q7)

df11 = read_sav('data11.sav')
df11 = df11 %>% mutate(dummybitter = (Condition == 2)*1,
                       dummysweet = (Condition == 3)*1, 
                       dummywater = (Condition == 1)*1, 
                       javg = (Bob+Frank+George+Arnold+Robert+Tim)*100/14/6,
                       sex = Sex,
                       age = Age,
                       poliliberal = (Politicalorientstring %in% c("Anarchist/Progessive", 
                                                                   "Demographic", "Liberal", 
                                                                   "Libertarian", "Moderately leaning left")),
                       policonserv = (Politicalorientstring %in% c("Conservative")),
                       check_enjoy = Beverage1,
                       check_sweet = Beverage2,
                       check_bitter = Beverage3,
                       check_neutral = Beverage4,
                       check_disgusting = Beverage5,
                       check_regular = Beverage6)

#### output clean data
df1_clean = df1 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df2_clean = df2 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df3_clean = df3 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df4_clean = df4 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df5_clean = df5 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df6_clean = df6 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df7_clean = df7 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df8_clean = df8 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df9_clean = df9 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                           check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df10_clean = df10 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                             check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)
df11_clean = df11 %>% select(dummybitter, dummysweet, dummywater, javg, sex, age, policonserv, poliliberal,
                             check_enjoy, check_sweet, check_bitter, check_neutral, check_disgusting, check_regular)



df_pooled = rbind(df1_clean %>% mutate(study = 1),
                  df2_clean %>% mutate(study = 2),
                  df3_clean %>% mutate(study = 3),
                  df4_clean %>% mutate(study = 4),
                  df5_clean %>% mutate(study = 5),
                  df6_clean %>% mutate(study = 6),
                  df7_clean %>% mutate(study = 7),
                  df8_clean %>% mutate(study = 8),
                  df9_clean %>% mutate(study = 9),
                  df10_clean %>% mutate(study = 10),
                  df11_clean %>% mutate(study = 11)
)

# deal with missing values
df_pooled$check_enjoy = as.numeric(df_pooled$check_enjoy)
df_pooled$check_enjoy[df_pooled$check_enjoy==-99] = NA

df_pooled$check_bitter = as.numeric(df_pooled$check_bitter)
df_pooled$check_bitter[df_pooled$check_bitter==-99] = NA

df_pooled$check_sweet = as.numeric(df_pooled$check_sweet)
df_pooled$check_sweet[df_pooled$check_sweet==-99] = NA

df_pooled$check_neutral = as.numeric(df_pooled$check_neutral)
df_pooled$check_neutral[df_pooled$check_neutral==-99] = NA

df_pooled$check_disgusting = as.numeric(df_pooled$check_disgusting)
df_pooled$check_disgusting[df_pooled$check_disgusting==-99] = NA

df_pooled$check_regular = as.numeric(df_pooled$check_regular)
df_pooled$check_regular[df_pooled$check_regular==-99] = NA

write.csv(df_pooled, "./cleaned/all_pooled.csv")

for (j in 1:11){
  write.csv(df_pooled %>% filter(study==j), paste("./cleaned/study", j, ".csv", sep=''))
} 

 