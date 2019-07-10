#
# This is a Shiny web application demoing using a dockerfile and also
# calculating one form of graph distance.

library(shiny)
library(R6)
library(futile.logger)
library(stringi)
library(stringr)
library(purrr)
library(hashmap)
library(data.table)
library(networkD3)


devtools::load_all("demoGraphDistance")


# Define UI for application that draws a histogram
ui <- fluidPage(



    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h2("Demo Graph Distance"),
            textInput("u1Node", "Starting U Node", placeholder = TRUE, value = "U1"),
            textInput("u2Node", "Ending U Node", placeholder = TRUE, value = "U2"),
            actionButton("calcDistance", "Calculate Distance"),
            wellPanel(span(h4("Distance = "),textOutput("distanceFound", inline = TRUE))),
            actionButton("plotGraph", "Plot Graph"),
            h4("count of U nodes loaded"),
            textOutput("uNodesInGraph", inline=TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Description", includeHTML("./desc.html")),
                tabPanel("Source Data",
                  fluidPage(
                      fluidRow( 
                          column(4,
                            numericInput("uNodeCount", "Count of U Nodes", min = 2, value = 10, max = 200)
                          ),
                          column(4,
                              selectInput("graphType", "Graph Type", c(
                                  # "Many P to U, Many U to P",
                                  # "Many P to U, Few U to P",
                                  # "Few P to U, Many U to P",
                                  # "Few P to U, Few U to P",
                                  "Chain of U nodes"
                              ))
                          ),
                          column(4, style = "margin-top: 25px;",
                            actionButton("createData", "Create Sample Date", width = "100%" )
                          )

                      ),
                      actionButton("loadData", "Load Data Into Graph", width = "100%"),

                      wellPanel(
                        br("1 line per U node, format <U node name>:<P node name>,<P node name>,..."),
                        br("e.g.  U1:P1,P2"),
                        textAreaInput("graphSrcData", "Source Graph Data", 
                                      height = "100%", rows = 20,
                                      value = "U1:P0,P1,P3\nU2:P1,P2\nU3:P2,P3")

                      )
                  )
                ),
                tabPanel("Visualise Graph", simpleNetworkOutput("graphPlot"))
            )
        )
    )
)

# Define server logic for plotting
server <- function(input, output,session) {
  local_graph <- UPGraphStorage$new()
  output$uNodesInGraph <- renderText("0")
  

  observeEvent(input$createData, {
    local_graph$load_from_chain(input$uNodeCount)
    output$uNodesInGraph <- renderText(local_graph$p_nodes_per_u_node$size())
    updateTextAreaInput(session, "graphSrcData", label = NULL, 
                        value = local_graph$get_as_string()
    )
  })

  observeEvent(input$calcDistance, {
    if (input$u1Node ==  "" || input$u2Node == "" ||  
        local_graph$p_nodes_per_u_node$size() < 2 ||
        ! local_graph$has_u_node(input$u1Node) ||
        ! local_graph$has_u_node(input$u2Node) 
    ) {
      showNotification("Ensure a graph is loaded with at least 2 U nodes and the starting and ending node are in the graph")
    } else {
      output$distanceFound <- renderText(
        get_p_distance(input$u1Node,
                       input$u2Node,
                       local_graph)
      )
    }

  })

  observeEvent(input$loadData, {
    if (input$graphSrcData == ""){
      showNotification("enter the graph source")
    } else {
      local_graph$load_from_string(input$graphSrcData)
      output$uNodesInGraph <- renderText(local_graph$p_nodes_per_u_node$size())
      if(local_graph$p_nodes_per_u_node$size() < 2) {
        showNotification("Failed to load a graph with at least 2 U nodes")
      }
    }
  })

  observeEvent(input$plotGraph, {
    if (input$u1Node ==  "" || input$u2Node == "" ||  
        local_graph$p_nodes_per_u_node$size() < 2 ||
        ! local_graph$has_u_node(input$u1Node) ||
        ! local_graph$has_u_node(input$u2Node) 
    ) {
      showNotification("Ensure a graph is loaded with at least 2 U nodes and the starting and ending node are in the graph")
    } else {
      get_connection_from_node <- function(u_node){
        unlist(map(local_graph$get_p_nodes(u_node), ~paste0(u_node,":",.x)))
      }
      
      pairs <- stringr::str_split_fixed(
        unlist(map(local_graph$p_nodes_per_u_node$keys(),
                   ~get_connection_from_node(.x))),
        ":",2
      )

      
      networkData <- data.frame(pairs[,1], pairs[,2])  
      output$graphPlot <- renderSimpleNetwork({
        simpleNetwork(networkData)
      })
      }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
