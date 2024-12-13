library(haven)
library(fastDummies)

 
data = readRDS("./ML1_data.rds")
 


covariates_list = c("resp_sex", "resp_age", "resp_race", "resp_ethnicity", 
                    "resp_major", "resp_pid", "resp_nativelang", "resp_religion", 
                    "resp_american", "resp_american_pid", "resp_american_ideo"
                    )


data[,covariates_list]

pdata = data

pdata = pdata %>% mutate(resp_gender = (resp_sex == "female"), 
                         resp_ethnicity_hisp = 1 * (resp_ethnicity == "hispanic or latino")) 

## ========================================= ##
##   process covariates   ##
## ========================================= ## 

# process race 

pdata = pdata %>% mutate(
  RACE = case_when(
    resp_race == "white" ~ "white",  
    resp_race %in% c("belgisch nederlands", "nederlands", "nederlandse", "marokkaans nederlands", "italiaans nederlands") ~ "nederland", 
    resp_race == 'black or african american' ~ 'black_american',
    resp_race %in% c("chinese", "east asian") ~ "east_asian", 
    resp_race %in% c("indian", "south asian") ~ "south_asian",
    resp_race %in% c("more than one race - other", "more than one race - black/white") ~ "more_than_one",
    resp_race == 'american indian/alaskan native' ~ "american_indian",
    resp_race %in% c("brazilbrown", "brazilblack", "brazilwhite", "brazilyellow") ~ "brazil", 
    .default = "others"
  )
) 
race_vars = fastDummies::dummy_cols(pdata%>%select(RACE)) %>% select(-RACE)
pdata = cbind(pdata, race_vars)


# process major
pdata = pdata %>% mutate(
  MAJOR = case_when(
    resp_major %in% c("Communications", "Education", "Law or legal studies", "Psychology", 
                      "Social sciences or history") ~ "Social",
    resp_major %in% c("Computer and information sciences", 
                      "Engineering, mathematics, physical sciences/technologies") ~ "Engineer", 
    resp_major %in% c("Biological sciences/life sciences", "Health professions or related sciences") ~ "Science",
    .default = 'others' 
  ) 
)
major_vars = fastDummies::dummy_cols(pdata%>%select(MAJOR)) %>% select(-MAJOR)
pdata = cbind(pdata, major_vars)

# process political ideology
pdata = pdata %>% mutate(
  polideo = case_when(
    resp_pid == "Strongly Conservative" ~ 0, 
    resp_pid == "Moderately Conservative" ~ 1, 
    resp_pid == "Slightly Conservative" ~ 2, 
    resp_pid == "Neutral (Moderate)" ~ 3, 
    resp_pid == "Slightly Liberal" ~ 4,
    resp_pid == "Moderately Liberal" ~ 5, 
    resp_pid == "Strongly Liberal" ~ 6, 
    .default = NA
  )
)
pdata$resp_polideo = proc_fill_na(pdata$polideo)

covariates_list = c(
  c("resp_gender", "resp_age", "resp_ethnicity_hisp", 
    "resp_polideo", 
    "resp_american", "resp_american_pid", "resp_american_ideo"),
  colnames(race_vars), 
  colnames(major_vars)
)

# fill NA
pdata = pdata %>% filter(!is.na(iv), !is.na(dv))

pdata = pdata %>% group_by(site) %>% 
  mutate(mean_age = mean(resp_age, na.rm=TRUE),
         mean_gender = mean(resp_gender, na.rm=TRUE),
         mean_hisp = mean(resp_ethnicity_hisp, na.rm=TRUE),
         mean_polideo = mean(resp_polideo, na.rm=TRUE)) 
pdata$resp_age[is.na(pdata$resp_age)] = pdata$mean_age[is.na(pdata$resp_age)]
pdata$resp_gender[is.na(pdata$resp_gender)] = pdata$mean_gender[is.na(pdata$resp_gender)]
pdata$resp_ethnicity_hisp[is.na(pdata$resp_ethnicity_hisp)] = pdata$mean_hisp[is.na(pdata$resp_ethnicity_hisp)]
pdata$resp_polideo[is.na(pdata$resp_polideo)] = pdata$mean_polideo[is.na(pdata$resp_polideo)]

colSums(is.na(pdata))

# these three variables have low correlation
pdata = pdata %>% group_by(site) %>% 
  mutate(mean_am = mean(resp_american, na.rm=TRUE),
         mean_am_pid = mean(resp_gender, na.rm=TRUE),
         mean_am_ideo = mean(resp_american_pid, na.rm=TRUE),
         mean_polideo = mean(resp_american_ideo, na.rm=TRUE)) 
pdata$resp_american[is.na(pdata$resp_american)] = pdata$mean_am[is.na(pdata$resp_american)]
pdata$resp_american_pid[is.na(pdata$resp_american_pid)] = pdata$mean_am_pid[is.na(pdata$resp_american_pid)]
pdata$resp_american_ideo[is.na(pdata$resp_american_ideo)] = pdata$mean_am_ideo[is.na(pdata$resp_american_ideo)]

colSums(is.na(pdata))



# check covariates 
covariates_list = c(
  c("resp_gender", "resp_age", "resp_ethnicity_hisp", 
    "resp_polideo", 
    "resp_american", "resp_american_pid", "resp_american_ideo"),
  colnames(race_vars), 
  colnames(major_vars)
)
colSums(is.na(pdata[,covariates_list]))

save(pdata, covariates_list, file = "Manylabs1_data.RData")


