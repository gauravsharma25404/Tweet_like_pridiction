library(shiny)

shinyUI(
  navbarPage(
    "Political Tweets",
    tabPanel("Upload Data",
             fluidPage(
               titlePanel("Upload Your Dataset"),
               sidebarLayout(
                 sidebarPanel(
                   fileInput("file", "Choose an Excel file", accept = c(".xls", ".xlsx"))
                 ),
                 mainPanel(
                   h3("Predicted Likes Count:"),
                   verbatimTextOutput("prediction")
                 )
               )
             )
    ),
    tabPanel("View Dataset",
             fluidPage(
               titlePanel("View Dataset"),
               fluidRow(
                 column(12,
                        tableOutput("fullDataset")
                 )
               )
             )
    ),
    tabPanel("Visualization",
             fluidPage(
               titlePanel("Visualization Options"),
               sidebarLayout(
                 sidebarPanel(
                   selectInput("plotType", "Choose a plot type:",
                               choices = c("---choose plot---", "Bar Chart", "Histogram", "Correlation Graph", "Scatter Plot", "Scatter Plot 3D", "Pie Chart")
                   ),
                   actionButton("plotBtn", "Plot", p = 1, width = 100),
                   width = 8
                 ),
                 mainPanel(
                   plotOutput("selectedPlot")
                 )
               )
             )
    )
  )
)
