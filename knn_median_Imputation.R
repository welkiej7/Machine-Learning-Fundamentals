#Imputation Methods and glmnet Application Over Titanic Dataset
library(caret)
library(tidyverse)
#Subsitituting missing values with median values, this can be done in caret package
#with setting preProcess argument to "medianImpute" Let's use it over titanic dataset.


titanic_training <- read.csv("/Users/onurtuncaybal/Documents/Studies/Studies Summer 2022/Machine Learning with R /Machine Learning with R/Data/titanic/train.csv")

## Data Manipulation

titanic_training%>%select(c("Survived","Pclass","Sex","Age","SibSp","Parch","Cabin","Embarked")) -> titanic_selected
titanic_selected%>%mutate(Survived = as.factor(Survived)) -> titanic_selected
titanic_selected%>%mutate(Pclass = as.factor(Pclass)) -> titanic_selected
titanic_selected%>%mutate(Sex = as.factor(Sex)) -> titanic_selected
titanic_selected%>%mutate(Age = as.integer(Age)) -> titanic_selected




# Cabin Grouping
cabins <- c("A","B","C","D","E","F","T","G")
titanic_selected$Cabin[grep(pattern = "A", titanic_selected$Cabin)] <- "A"

for(i in cabins){
  titanic_selected$Cabin[grep(pattern = i, titanic_selected$Cabin)] <- i
}

titanic_selected%>%mutate(Cabin = ifelse(Cabin == "","X",Cabin)) -> titanic_selected

titanic_selected$Cabin <- as.factor(titanic_selected$Cabin)

titanic_selected%>%select(!c("Embarked")) -> titanic_selected

## glmnet with median impute preprocessing nonetheless, preprocessing doesn't work with complex formula
## it will work when only you state the x and y



titanic_model_glm_median_impute <- train(x = select(titanic_selected,!c("Survived")),
                           y = titanic_selected$Survived,
                           method = "glm",
                           preProcess = "medianImpute",
                           trControl = trainControl(method = "cv",
                                                    number = 5,
                                                    verboseIter = TRUE))


## kNN imputation.
#Median imputation can be incorret and be biased, thus using kNN imputation much better.


titanic_model_glm_knn_imputation <-  train(x = select(titanic_selected,!c("Survived")),
                                           y = titanic_selected$Survived,
                                           method = "glm",
                                           preProcess = "knnImpute",
                                           trControl = trainControl(method = "repeatedcv",
                                                                    number = 5,
                                                                    repeats = 5,
                                                                    verboseIter = TRUE))



