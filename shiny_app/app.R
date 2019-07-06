#
# This is a Shiny web application demoing using a dockerfile and also 
# calculating one form of graph distance.

library(shiny)
library(R6)

# Define UI for application that draws a histogram
ui <- fluidPage(



    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h2("Demo Graph Distance"),
            textInput("u1Node", "Starting U Node", placeholder = TRUE),
            textInput("u2Node", "Ending U Node", placeholder = TRUE),
            actionButton("calcDistance", "Calculate Distance"),
            wellPanel(textOutput("distanceFound"))
            

        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Description", includeHTML("./desc.html")),
                tabPanel("Source Data", 
                  fluidPage(
                      fluidRow(
                          column(4,
                            numericInput("uNodeCount", "Count of U Nodes", min = 2, value = 50)
                          ),
                          column(4,
                              selectInput("graphType", "Graph Type", c(
                                  "Many P to U, Many U to P",
                                  "Many P to U, Few U to P",
                                  "Few P to U, Many U to P",
                                  "Few P to U, Few U to P",
                                  "Chain of U nodes"
                              ))
                          ),
                          column(4,
                            actionButton("createData", "Create Sample Date", width = "100%"),
                            actionButton("loadData", "Load Data Into Graph", width = "100%")
                          )
                          
                      ),
                      br("1 line per U node, format <U node name>:<P node name>,<P node name>,..."),
                      br("e.g.  U1:P1,P2"),
                      wellPanel(textAreaInput("summary", "Source Graph Data", height = "100%"))
                  )
                ),
                tabPanel("Visualise Graph", plotOutput("graphPlot"))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  

}

# Run the application 
shinyApp(ui = ui, server = server)
