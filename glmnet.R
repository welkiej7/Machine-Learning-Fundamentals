## GLM Net with Caret

library(caret)
library(tidyverse)
require(gmodels)
require(caTools)
set.seed(15)

## Structure
# extension of the glm function in r, they have built-in variable selection,
#it helps linear regression to deal with collinearity and small sample sizes

#Ridge and Lasso Regression can be used for this penalization. They pair well
#with random forest models. glmnet models can fit a combined lasso and ridge regression
#too. alpha = 0 pure ridge, =1 lasso regression. lambda is the size of the penalty. 

#Lets use sonar dataset for this.
load(file.choose()) -> sonar

sonar_glm<- train(Class~.,sonar_train, method = "glmnet", trControl = trainControl(method = "repeatedcv",
                                                                          number = 5,
                                                                          repeats = 5,
                                                                          verboseIter = TRUE))

predict(sonar_glm,sonar_test) -> sonar_test$pred

confusionMatrix(sonar_test$pred, sonar_test$Class)

## glmnet with custom tuning grid.

sonar_glm2 <- train(Class~., sonar_train, 
                    method = "glmnet",tuneGrid = expand.grid(alpha = 0:1,
                                                             lambda = seq(0.0001,0.1,length = 10)),
                    trControl = trainControl(method = "cv",
                                                               number = 5))



