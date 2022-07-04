#Selecting Models: a Case for Study
library(caret)
library(tidyverse)
bbdata <- load(bloodbrain_path)
churndata <- load(("/Users/onurtuncaybal/Documents/Studies/Studies Summer 2022/Machine Learning with R /Machine Learning with R/Data/Churn.RData"))

## We generally create one trainControl object to compare the results of different machine learning algorithms. First, let's create
## folds for our target variable, churn_y

createFolds(churn_y, k = 5) -> churn_folds


## reusable train object

churn_tco_1 <- trainControl(summaryFunction = twoClassSummary, 
                            classProbs =  TRUE, 
                            verboseIter = TRUE,
                            savePredictions = TRUE,
                            index = churn_folds)

## glmnet approach for the churn data

train(x = churn_x,
      y = churn_y,
      method = "glmnet",
      metric = "ROC",
      trControl = churn_tco_1) -> churn_model_1

## random forests approach for the churn data

train(x = churn_x,
      y = churn_y,
      method = "ranger",
      metric =  "ROC",
      trControl = churn_tco_1) -> churn_model_2

## Comparing Models,

models <- list(glmnet = churn_model_1,
               ranger = churn_model_2)

resamples(models) -> resamps
resamps

# Graphing the Comparison

xyplot(resamps, metric = "ROC")
bwplot(resamps,metric = "ROC")
