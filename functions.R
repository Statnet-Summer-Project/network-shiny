library(statnet)

########Jul 18, 2014######## UI function ########

# function to generate dynamic ui for Type1
UI_G1 <- function(){
tmp <- lapply(1:50,function(ct) {eval(parse(text=paste("uiOutput('para.",ct,"')",sep="",collapse="")))})
tmp
}

# function to generate dynamic ui for Type2
UI_G2 <- function(){
  tmp <- lapply(1:50,function(ct) {eval(parse(text=paste("uiOutput('paraT2.",ct,"')",sep="",collapse="")))})
  tmp
}


testfn <- function()  titlePanel("network app")
testfn()
########Jul 18, 2014######## Server function ########
network.arg.vec <- function()names(formals(plot.network.default))

network.arg.vec.val <- function(){
  tmp <- formals(plot.network.default)
  tmp.class <- unlist(lapply(tmp,class))
  tmp[tmp.class%in%c("call","character")] <- 
      paste0("'",tmp[tmp.class%in%c("call","character")],"'")
  tmp
}
par.arg.vec <- function()names(par())

#network.arg.vec()
#network.arg.vec.val()


