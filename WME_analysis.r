# version check
R.version

# load packages
library(dplyr)
library(Rmisc)
library(car)
library(effects)
library(dunn.test)
library(lmerTest)
library(ggplot2) # required for loading waffle
library(waffle)


# import cleaned data
# data were cleaned and scored in Python
uas_full <- read.csv('uas_cleaned_full.csv') # this DataFrame contains all participants regardless of how many waves they participated in
uas_more <- read.csv('uas_morethan1wave.csv') # this DataFrame contains participants who responded to more than 1 wave
uas_only <- read.csv('uas_only1wave.csv') # this DataFrame contains participants who only responded to one wave

# preview data
head(uas_full)

# waffle plot for sample N by group
sample_group <- c('White men (N = 2692): 32.45%' = 2692*100/8296, 
                  'White women (N = 3688): 44.46%' = 3688*100/8296, 
                  'non-White women (N = 1224): 14.75%' = 1224*100/8296, 
                  'non-White men (N = 692): 8.34%' = 692*100/8296)
waffle(sample_group, 
       title = 'Sample size by group (%)',
       xlab = '1 sq = 1 person in 100 people',
       rows = 6)

# boxplot by group
boxplot(prisk_die ~ group, 
        xlab = 'Group',
        ylab = 'Perceived COVID-19 Mortality Risk',
        outline = FALSE, # omit showing outliers
        names = c('non-White men','non-White women','White men','White women'),
        notch = TRUE,
        col = 'aquamarine',
        boxwex = 0.75, # scale boxes
        data = uas_full)

# check assumption of normality
# DV is not normal, but sample N = 8127, so parametric tests should still be robust
qqnorm(uas_full$prisk_die)
qqline(uas_full$prisk_die)

# one-way repeated measures ANCOVA with random effects 
# main predictor (group) has 4 levels
aov_group <- aov(prisk_die ~ group + hhincome + age + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_full)
summary(aov_group)

# Tukey's post hoc
tukey_group <- aov(prisk_die ~ group, uas_full)
TukeyHSD(tukey_group)

# simple effect analysis
summary(effect('group', aov_group, se = TRUE))

# Kruskal Wallis to confirm results
kruskal.test(prisk_die ~ group, uas_full)

# dunn's test
# use altp argument to report true p-values
dunn.test(uas_full$prisk_die, uas_full$group, altp = TRUE)

# two-way anova
# race x gender
lmm_twoway <- lmer(prisk_die ~ race2*gender + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_full)
anova(lmm_twoway)

# two-way anova
# wave x group2
lmm_twoway_wave <- lmer(prisk_die ~ wave*group2 + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|uasid), uas_full)
anova(lmm_twoway_wave)

# linear mixed model, full
# nested effect variable, uasid (repeatedly sampled)
# partially crossed effect variable, wave (sampled across waves)
lmm_group2 <- lmer(prisk_die ~ group2 + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_full)
summary(lmm_group2)

# calculate % of variance explained by uasid
# this is the leftover variance after variance explained by fixed effects
# 79.20%
100*286.145/(286.145+4.414+70.737)

# calculate % of variance explained by wave
# this is the leftover variance after variance explained by fixed effects
# 1.22%
100*4.414/(286.145+4.414+70.737)

lmm_interaction <- lmer(prisk_die ~ race2*gender + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_full)
summary(lmm_interaction)

# calculate % of variance explained by uasid
# this is the leftover variance after variance explained by fixed effects
# 79.13%
100*285.056/(285.056+4.416+70.743)

# calculate % of variance explained by wave
# this is the leftover variance after variance explained by fixed effects
# 1.23%
100*4.416/(285.056+4.416+70.743)

lmm_additive <- lmer(prisk_die ~ race2 + gender + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_full)
summary(lmm_additive)

# calculate % of variance explained by uasid
# this is the leftover variance after variance explained by fixed effects
# 79.13%
100*285.016/(285.016+4.418+70.743)

# calculate % of variance explained by wave
# this is the leftover variance after variance explained by fixed effects
# 1.23%
100*4.418/(285.016+4.418+70.743)

# one-way repeated measures ANCOVA
# excludes participants who only responded to one wave
aov_group_more <- aov(prisk_die ~ group + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_more)
summary(aov_group_more)

# one-way repeated measures ANCOVA
# excludes participants who only responded to one wave
# Tukey's post hoc
tukey_group_more <- aov(prisk_die ~ group, uas_more)
TukeyHSD(tukey_group_more)

# simple effect analysis
# excludes participants who only responded to one wave
summary(effect('group', aov_group_more, se = TRUE))

# linear mixed model
# excludes participants who only responded to one wave
lmm_group2_more <- lmer(prisk_die ~ group2 + age + hhincome + education + cr022a + cr022b + jobs_dayswfh + hhmembernumber + (1|wave) + (1|uasid), uas_more)
summary(lmm_group2_more)

# calculate % of variance explained by uasid
# excludes participants who only responded to one wave
# this is the leftover variance after variance explained by fixed effects
# 79.196
100*286.070/(286.070+4.411+70.737)

# calculate % of variance explained by wave
# excludes participants who only responded to one wave
# this is the leftover variance after variance explained by fixed effects
# 1.221
100*4.411/(286.070+4.411+70.737)
