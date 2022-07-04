## kNN Algorithm for Unsupervised Learning
library(class)
library(gmodels)

data("iris")
plot(iris$Sepal.Length,iris$Petal.Length,col = iris$Species, xlab = "Sepal Length",ylab = "Petal Length")

iris_scaled <- as.data.frame(scale(iris[,-5]))

training_iris <- iris_scaled[1:round(nrow(iris_scaled)*3/4),]

test_iris <- as.data.frame(iris_scaled[round(nrow(training_iris):nrow(iris_scaled)),])


test_iris$knn <-knn(training_iris,test_iris,class_iris_train,k = 3)
test_iris$labels <- iris$Species[112:150]

CrossTable(test_iris$knn,test_iris$labels, prop.chisq = FALSE)
require(caTools)
sample = sample.split(iris, SplitRatio = 2/3)
iris_train <- subset(iris, sample == TRUE)
iris_test <-  subset(iris, sample == FALSE)
class_train_iris <-  iris_train$Species

iris_train <- iris_train[,-5]
iris_test <-  iris_test[,-5]
knn(train = iris_train, test = iris_test, 
    cl = class_train_iris, k = 3) -> iris_test$knn
iris_test$label <-  
  iris$Species[c(as.numeric(rownames(iris_test)))]
CrossTable(iris_test$knn,iris_test$label, prop.chisq = FALSE)
