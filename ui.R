# TODO: Add comment
# 
# Author: kirk
###############################################################################

#ergm-common
#ui.R
library(shiny)
library(statnet)

source("chooser.R")
source("functions.R")
customTextInput<-function (inputId, label, value="",...) {
	tagList(tags$label(label, `for` = inputId), tags$input(id = inputId,
					type="text",
					value=value,...))
}

splitLayout(
		plotOutput("plot1"),
		plotOutput("plot2")
)


shinyUI(fluidPage(
				titlePanel("network app"),
				splitLayout( 
						wellPanel(width=5, 
								tabsetPanel(
										tabPanel('Data',
												fluidRow(
														column(12,
																wellPanel(
																		h3('Choose a dataset'),
																		selectInput('dataset',
																				label = 'Sample datasets',
																				c(Choose = '', 'ecoli1', 'ecoli2', 'faux.mesa.high',
																						'fauxhigh', 'flobusiness','flomarriage',
																						'kapferer','kapferer2','samplike'),
																				selectize = FALSE),
																		br(),
																		actionButton('goButton', 'Run')))
												)),
										tabPanel('Generic',
												fluidRow(
														column(12,
																wellPanel(
#                                                                        actionButton('Type1',"Click to Use Type1"),
																		chooserInput("mychooser_generic", "Available arguments", "Selected 
																						metric",generic.arg.vec(), c(), size = 10, multiple = TRUE
																		)),
																wellPanel(
                  h3("Parameter Value"),
																		UI_G1("generic") # written in function.R
																)
														))),
										tabPanel('Layout',
												fluidRow(
														column(12,
																wellPanel(
#                                                                        actionButton('Type1',"Click to Use Type1"),
																		chooserInput("mychooser_layout", "Available arguments", "Selected 
																						metric",layout.arg.vec(), c(), size = 10, multiple = TRUE
																		)),
																wellPanel(
																		h3("Parameter Value"),
																		UI_G1("layout") # written in function.R
																)
														))),
										
										tabPanel('Vertex',
												fluidRow(
														column(12,
																wellPanel(
																		chooserInput("mychooser_vertex", leftLabel="Available arguments", rightLabel="Selected 
																						arguments",vertex.arg.vec(), c(), size = 10, multiple = TRUE
																		)),
																wellPanel(
																		h3("Parameter Value"),
																		UI_G1("vertex") # written in function.R
																)
														))),
										tabPanel('Edge',
												fluidRow(
														column(4,
																wellPanel(
#                                                                        actionButton('Type1',"Click to Use Type1"),
																		chooserInput("mychooser_edge", "Available arguments", "Selected 
																						metric",edge.arg.vec(), c(), size = 10, multiple = TRUE
																		)),
																wellPanel(
																		h3("Parameter Value"),
																		UI_G1("edge") # written in function.R
																)
														))),
#          tabPanel('Graphical Parameter Type 1',
#            fluidRow(
#              column(4,
#                wellPanel(
#                  actionButton('Type1',"Click to Use Type1"),
#                  chooserInput("mychooser", "Available arguments", "Selected 
#                      metric",network.arg.vec(), c(), size = 10, multiple = TRUE
#                  )),
#                wellPanel(
#                  h3("Parameter Value"),
#                  UI_G1() # written in function.R
#                )
#              ))),
#          tabPanel('Graphical Parameter Type 2',
#            fluidRow(
#              column(3, wellPanel(
#                  actionButton('Type2',"Click to Use Type2"),
#                  h4("Choose arguments"),
#                  checkboxGroupInput("net.ele",
#                    "Network Elements:",
#                    choices = list(
#                      "edge" = "edge",
#                      "vertex" = "vertex")),
#                  checkboxGroupInput("net.eff",
#                    "Network Effect:",
#                    choices = list(
#                      "cex" = "cex",
#                      "col" = "col"))
#                ),
#                
#                wellPanel(
#                  h3("Parameter Value"),
#                  UI_G2() # written in function.R
#                )        
#              
#              )
#            )),
										tabPanel('Save'))),
						wellPanel(   
								h4('Console Message'),
								verbatimTextOutput('text'),	  
								h4('Network Plot'),
								plotOutput('nwplot'),
								h4('Network Summary'),
								uiOutput("attrUI"))
				),
				
				fluidRow(
						column(1, img(src = 'csdelogo_crop.png', height = 50, width = 50)),
						column(2, h6('Center for Studies in Demography and Ecology'))
				)
		
		
		
		
		)
)





