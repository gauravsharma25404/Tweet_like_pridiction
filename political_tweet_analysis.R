library(dplyr)
library(ggplot2)
library(caTools)
library(corrgram)
library(readxl)
df <- read_excel('D:/data_pol.xlsx')
head(df)
any(is.na(df))
ggplot(data = df, aes(x=Public_Impact, y=Inner_sentiment)) + geom_point(aes(color=Like_Count, size=10, alpha=0.7))
corrgram(df, lower.panel=panel.shade, upper.panel=panel.cor)
set.seed(42)

sampleSplit <- sample.split(Y=df$Like_Count, SplitRatio=0.7)
trainSet <- subset(x=df, sampleSplit==TRUE)
testSet <- subset(x=df, sampleSplit==FALSE)

model <- lm(Like_Count ~ Public_Impact + Inner_sentiment + Party_No + Views + Reposts, data=trainSet)
summary(model)
modelResiduals <- as.data.frame(residuals(model))

ggplot(modelResiduals, aes(residuals(model))) +
  geom_histogram(fill='blue', color='black')

preds <- predict(model, testSet)
modelEval <- cbind(testSet$Like_Count, preds)
colnames(modelEval) <- c('Actual', 'Predicted')
modelEval <- as.data.frame(modelEval)
modelEval

mse <- mean((modelEval$Actual - modelEval$Predicted)^2)
rmse <- sqrt(mse)
rmse
accuracy <- 100 * (1 - mse / var(df$Like_Count))
print(paste("Accuracy: ",accuracy,"%"))