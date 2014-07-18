# TODO: Add comment
# 
# Author: kirk
###############################################################################

library(shiny)
library(statnet)
source("functions.R")

shinyServer(
    function(input, output){
      
      #load datasets
      data(ecoli)
      data(florentine)
      data(fauxhigh)
      data(faux.mesa.high)
      data(kapferer)
      data(sampson)
      
      nw.reac <- reactive({
            if(input$goButton==0)return()
            input$goButton
            isolate(eval(parse(text = input$dataset)))
          })
      #number of nodes in nw
      nodes <- reactive({
            if(input$goButton==0)return()
            input$goButton
            isolate(nw.reac()$gal$n)}) 
      #get coordinates to plot network with
      coords <- reactive({
            if(input$goButton==0)return()
            input$goButton
            isolate(plot.network(eval(parse(text = input$dataset))))})
      
      #list of vertex attributes in nw
      attr <- reactive({
            if(input$goButton==0)return()
            input$goButton
            attr <- c()
            if(input$dataset != ''){      
              isolate(  attr<-list.vertex.attributes(nw.reac()))
            }
            attr
          }) 
      
      #numeric attributes only (for size menu)
      numattr <- reactive({
            if(input$goButton==0)return()
            input$goButton   
            numattr <- c()
            if(input$dataset != ''){  
              for(i in 1:length(attr())){
                if(is.numeric(isolate(get.vertex.attribute(nw.reac(),attr()[i])))){
                  numattr <- append(numattr,attr()[i])
                } 
              }} 
            numattr})
      
      
      output$dynamiccolor <- renderUI({
            selectInput('colorby',
                label = 'Color nodes according to:',
                c('None' = 2, attr()),
                selectize = FALSE)
          })
      
      output$dynamicsize <- renderUI({
            selectInput('sizeby',
                label = 'Size nodes according to:',
                c('None' = 1, numattr()),
                selectize = FALSE)
          })
      
      
      ########Jul 17, 2014########G-para TYPE1########
      metric.list <- reactive({
            if(input$goButton==0)return()
            if(length(input$mychooser$right)>=1)
              input$mychooser$right
            else return()
          })
      
      
      ct=1:50
      eval(parse(text=paste0("output$para.",ct," <- renderUI({
                      if(length(input$mychooser$right)>= ",ct," ){
                      count <- ",ct,"
                      inputId = eval(parse(text=paste0('\"para.',count,'\"')))
                      label= eval(parse(text=paste0('paste0(metric.list()[',count,'],\":\")')))
                      value= eval(parse(text=paste0('paste0(metric.list()[',count,'],\"=\",network.arg.vec.val()[metric.list()[[',count,']]],collapse=\"\n\")')))
                      if(nchar(value)>=2 & length(value)>0) # colum sign 
                      inputTextarea(inputId,label,value,nrow=5,ncol=10)
                      else return()
                      }
                      else return()
                      })")))
      
      
      eval(parse(text=paste0("metric.list.m.",ct,"<- reactive({if(length(input$mychooser$right)>=",ct,"){
                      if(length(input$para.",ct,")>0){
                      l1 <- input$para.",ct,"
                      unlist(l1) }
                      else return()
                      } 
                      })")))
      
      
      
      
      ########Jul 17, 2014########G-para TYPE 2########
      output$ui <- renderUI({
            if (is.null(input$net.ele))
              return()
          })
      
      argSelect <- reactive({
            tmp <- network.arg.vec() 
            if(is.null(input$net.ele) & is.null(input$net.eff)) return() else
            if(is.null(input$net.ele) & !is.null(input$net.eff)) arg.names.vec <- tmp[grep(input$net.eff,tmp)] else
            if(!is.null(input$net.ele) & is.null(input$net.eff)) arg.names.vec <- tmp[grep(input$net.ele,tmp)] else
            if(!is.null(input$net.ele) & !is.null(input$net.eff))
              arg.names.vec <- intersect(tmp[grep(input$net.ele,tmp)],tmp[grep(input$net.eff,tmp)]) 
            arg.names.vec
          })
      
      
      ct=1:50
      eval(parse(text=paste0("output$paraT2.",ct," <- renderUI({
                      if(length(argSelect())>= ",ct," ){
                      count <- ",ct,"
                      inputId = eval(parse(text=paste0('\"paraT2.',count,'\"')))
                      label= eval(parse(text=paste0('paste0(argSelect()[',count,'],\":\")')))
                      value= eval(parse(text=paste0('paste0(argSelect()[',count,'],\"=\",network.arg.vec.val()[argSelect()[[',count,']]],collapse=\"\n\")')))
                      if(nchar(value)>=2 & length(value)>0) # colum sign 
                      inputTextarea(inputId,label,value,nrow=5,ncol=10)
                      else return()
                      }
                      else return()
                      })")))
      
      
      eval(parse(text=paste0("metric.list.m.",ct,"<- reactive({if(length(input$mychooser$right)>=",ct,"){
                      if(length(input$para.",ct,")>0){
                      l1 <- input$para.",ct,"
                      unlist(l1) }
                      else return()
                      } 
                      })")))
      
      
      eval(parse(text=paste0("metric.list.m.2.",ct,"<- reactive({if(length(argSelect())>=",ct,"){
                      if(length(input$paraT2.",ct,")>0){
                      l1 <- input$paraT2.",ct,"
                      unlist(l1) }
                      else return()
                      } 
                      })")))
      
      
      ########Jul 17, 2014######## read-in argument input ########
      argFun <- reactive({
            if(input$Type1 >input$Type2) # click Type 1
            string.use <- paste0("c(",paste0("metric.list.m.",1:50,"()",collapse=","),")") else if(input$Type2>=input$Type1 & !input$Type2==0) # click Type 2
            string.use <- paste0("c(",paste0("metric.list.m.2.",1:50,"()",collapse=","),")") else 
            # hasn't click yet 
            return()
          
          metricsOptArgVal <- eval(parse(text=string.use))
            metricsOptArgVal
          })
      
      
      output$text <- renderPrint({
#       nw <- isolate({nw.reac()})
#       plotlist <- argFun()
#      tmp <- if(length(plotlist)){","}
#      paste("plot.network(nw",tmp,paste(plotlist,sep=",",collapse=","),")")
            argFun()
          })
      ########Jul 18, 2014######## generate plot ########
      output$nwplot <- renderPlot({
            if (input$goButton == 0){
              return()
            }
            input$goButton
            nw <- isolate({nw.reac()})
            plotlist <- argFun()
            tmp <- if(length(plotlist)){","}
            eval(parse(text=paste("plot.network(nw",tmp,paste(plotlist,sep=",",collapse=","),")")
                ))
          })
      
      #summary of network attributes
      output$attr <- renderPrint({
            if (input$goButton == 0){
              return(cat('Please choose a sample dataset from the side panel'))
            }
            nw <- isolate(nw.reac())
            return(nw)
          })
      
    })

