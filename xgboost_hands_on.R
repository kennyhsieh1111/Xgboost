# Loading or Install Library
if (!require('xgboost')) install.packages('xgboost')

# 1. Input Type
data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')

train <- agaricus.train
test <- agaricus.test

# 2. Observe Data Structure
str(train)
class(train$data)[1]
class(train$label)

# 3. Model Building
## dgCMatrix
bstSparse <- xgboost(data = train$data, label = train$label, 
                     max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")

## xgb.DMatrix
dtrain <- xgb.DMatrix(data = train$data, label = train$label)
bstDMatrix <- xgboost(data = dtrain, 
                      max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")

# 4. Prediction
pred <- predict(bstDMatrix, test$data)
head(pred)

prediction <- as.numeric(pred > 0.5)
head(prediction)

# 5. Accuracy
table(prediction, test$label)
err <- mean(prediction != test$label)
print(paste("test-acc =", round(1- err, digits = 2)))
