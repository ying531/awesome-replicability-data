rm(list = ls())
library(haven)
library(tidyverse)
library(stringr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

raw = read_sav("ReplicationMaterial/4_Data/Data/CleanedDataset.sav") %>%
  mutate_if(is.character, ~ifelse(trimws(.x) %in% c('', '.', '-'), NA, .x))

xx <- read.delim('ReplicationMaterial/4_Data/DetaieldCodebook_Characteristics.txt', header = F)
xx$item <- str_extract(xx$V1, 'width.*?td')
# dfull <- read_sav('ReplicationMaterial/4_Data/Data/Full_Dataset_De-Identified.sav')
# eff <- read_sav('ReplicationMaterial/5_AnalysisScripts/effectsizes.graphdata1.sav')
# sunk  <- read_sav('Output/sunkd.sav')
# sunkg <- read_sav('Output/sunkGrandd.sav')
# eff   <- read_sav('Output/effectsizes.all.sav')
# all <- read_sav('Output/allowedforbiddend.sav')

# --------------------------------- Extracting individual covariates
# gender
raw$resp_sex <- ifelse(raw$sex == 'f', 'female', ifelse(raw$sex == 'm', 'male', NA))
table(raw$resp_sex, raw$sex)

# age
raw$resp_age <- as.numeric(raw$age)
table(raw$resp_age, useNA = 'always')

# race/ethnicity
racev <- c('American Indian/Alaskan Native', 'East Asian', 'South Asian', 'Native Hawaiian or other Pacific Islander', 'Black or African American', 'White', 
           'More than one race - Black/White', 'More than one race - Other', 'Other or Unknown')
raw$resp_race <- tolower(trimws(raw$race))
for (i in 1:9) raw$resp_race[raw$race == as.character(i)] <- tolower(racev[i])

raw$resp_ethnicity <- tolower(ifelse(raw$ethnicity=='1', 'Hispanic or Latino', ifelse(raw$ethnicity=='2', 'Not Hispanic or Latino', NA)))

table(raw$resp_race, useNA = 'always')
table(raw$mturk.non.US)
table(raw$ethnicity, raw$resp_ethnicity, useNA = 'always')

# citizenship
table(raw$citizenship, raw$citizenship2)
raw$resp_citizenship <- coalesce(raw$citizenship, raw$citizenship2)
table(raw$resp_citizenship, useNA = 'always')
x <- xx %>% 
  fill(item, .direction = 'down') %>%
  filter(grepl('Citizenship', item) & grepl('option', V1)) 
x$code <- str_match(x$V1, '(option value=)([A-Z]{2})')[,3]
x$country <- str_match(x$V1, '(>)(.*)(</option>)')[,3]
x <- x %>% drop_na(code) %>% distinct(code, country)
raw <- left_join(raw, x, by = c('citizenship' = 'code'))
raw$resp_citizenship <- coalesce(raw$country, raw$resp_citizenship)
sort(table(raw$resp_citizenship, useNA = 'always'))

# Bachelor major (if student)
table(raw$major, useNA = 'always')
x <- xx %>% 
  fill(item, .direction = 'down') %>%
  filter(grepl('Major', item) & grepl('option', V1)) 
x$code <- as.numeric(str_match(x$V1, '(option value=)([0-9]+)')[,3])
x$resp_major <- str_match(x$V1, '(>)(.*)(</option>)')[,3]
raw <- left_join(raw, distinct(x, code, resp_major) %>% drop_na(code), by = c('major' = 'code'))
table(raw$resp_major, raw$major, useNA = 'always')

# Political ID
table(raw$politicalid, useNA = 'always')
x <- xx %>% 
  fill(item, .direction = 'down') %>%
  filter(grepl('Political', item) & grepl('option', V1)) 
x$code <- as.numeric(str_match(x$V1, '(option value=)(.*[0-3])')[,3])
x$resp_pid <- str_match(x$V1, '(>)(.*)(</option>)')[,3]
raw <- left_join(raw, distinct(x, code, resp_pid) %>% drop_na(code), by = c('politicalid' = 'code'))
table(raw$resp_pid, raw$politicalid, useNA = 'always')

# Native Language
table(raw$nativelang, raw$nativelang2, useNA = 'always')
table(raw$nativelang,  useNA = 'always')
table(raw$nativelang2,  useNA = 'always')
raw$resp_nativelang <- tolower(trimws(raw$nativelang))
raw$resp_nativelang_other <- ifelse(tolower(trimws(raw$nativelang2)) %in% c('not in college', 'n/a', 'na', 'fashion merchandising', 'asian', 'other',
                                                                            'communication disorders', 'marketing'), NA, tolower(trimws(raw$nativelang2)))
raw$resp_nativelang_other <- ifelse(grepl('chinese|madarin|mandrain|mandarin', raw$resp_nativelang_other), 'chinese', 
                                    ifelse(grepl('(turks|turkish)$', raw$resp_nativelang_other), 'turkish',
                                           ifelse(grepl('spanish', raw$resp_nativelang_other), 'spanish',
                                                  ifelse(grepl('filipino', raw$resp_nativelang_other), 'filipino',
                                                         ifelse(grepl('english', raw$resp_nativelang_other), 'english', 
                                                                ifelse(grepl('creol', raw$resp_nativelang_other), 'creole',
                                                                       ifelse(grepl('hindi', raw$resp_nativelang_other), 'hindi', raw$resp_nativelang_other)))))))
raw$resp_nativelang <- ifelse(raw$resp_nativelang == 'other', raw$resp_nativelang_other, raw$resp_nativelang)
sort(table(raw$resp_nativelang,  useNA = 'always'))

# Religion
raw$resp_religion <- raw$religion

# American political view
# How much do you identify with being American?
# 1 = not at all; 11 = very much
table(raw$resp_american, useNA = 'always')
raw$resp_american <- as.numeric(raw$flagsupplement1)

# To what extent do you think the typical American is a Republican or Democrat?
# 1 - Democrat; 7 = Republican
raw$resp_american_pid <- as.numeric(raw$flagsupplement2)

# To what extent do you think the typical American is conservative or liberal?
# 1 - Liberal; 7 = Conservative
raw$resp_american_ideo <- as.numeric(raw$flagsupplement3)

# --------------------------------- Experimenter Covariate
table(raw$exp_race, useNA = 'always')
raw$exp_sex <- ifelse(raw$expgender %in% c('female', 'male'), raw$expgender, NA)
raw$exp_race <- raw$exprace
for (i in 1:9) raw$exp_race[raw$exprace == as.character(i)] <- tolower(racev[i])
raw$exp_race[raw$exprace == as.character(10)] <- tolower('Hispanic or Latino')

# --------------------------------- Study Environment Covariate
# How many participants are taking this study during this timeslot? (that is, at the same time)
table(actual=raw$numparticipants_actual, est=raw$numparticipants, useNA = 'always')
table(raw$numparticipants_actual, useNA = 'always')
table(raw$numparticipants, useNA = 'always')
raw$study_numparticipants <- raw$numparticipants

# Exposure
# Is this the first study this participant will see during this session, or is this study being run after another study?
#<option value="runafter">This study is being run after a different study</option>
#<option value="runalone">This study is being run alone or before another experiment</option>
table(raw$exprunafter2, raw$exprunafter)
raw$study_exprunafter <- raw$exprunafter

# Location
# Were participants physically separated? (either by barriers or in separate rooms)
# <option value="separaterooms">Yes, separate rooms, one participant per room</option>
#   <option value="barriers">Yes, multiple participants per room but separated by barriers</option>
#   <option value="nobarriers">No, participants were not separated (multiple per room, no barriers)</option>
#   <option value="other">Other (please explain in comment box)</option>
raw$study_separated <- raw$separatedornot

# Recruitment
# 6. How were participants recruited?
# <option value="unisubjpool">University Subject Pool</option>
#   <option value="othersubjpool">Other Subject Pool</option>
#   <option value="class">Completed in Class</option>
#   <option value="advertisements">Fliers/advertisements/website announcements</option>
#   <option value="publicareas">Actively recruited from public areas</option>
#   <option value="other">Other (please explain in comment)</option>
raw$study_recruit <- raw$recruitment

# Compensation
# How were participants compensated?
# <option value="coursecredit">Course credit</option>
#   <option value="paid">Paid money or entered into lottery</option>
#   <option value="volunteer">No compensation - volunteers</option>
#   <option value="multiple">Multiple forms of compensation</option>
#   <option value="other">Other (please explain in comment)</option>
raw$study_compensation <- raw$compensation

raw$study_online <- raw$lab_or_online

# Filter
# 'Filter by this variable to exclude ss form the analysis of the IAT study (see manuscript for exclusion criteria)'.
raw$filter_iat <- raw$IATfilter
# filter no-response for gender for IAT
raw$filter_iat <- ifelse(is.na(raw$resp_sex), 0, raw$IATfilter)

# 'filter by this var to exclude participants who did not respond to a particular item for both math and arts explicit items'. 
# raw$study_IATEXPfilter <- raw$IATEXPfilter
# 'filter by this variable to exclude ss from flag priming analyses (criteria: missed 1 time estimation response; subject is intl)'.
# raw$filter_flag <- raw$flagfilter
# raw$filter_flag <- as.numeric(raw$totalflagestimations > 1 | raw$totalnoflagtimeestimations > 1)
#  'filter by this var to include in the currency priming analysis only ss who took this study first'.
# raw$filter_money <- raw$moneyfilter

# Country
zz <- readxl::read_excel('ReplicationMaterial/3_SiteCharacteristics/Table_S1_-_Detailed_Site_and_Sample_Characteristics.xlsx') %>%
  transmute(referrer = trimws(tolower(`Site identifier`)), 
            study_usa = as.numeric(`US or Int'l` == 'US'), 
         study_link = `Study Link`,  study_location = trimws(`Location`)) %>%
  distinct()
zz$study_country <- str_match(zz$study_location, '(Czech Republic|Turkey|Canada|UK|Netherlands|Poland|Brazil|Italy|Malaysia)')[,1] 
zz$study_country <- ifelse(zz$referrer=='swpson', 'Poland', zz$study_country)
zz$study_country <- ifelse(is.na(zz$study_country), 'USA', zz$study_country)

df <- raw %>%
  left_join(zz) %>%
  rename_all(tolower)

table(re=df$referrer,st=df$us_or_international)



# --------------------------------- Study Treatment and DV
var <- list('allowedforbidden'="Allowed/Forbidden (Rugg, 1941)" ,
          'anchoring1'= "Anchoring (Jacowitz & Kahneman, 1995) - NYC", 
          'anchoring2'=	"Anchoring (Jacowitz & Kahneman, 1995) - Chicago",
          'anchoring3'=	"Anchoring (Jacowitz & Kahneman, 1995) - Everest",
          'anchoring4'=	"Anchoring (Jacowitz & Kahneman, 1995) - Babies",
          'contact'   =	"Imagined contact (Husnu & Crisp, 2010)",
          'flag' =	"Flag Priming (Carter et al., 2011)",
          'gainloss' =	"Gain vs loss framing (Tversky & Kahneman, 1981)",
          'gambfal'  =	"Retro. gambler’s fallacy (Oppenheimer & Monin, 2009)",
          'iat' = "Sex diff. in implicit math attitudes (Nosek et al., 2002)",
          # 'IATr'=	"Corr. between I and E math attitudes (Nosek et al., 2002) ",
          'money' =	"Currency priming (Caruso et al., 2012)",
          'quote' =	"Quote Attribution (Lorge & Curtis, 1936)",
          'reciprocity' =	"Norm of reciprocity (Hyman and Sheatsley, 1950)",
          'scales' =	"Low-vs.-high category scales (Schwarz et al., 1985)",
          'sunk' = "Sunk costs (Oppenheimer et al., 2009)")

iv <- c('allowedforbiddengroup', 
        'anch1group', 'anch2group', 'anch3group', 'anch4group', 
        'contactgroup',
        'flaggroup',
        'gainlossgroup',
        'gambfalgroup',
        'partgender',
        'moneygroup',
        'quotegroup',
        'reciprocitygroup',
        'scalesgroup',
        'sunkgroup')

dv <- c('allowedforbidden',
        'ranch1', 'ranch2', 'ranch3', 'ranch4',
        'imagineddv',
        'flagdv',
        'gainlossdv',
        'gambfaldv',
        'd_art',
        'sysjust',
        'quote',
        'reciprocityus',
        'scales',
        'sunkdv')

labels_to_values <- function(x, ...){
  if (!is.null(attr(x, "labels"))){
    x <- factor(x, levels = attr(x, "labels"), labels = names(attr(x, "labels")))
  }else{
    x <- NA
  }
  return(x)
}

for (i in 1:length(iv)){
  v <- names(var)
  df[[paste0('iv_', v[i])]] <- df[[iv[i]]]
  df[[paste0('iv_label_', v[i])]] <- as.character(labels_to_values(df[[iv[i]]]))
} 

for (i in 1:length(dv)){
  v <- names(var)
  df[[paste0('dv_', v[i])]] <- df[[dv[i]]]
  df[[paste0('dv_desc_', v[i])]] <- as.character(attr(df[[dv[i]]], "label"))
  df[[paste0('dv_label_', v[i])]] <- as.character(labels_to_values(df[[dv[i]]]))
} 
df$dv_desc_sunk <- 'likelihood of attending the game on a 9-point scale (1 = definitely stay at home, 9 = definitely go to the game)'
df$dv_desc_gainloss <- 'course of action to combat the disease from logically identical sets of alternatives framed in terms of gains'
df$iv_iat <- df$iv_iat - 2

# DV is flipped for IV=0 for allowedforbidden
addmargins(table(iv=raw$allowedforbiddenGroup,dv=raw$allowedforbidden))
df$dv_allowedforbidden <- ifelse(df$iv_allowedforbidden==0, abs(df$dv_allowedforbidden-1), df$dv_allowedforbidden)
addmargins(table(iv=df$iv_allowedforbidden,dv=df$dv_allowedforbidden))

# reverse treatment variable for select studies 
for (i in c('sunk', 'gainloss', 'iat', 'reciprocity', 'allowedforbidden')){ #allowedforbidden
  df[[paste0('iv_', i)]] <- abs(df[[paste0('iv_', i)]] - 1)
}
  
dfinal <- df %>%
  select(session_id, 
         session_date,
         referrer,
         matches('^(iv_|dv_|resp_|exp_|study_|filter)')) %>%
  select(-c(study_url, study_name, resp_nativelang_other)) %>%
  rename(site = referrer,
         site_name = study_location)

tokeep <- names(dfinal %>% select(1:3, matches('(resp_|exp_|study_|^site)')))
dfinal1 <- plyr::ldply(names(var), function(x){
  temp <- dfinal %>%
    select(all_of(tokeep), matches(x)) %>%
    mutate(original_study = x) %>%
    rename_all(~gsub(paste0('_',x), '', .x))
})
names(dfinal1)

d <- dfinal1 %>%
  left_join(data.frame(original_study_name = unlist(var)) %>%
              rownames_to_column('original_study')) %>%
  mutate_at(vars(matches('iv_label|dv_label')), tolower) %>%
  mutate(session_date = as.Date(session_date),
         iv = as.numeric(iv), 
         dv = as.numeric(dv),
         filter = ifelse(is.na(filter), 1, filter),
         study_online = as.numeric(study_online)) %>%
  rename(id = session_id, 
         date = session_date) %>%
  select(id, date, site, site, site_name, study_country, study_usa, matches('study'), matches('original'), matches('resp_'), 
         matches('exp_'), matches('iv'), matches('dv'),  everything())
for (i in names(d)) attr(d[[i]], 'label') <- NULL    

for (i in names(d)){
  if ('haven_labelled' %in% class(d[[i]])) print(i)
}
  
write_rds(d, 'ML1_data.rds')



# ------------------------------ Data Dictionary
# x <- distinct(d, original_study, original_study_name, dv_desc)
# xx <- distinct(d, id, site, site_name) %>% group_by(site, site_name) %>% summarize(n = n())
# # write.csv(x, 'x.csv')
# # write.csv(xx, 'xx.csv')
# 
# dict <- NULL
# for (i in names(d)){
#   print(i)
#   d$date <- as.numeric(d$date)
#   exv <- unique(na.omit(d[[i]]))
#   if (class(d[[i]]) != 'character'){
#     cov <- data.frame(var = i, 
#                       type = class(d[[i]]),
#                       n = sum(!is.na(d[[i]])),
#                       miss = sum(is.na(d[[i]])),
#                       mean = mean(d[[i]], na.rm = T), 
#                       sd   = sd(d[[i]], na.rm = T),
#                       min = as.numeric(summary(d[[i]]))[1], 
#                       q1 = as.numeric(summary(d[[i]]))[2], 
#                       median = as.numeric(summary(d[[i]]))[3], 
#                       q3 = as.numeric(summary(d[[i]]))[5], 
#                       max = as.numeric(summary(d[[i]]))[6],
#                       ex = paste(exv[1:min(3, length(exv))], collapse = ', '))
#   }else{
#     cov <- data.frame(var = i, 
#                       type = class(d[[i]]),
#                       n = sum(!is.na(d[[i]])),
#                       miss = sum(is.na(d[[i]])),
#                       n_unique_val = length(unique(na.omit(d[[i]]))),
#                       ex = paste(exv[1:min(3, length(exv))], collapse = ', '))
#   }
#   dict <- bind_rows(dict, cov)
#   rm(cov)
# }
# 
# write.csv(dict, 'dict.csv')
# 
# 
# 
# 
