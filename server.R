library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(corrgram)
library(caTools)  # Load the caTools package
library(scatterplot3d)

shinyServer(function(input, output) {
  
  data <- reactive({
    req(input$file)
    inFile <- input$file
    if (!is.null(inFile) && identical(tolower(substr(inFile$name, nchar(inFile$name) - 4, nchar(inFile$name))), ".xlsx")) {
    read_excel(inFile$datapath)
  } else {
    NULL
  }
  })

output$prediction <- renderPrint({
  if (!is.null(data())) {
    set.seed(42)
    sampleSplit <- caTools::sample.split(Y = data()$Like_Count, SplitRatio = 0.7)
    trainSet <- subset(x = data(), sampleSplit == TRUE)
    testSet <- subset(x = data(), sampleSplit == FALSE)
    model <- lm(Like_Count ~ Public_Impact + Inner_sentiment + Username + Views + Reposts, data = trainSet)
    
    preds <- predict(model, testSet)
    modelEval <- data.frame(Actual = testSet$Like_Count, Predicted = preds)
    
    mse <- mean((modelEval$Actual - modelEval$Predicted)^2)
    rmse <- sqrt(mse)
    accuracy <- 100 * (1 - mse / var(data()$Like_Count))
    
    cat("Root Mean Squared Error (RMSE): ", rmse, "\n")
    cat("Accuracy: ", accuracy, "%\n")
    
    modelEval
  }
})

output$fullDataset <- renderTable({
  if (!is.null(data()))
    data()
})

output$selectedPlot <- renderPlot({
  if (!is.null(data())) {
    plot_type <- input$plotType
    
    if (plot_type == "Bar Chart") {
      # Your code to create a bar chart
      barplot(df$Like_Count, names.arg = df$Views, col = "skyblue", main = "Bar Chart Example", xlab = "Categories", ylab = "Values")
      
    } else if (plot_type == "Histogram") {
      # Your code to create a histogram
      modelResiduals <- as.data.frame(residuals(model))
      ggplot(modelResiduals, aes(residuals(model))) +
        geom_histogram(fill = 'blue', color = 'black')
      
    } else if (plot_type == "Correlation Graph") {
      # Your code to create a correlation graph
      corrgram(df, lower.panel = panel.shade, upper.panel = panel.cor)
      
    } else if (plot_type == "Scatter Plot") {
      # Your code to create a scatter plot
      ggplot(data = df, aes(x = Public_Impact, y = Inner_sentiment)) +
        geom_point(aes(color = Like_Count, size = 10, alpha = 0.7))
      
    } else if (plot_type == "Scatter Plot 3D") {
      # Your code to create a 3D scatter plot
      scatterplot3d(df$Like_Count, df$Views, df$Reposts, color="blue", pch=16, main="3D Scatterplot Example",
                    xlab="X-axis label", ylab="Y-axis label", zlab="Z-axis label")
      
    } else if (plot_type == "Pie Chart") {
      # Your code to create a pie chart
      pie(df$Like_Count, labels = df$Views, main = "Pie Chart Example")
      
    } else {
      # Add other plot types here if needed
    }
  }
})
})
