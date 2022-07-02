#Random Forests

#The aim of this chapter to discover the random forests and wine data
#with "caret" package. 
require(caret)
require(gmodels)
require(tidyverse)
library(mlbench)
set.seed(42)
#First, let start with importing the wine dataset.

readRDS("~/Documents/Studies/Studies Summer 2022/Machine Learning with R /Machine Learning with R/Data/wine_100.RDS") -> wine_data

# a quick gaze
str(wine_data)
head(wine_data,10)

# Let's train our first model,

model_wine <- train(quality~.,wine_data,method = "ranger",tuneLength = 1 ,trControl = 
                      trainControl(method = "repeatedcv",number = 10, 
                                   repeats = 5, 
                                   verboseIter = TRUE))
model_wine

# We can elaborate from this point.

#Unlike linear regression, in random forests we have hyper-parameters which are obligatory to select 
#by hand. mtry is one of the most important parameters. mtry is the number of randomly selected variables
#used at each split point in the individual decision trees that make up the random forest. This number is completely random
#you can use 2 variables or 100 variables. Nonetheless, forests with lower mtry value will be MORE random and as the number 
#increases the randomness will be less. mtry is the tuneLength argument in the caret::train() function. for example,

model_wine <- train(quality~.,wine_data,method = "ranger",tuneLength = 1,#this model is mtry = 1
                    trControl = 
                      trainControl(method = "repeatedcv",number = 10, 
                                   repeats = 5, 
                                   verboseIter = TRUE))
plot(model_wine)
#let's try a different value of mtry for non repeating cross validation of the same model,

model_wine2 <- train(quality~.,wine_data,method = "ranger",tuneLength = 5,trControl =
                       trainControl(method = "cv", number = 10, verboseIter = TRUE))

model_wine3 <- train(quality~.,wine_data,method = "ranger",tuneLength = 80, trContol = trainControl(method = "cv",
                                                                                                    number = 5,
                                                                                                    verboseIter = TRUE))


plot(model_wine2) # <- We can see the lowest RMSE value with cross validation is at 7. Our model performs at best in 7. 
plot(model_wine3)

#We can apply this approach for sonar data too,

model_sonar_ranger <- train(Class~.,sonar_train,method = "ranger",tuneLength = 61, 
                            trControl = trainControl(method = "cv", number = 2, verboseIter = TRUE))

## We see a number of unique complexity parameters, which are fancy names for columns. The caret package warns us that our tunelength is
## longer than the possible combinations, there exist 60 columns, therefore we have 60-1 = 59 unique parameters(one is outcome or response)

plot(model_sonar_ranger)

## Custom Tuning Grid



tuneGrid <- data.frame(.mtry = c(2,3,7),
                       .splitrule = "variance",
                       .min.node.size = 5)

# Subsitute inside the train function.

model_wine4 <- train(quality~.,wine_data,method = "ranger",tuneGrid = tuneGrid, trControl = 
                       trainControl(method = "cv", number = 5, verboseIter = TRUE))
model_wine4
plot(model_wine4)

#In here we can see that our custom tuning grid is applied for the tuning length.  You can find different tuning parameters for different models
#at the link https://topepo.github.io/caret/available-models.html. 

