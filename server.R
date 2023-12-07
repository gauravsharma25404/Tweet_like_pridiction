# server.R

# Load libraries
library(dplyr)
library(ggplot2)
library(caTools)
library(corrgram)
library(readxl)
library(shiny)

# Load data
df <- read_excel('D:/data_pol.xlsx')

# Define server
shinyServer(function(input, output) {
  
  # Scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(data = df, aes(x = Public_Impact, y = Inner_sentiment)) +
      geom_point(aes(color = Like_Count, size = 10, alpha = 0.7))
  })
  
  # Correlation plot
  output$corrPlot <- renderPlot({
    corrgram(df, lower.panel = panel.shade, upper.panel = panel.cor)
  })
  
  # Histogram of model residuals
  output$histogramPlot <- renderPlot({
    modelResiduals <- as.data.frame(residuals(model))
    ggplot(modelResiduals, aes(residuals(model))) +
      geom_histogram(fill = 'blue', color = 'black')
    
  })
  
  # Table of model results
  output$modelResults <- renderTable({
    modelEval <- cbind(testSet$Like_Count, preds)
    colnames(modelEval) <- c('Actual', 'Predicted')
    as.data.frame(modelEval)
  })
})
