<h1 align="center">
<p> awesome-replicability-data
</h1>

This repository collects publicly available datasets for replicability analysis. Currently, we curate a collection of **paired** individual-level datasets of original and replication studies, and **one-sided** pairs with individual-level data for the replication study. 
We are non-selective in collecting these datasets, i.e., both successful and failed studies are included as long as they are available.  

<span style="color:#C0392B;">Please feel free to contact us at ying531 [at] stanford [dot] edu, or open an issue if you have suggestions for replication datasets not collected here!</span>

### Related resources

**Reference.** Please use the following citation if you use this collection in your study, or you use our softwares for analyzing replication studies.

```
Jin, Y.*, Guo, K.*, Rothenhäusler, D. (2023). 
Diagnosing the role of observed distribution shift in scientific replications. Arxiv preprint.
```

**R package.** Our R package [repDiagnosis](https://github.com/ying531/repDiagnosis) provides statistical tools for estimating the contribution of observable distribution shifts in replication studies, such as covariate difference and mediation shifts. Paired data 1, 3, 8 below are cleaned and pre-loaded in the R package for use. 

**Live diagnosis.** Play with our interactive analysis tools in our online R shiny app! Quick start with pre-loaded datasets in the app (datasets 1, 3, 8 below). You can also diagnose your own replication study, or probe the generalizability of your single study.

## Contents 

**1. Complete, paired datasets.** [Data list](#list_paired), [Data details](#detail_paired). 

**2. One sided datasets.** [Data list](#list_oneside), [Data details](#detail_oneside).

## List of complete, paired datasets <a name="list_paired"></a>

Below we list links to papers and datasets for original and replication studies where both of them have individual-level data publicly available. The `Processed` column links to data folder in this repo (if any) which we processed from publicly available data. Clicking the link in `Name` column jumps to texts that summarize the studies. 



| Name | Original paper | Original data/repo| Replication paper | Replication data/repo | Processed |
|:-------------|:----:|:-----------:|:----:|:-----------:|:----:|
| 1. [Covid information](#covidstudy) | [Pennycook, et al., 2020](https://journals.sagepub.com/doi/full/10.1177/0956797620939054) | [OSF link](https://osf.io/7d3xh/) | [Roozenbeek, et al., 2021](https://journals.sagepub.com/doi/10.1177/09567976211024535) | [OSF link](https://osf.io/rkfq5/) | [Folder link](host_data_paired/covid_study/)  |
| 2.  [Empathy and SES](#sesempathy) | [Côté, et al., 2013](https://psycnet.apa.org/record/2012-34989-001)  | no data| [Babcock, et al., 2017](https://www.nature.com/articles/sdata2016129) (two reps) | [OSF link](https://osf.io/wq6nr/) | [Folder link](host_data_paired/empathy_ses/)|
| 3.  [EMDR and misinformation](#emdr) |  [Houben, et al., 2018](https://journals.sagepub.com/doi/full/10.1177/2167702618757658) | [OSF link](https://osf.io/j479p/) | [Calvillo and Emami, 2019](https://link.springer.com/article/10.3758/s13423-019-01641-6) | [OSF link](https://osf.io/egvx4/) | [Folder link](host_data_paired/emdr_misinfo/) |
| 4.  [Self-centrality and mind-body practice](#mindbody)|  [Gebauer, et al., 2018](https://journals.sagepub.com/doi/full/10.1177/0956797618764621) | [yoga](https://madata.bib.uni-mannheim.de/266/1/yoga.csv) [meditation](https://madata.bib.uni-mannheim.de/266/2/meditation.csv) [analysis](https://journals.sagepub.com/doi/suppl/10.1177/0956797618764621/suppl_file/GebauerSupplementalMaterial.pdf) | [Vaughan-Johnston, et al., 2021](https://journals.sagepub.com/doi/full/10.1177/0956797621997366) | [yoga](https://osf.io/v3stn/) [meditation](https://osf.io/g69m4/) | [Folder link](host_data_paired/mindbody_selfcentrality/) |
| 5.  [Queueing design](#queue) |  [Shunko, et al., 2018](https://pubsonline.informs.org/doi/10.1287/mnsc.2016.2610) | [data zipfile](https://pubsonline.informs.org/doi/suppl/10.1287/mnsc.2016.2610/suppl_file/mnsc.2016.2610-sm-data.zip) | [Long, et al.](https://bpb-us-e2.wpmucdn.com/sites.utdallas.edu/dist/2/1186/files/2023/02/ShunkoEtAl2018_PostReplicationReport.pdf) | [data zipfile](https://msreplication.utdallas.edu/files/2022/04/ShunkoEtAl2018_DataAnalysis.zip) | [Folder link](host_data_paired/queue/) |
| 6. [Multi-lab disgust and moral judgement](#multilabmoral) | | | [Ghelfi, et al., 2020](https://journals.sagepub.com/doi/full/10.1177/2515245919881152) | [OSF link (to all studies)](https://osf.io/kuyn8/) | [Folder link](host_multisite_cleanliness/) |
| 7. [Pain and cooperation](#paincoop) |[Bastian, et al., 2014](https://journals.sagepub.com/doi/full/10.1177/0956797614545886) |[OSF link](https://osf.io/9k3sw/) | [Prochazka, et al., 2022](https://journals.sagepub.com/doi/full/10.1177/09567976211040745) | [OSF link](https://osf.io/m8trh/) | [Folder link](host_data_paired/pain_coop/) |
| 8. [Cleaniness and moral judgement](#cleanmoral) |[Schnall, et al., 2008](https://journals.sagepub.com/doi/10.1111/j.1467-9280.2008.02227.x) |[OSF link](https://osf.io/4j8db/) | [Johnson, et al., 2014](https://psycnet.apa.org/fulltext/2014-20922-011.html) | [OSF link](https://osf.io/4mkvz/) | [Folder link](host_data_paired/cleaniness_moral/) |
| 9. [Lie and foreign language](#lielang) |[Suchotzki and Gamer, 2008](https://psycnet.apa.org/record/2018-20537-005) |[OSF link](https://osf.io/d52g3/) | [Frank, et al., 2019](https://www.tandfonline.com/doi/full/10.1080/02699931.2018.1553148) | [OSF link](https://osf.io/x4rfk/) | [Folder link](host_data_paired/lie_language/)|
| 10. [Multi-lab ego depletion](#egodepl) | Rep 1: [Hagger, et al., 2016](https://journals.sagepub.com/doi/full/10.1177/1745691616652873) |[OSF link](https://osf.io/jymhe/) | Rep 2: [Dang, et al., 2020](https://journals.sagepub.com/doi/full/10.1177/1948550619887702) | [OSF link](https://osf.io/3txav/) | |
| 11. [Honesty and time](#honesttime) |  [Shalvi, et al., 2012](https://journals.sagepub.com/doi/10.1177/0956797612443835) | data in replication OSF link |   [Van der Gruyssen, et al., 2020](https://journals.sagepub.com/doi/10.1177/0956797620903716) | [Rep 1](https://osf.io/fnh9u/),      [Rep 2](https://osf.io/xwzpc/) | [Folder link](host_data_paired/time_honest/) |



## List of one-sided datsets <a name="list_oneside"></a>


Below we collect one-sided original-replication study pairs, i.e., where the replication study has individual-level data, while the original study has only summary statistics available. We include such datasets if the original paper contains rich summary statistics. These summary statistics, together with individual-level data of the replication study, are processed and stored in the links in `Processed` column. Clicking the link in `Name` column jumps to texts that summarize the studies. 

| Name | Original paper |  Replication paper | Replication data/repo | Processed |
|:-------------|:----:| :----:|:-----------:|:----:|
| 1. [Climate change misinformation](#climatemisinfo) |[van der Linden, et al., 2015](https://onlinelibrary.wiley.com/doi/10.1002/gch2.201600008) |   [Williams and Bond, 2020](https://www.sciencedirect.com/science/article/pii/S0272494420303030) | [OSF link](https://osf.io/8ymj6/) | [Folder link](host_data_oneside/climate_misinfo/) |
| 2. [Pain-tolerance metaphor](#paintole) |[Sierra, et al., 2016](https://www.ijpsy.com/volumen16/num3/446/the-role-of-common-physical-properties-and-EN.pdf) | [Pendrous, et al., 2020](https://www.sciencedirect.com/science/article/pii/S2212144719301504?via%3Dihub) | [OSF link](https://osf.io/p2hwv/) | [Folder link](host_data_oneside/pain_metaphor/) | 
| 3. [Body dissatifaction](#bodyeval) | [Martijn, et al., 2010](https://psycnet.apa.org/record/2010-18776-008) |     [Glashouwer, et al., 2019](https://www.sciencedirect.com/science/article/pii/S0005796719301214#bib22) | [Database link](https://dataverse.nl/file.xhtml?fileId=14138&version=1.0) | [Folder link](/host_data_oneside/body_satisfaction/) |
| 4. [Priming and exercise](#primeexcer) | [Pottratz, et al., 2021](https://academic.oup.com/abm/article/55/2/112/5850835?login=true) |  [Timme, et al., 2022](https://journals.humankinetics.com/view/journals/jsep/44/4/article-p286.xml) | [OSF link](https://osf.io/qtvyb/) | [Folder link](/host_data_oneside/prime_exercise/) |




## Details of paired studies and datasets <a name="detail_paired"></a>

#### 1. <a name="covidstudy"></a> Covid information study dataset


- *Background*. This study investigates the effect of a `nudge' for thinking about truthfulness of information on the ability of truth discernment when sharing COVID-related news. The treated were asked to rate the accuracy of several headlines, and all participants rated how likely they were to share them on social media. 

- *Sample sizes*. The original study by Pennycook et al. recruited n = 1145 participants, while the replication study by Roozenbeek et al. had sample size N = 1583.

- *Variables*. The outcome variable is the rating for willingness to share the headlines. In addition, both studies measured demographical information including age, gender, education, ethnicity. Other measures include cognitive reflection `crt`, science knowledge `sciknow`, medical maximizer-minimizer scale `mms`, etc.

- *Results*. The original study finds a statistically significant estimate of the interaction of treatment and news truthfulness, i.e., treated participants were less willing to share headlines that were perceived as less accurate. The replication study failed to detect such effect in the first stage with N = 701, but find a significant but smaller effect after collecting the second round of data with pooled N = 1583.


 


#### 2. <a name="sesempathy"></a> Empathy and SES dataset

 
- *Background*.  Babcock et al. conducted two replications of one study from Côté et al., regarding the effect of inducing emphathy on utilitarian moral judgment across socialeconomic status (SES). Treated participants took an emphathy nudge, and then all participants completed an allocation task. 

- *Sample sizes*. The original sample size was n = 91. The first replication study had sample size N1 = 230, and the second had N2 = 300.

- *Variables*. The primal outcome is `Decision_DV`, i.e., how many dollars they would take away from the 'lose' member in the allocation task, as a measure of utilitarian moral judgement. Control variables including age, gender, ethnicity, income, riligiousity, political orientation, etc., were also collected. Intermediate outcomes on how much they felt compassionate, moved, and sympathetic towards the 'lose' member were also collected. We clean the datasets for the two replication studies separately. 

- *Results*. The original study found a significant effect of the interaction of experimental condition and SES. Study 1 in the replication study did not replicate this result, while the second replication study did. 


#### 3. <a name="emdr"></a> EMDR and misinformation dataset
 
- *Background*. This study concerns the effect of eye movement on susceptibility to false memories. These eye movements are a standard component of ``eye movement desensitization and recprocessing", a standard intervention for posttraumatic stress disorder. 

- *Sample sizes*. The original study by Houben et al. had sample size n = 82, while the direct replication by Calvillo et al. had sample size N = 120. 

- *Variables*. The outcome variable are the total number of correct answers and the total number of misinformation after the experiment. In addition, both studies collect gender, age, pre- and post-intervention vividness of memory and emotionality, with one depression level measure differing from BDI to BDI-II. 

- *Results*. The original study found a statistically significant effect of eye movement on increasing false memories, while the replication study did not. 


#### 4. <a name="mindbody"></a> Self-centrality and mind-body practice dataset



- *Background*. This study investigates whether mind-body practices (yoga in experiment 1 and meditation in experiment 2) increase self-enhancement. In experiment 1, waves of local yoga participants were randomly assigned to treatment and control by week. In experiment 2, participants were recruited from an undergraduate psychology subject pool, with two waves completed offline and two online. 

- *Sample sizes*.  The original study has n1 = 93 for experiment 1 and n2 = 162 (potentially repeated measure over a few weaks). The replication study has N1 = 97 and N2 = 300 for the two experiments.

- *Variables*.  There are a few outcome variables, including self-centrality, self-enhancement, self-esteem, etc. In our folder, we cleaned the datasets with easier-to-understand column names, and also provide the data cleaning scripts (adapted from the data sources) for reproducibility.

- *Results*. Experiment 1 showed no significant effect of yoga for enhancing self-centrality, but did (largely) replicated the effect on self-enhancement, self-esteem and commnunal narcissism. The discrepancy was explained by sampling differences in Vaughan-Johnston  et al. 
Experiment 2 showed no significant effect of medication on self-centrality; frequentisy and Bayesian analyses were contrary regarding self-enhancement; however, they found much stronger evidence for well-being effects than the original study. 

#### 5. <a name="queue"></a> Queueing design and service time dataset


- *Background*.  This study investigates the impact of queue design on worker productivity in service systems that involve human servers by varying between multiple parallel queues versus single pooled queue. 

- *Sample sizes*.  The original study recruited n1 = 248 participants from a public university in US and n2 = 481 participants on M-Turk. The replication study recruited N1 = 246 and N2 = 252 participants for two rounds.

- *Variables*.  The outcome variable is median speed. The treatment variable is structure of the queue. Other baseline variables were also measured, including age, gender, device used in the experiment, and managerial experience of the participant. 

- *Results*. The original study found the singe-queue structure slows down servers, while the replication study failed to find such effect.

#### 6. <a name="multilabmoral"></a> Multi-lab disgust and moral judgement dataset

- *Background*.  This is a multi-lab replication of an original study from Eskine et al. (2011); unit-level data for the original study is not publicly available to our knowledge. They studied the effect of gustatory disgust on moral judgement, where participants were randomly assigned to bitter, neutral (control), or sweet beverages, and then judged the moral wrongness of six vignettes. We follow the ordering on OSF to clean the datasets and preserve common demographic, manipulation check, and outcome variables.

- *Sample sizes*.  The original study had sample size n = 57, while the replication studies had N = 1137 participants in total across k = 11 studies. 

- *Variables*. The outcome variable is the average moral rating of the six vignettes. The treatment variable is `condition`, coded as `dummysweet`, `dummybitter` and `dummywater` in the cleaned datasets. Baseline covariates including religiosity, gender, age, years in colledge, major, ethnicity, potilical orientation, etc. We preserve gender, age, and political orientation for consistency in cleaned data. To evaluate the intended effect of the  beverages on subjective ratings (bitter, disgusting, neutral, and sweet) is also assessed, named as `check_...` in the cleaned data. 

- *Results*. The original study showed that gustatory disgust triggers a significantly heightened sense of moral wrongness. In the multi-lab replication study the overall estimates of effect sizes were all smaller than the original study; some were in the opposite direction; all had 0.95 confidence intervals containing zero.


#### 7. <a name="paincoop"></a>Pain and cooperation dataset

- *Background*.  Experiment 2 of Bastian et al. (2014) studied the effect of sharing painful experience on intergroup cooperation. Small groups (2-6 people each) of participants performed either two painful or two painless tasks and then played an economic game. Prochazka et al. (2022) conducts a pilot nonpreregistered direct replication  and a second preregistered direct replication, with group sizes fixed at three. 

- *Sample sizes*.  The original study had sample size n = 62. The pilot replication had N = 153 from Czech Republic, and the second preregistered replication had N2 = 158 students from Slovakia.

- *Variables*. The outcome variable is `cooperation`, the average score from the six games. The treatment variable is `condition`. We cleaned the datasets by preserving overlapping variables, while the original data additionally contains group size information. Baseline covariates include age and gender. After the experiments, intermediate outcomes such as the level of pain and unpleasantness of sensations were measured as a manipulation check.  

- *Results*. The original study found that shared pain increases cooperation among group members. Both replication studies failed to replicate this finding.


#### 8. <a name="cleanmoral"></a> Cleaniness and moral judgement dataset

- *Background*.  This study investigates the impact of physical cleaness on the severity of moral judgement. Participants are randomly assigned to be primed with the concept of cleanliness (Exp.1) and wash hands after experiencing disgust (Exp.2), and then rate six moral vignettes.

- *Sample sizes*.  The original study had n1 = 40 for Exp.1 and n2 = 44 for Exp.2. The replication study had N1 = 219 for Exp.1 and N2 = 132 for Exp.2.

- *Variables*. We cleaned the datasets and preserved common covariates in both studies. The outcome variable is `vignette`, the mean rating in all vignettes. The treatment variable is `condition` with treatment equal 1. Other variables include the emotionality collected after the experiments.

- *Results*. The original study finds statistically significant effects in both experiments, while Johnson et al. failed to replicate either of them.


#### 9. <a name="lielang"></a> Lie and language dataset

- *Background*.  This study investigates the impact of foreign versus native language on lying. In the original study, German-speaking participants took a lie test where questions were presented randomly in German or English, and they answered with truth or lying in different languages. In the replication study, participants were Dutch-speaking. 

- *Sample sizes*.  The original study had n = 41 participants, and the replication study had N = 63.

- *Variables*.  The measured outcome is the response time for truth-or-lie-telling answers in both languages. In our cleaned data, each row contains the mean response time of a participant (indicated by `ID`) for questions of different `Emotionality`, `Veracity` (Lie or Truth) and `Language`, as well as the participant's evaluation of emotionality for each category of (`Emotionality` times `Language`). Due to limited access, only the replication data contains demographic features including age, gender, major, language proficiency as introduced in Frank, et al., 2019. 
 

- *Results*. The original study showed smaller *reaction time differences* between lying and truth telling in the foreign compared to thenative language condition, which was mostly driven by prolonged truth responses. The replication study found statistically significant conclusion in the same direction, yet with a smaller effect size. 


#### 10. <a name="egodepl"></a> Multi-lab ego depletion dataset



There are two multi-lab replications. Hagger, et al., [2016] failed, but Dang, et al., [2020] succeeded. Dang, et al., [2020] also pointed out inconsistent implementation of the intervention may be a potential reason for the replication failure in Hagger, et al., [2016]. Both OSF links contain datasets for each lab, which includes individual-level characteristics. 
 
 
#### 11. <a name="honesttime"></a> Honesty and time dataset

- *Background*.  This study investigates the impact of time pressure on cheating. In the original study, participants privately roll out a dice and get payment according to their reported amount on the dice (which does not have to be true). The reported amount is used as the outcome. 

- *Sample sizes*.  The original study had n = 72. The replication study consisted of two experiments; the first one had larger sessions with N1 = 426, another one had the same session size as the original study with N2 = 297.

- *Variables*.  The outcome of interest is the reported dice number. The treatment variable (=1) indicates whether there is time pressure (i.e., having to report the dice number in a short time). Data for the original study only contains gender as demographic information. Data for the replication study contains age, gender, education, etc., as demographics, as well as ratings for their belief in the financial incentive and anonymousness of their die roll. The original study and the replication study 1 collected the participants' positive and negative feelings after the experiment; we preserve all such columns and put the common ones before others. 

- *Results*. The original study found that time pressure increases cheating, while neither of the replication studies replicated this conclusion. 

 

## Details of one-sided studies and datasets <a name="detail_oneside"></a>

#### 1. <a name="climatemisinfo"></a> climate change misinformation dataset

- *Background*.  This study investigates the impact of information communication on protecting against misinformation about climate change.  

- *Sample sizes*.  The original study had n = 2167. The replication study had N = 792.

- *Variables*.  The outcome of interest is the perceved concensus, and there are multiple treatment conditions. We clean the replication dataset (with unit-level data), and the sample mean of demographic information in the original dataset, with processing script included for reproducibility. 

- *Results*. The original study had multiple hypotheses; the replication study replicated a susbet of them. 

#### 2. <a name="paintole"></a> Pain-tolerance metaphor dataset

- *Background*.   This study investigates the impact of common physical properties (such as 'cond') within a perseverance metaphor on increasing pain tolerance. Participants completed a cold pressor task before and after a randomly allocated intervention of metatphor exercise.

- *Sample sizes*.  The original study had n = 87. The replication study had N = 89.

- *Variables*.  The outcome of interest is the difference in pain tolerance. We save the replication dataset (with unit-level data), and the sample mean of demographic information in the original dataset. 

- *Results*. The original study found that physical metaphor increases pain tolerance, while the replication study did not replicate this result. 
 


#### 3. <a name="bodyeval"></a> Body dissatifaction dataset

- *Background*.   This study investigates the impact of a computer-based evaluative conditioning (EC) procedure using positive social feedback on enhancing body satisfaction.

- *Sample sizes*.  The original study had n = 54. The replication study had N = 129.

- *Variables*.  The outcome of interest is the difference in body satisfaction and self-esteem before and after the intervention. We save the replication dataset (unit-level), and the sample mean of demographic information in the original dataset. 

- *Results*. The conclusion in the original study was not successfully replicated. 




#### 4. <a name="primeexcer"></a>Priming and exercise dataset

- *Background*.   This study investigates the impact of affective priming as a behavioral intervention on the enhancement of exercise-related affect.

- *Sample sizes*.  The original study had n = 54. The replication study had N = 53.

- *Variables*.  The outcome of interest is the difference in body satisfaction and self-esteem before and after the intervention. We save the replication dataset (unit-level), and the sample mean of demographic information in the original dataset. 

- *Results*. The conclusion in the original study was not successfully replicated. The replication report emphasized potential heterogeneity among people as a potential factor for the failure.