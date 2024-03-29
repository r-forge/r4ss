SSplotSPR <-
  function(replist,add=FALSE,plot=TRUE,print=FALSE,
           uncertainty=TRUE,
           subplots=1:4,
           col1="black",col2="blue",col3="green3",col4="red",
           sprtarg="default", btarg="default",
           labels=c("Year", #1
             "SPR",         #2
             "1-SPR"),      #3
           pwidth=7,pheight=7,punits="in",res=300,ptsize=12,cex.main=1,
           plotdir="default",
           verbose=TRUE)
{
  # plot SPR-related quantities
  
  pngfun <- function(file,caption=NA){
    png(filename=file,width=pwidth,height=pheight,
        units=punits,res=res,pointsize=ptsize)
    plotinfo <- rbind(plotinfo,data.frame(file=file,caption=caption))
    return(plotinfo)
  }
  plotinfo <- NULL

  if(plotdir=="default") plotdir <- replist$inputs$dir

  sprseries             <- replist$sprseries
  timeseries            <- replist$timeseries
  derived_quants        <- replist$derived_quants
  nsexes                <- replist$nsexes
  nseasons              <- replist$nseasons
  endyr                 <- replist$endyr
  managementratiolabels	<- replist$managementratiolabels

  if(sprtarg=="default") sprtarg <- replist$sprtarg
  if(btarg=="default") btarg <- replist$btarg
    
  sprfunc <- function(){
    if(!add) plot(sprseries$Year,sprseries$spr,xlab=labels[1],ylab=labels[2],
                  ylim=c(0,max(1,max(sprseries$spr[!is.na(sprseries$spr)]))),type="n")
    lines(sprseries$Year,sprseries$spr,type="o",col=col2)
    if(sprtarg>0) abline(h=sprtarg,col=col4,lty=2)
    abline(h=0,col="grey")
    abline(h=1,col="grey")
  }
  
  if(1 %in% subplots){
    if(plot) sprfunc()
    if(print){
      file <- file.path(plotdir,"/SPR1_series.png")
      caption <- "Timeseries of SPR"
      plotinfo <- pngfun(file=file, caption=caption)
      sprfunc()
      dev.off()
    }
  }

  # temporary disable multi-season models until code cleanup
  if(nseasons>1) cat("Skipped additional SPR plots because they're not yet configured for multi-season models\n")
  if(nseasons==1){ 
    sprfunc2 <- function(){
      if(!add) plot(sprseries$Year,(1-sprseries$spr),
                    xlab=labels[1],ylab=labels[3],ylim=c(0,1),type="n")
      lines(sprseries$Year,(1-sprseries$spr),type="o",col=col2)
      if(sprtarg>0) abline(h=(1-sprtarg),col=col4,lty=2)
      abline(h=0,col="grey")
      abline(h=1,col="grey")}

    if(2 %in% subplots){
      if(plot) sprfunc2()
      if(print){
        file <- file.path(plotdir,"/SPR2_minusSPRseries.png")
        caption <- "Timeseries of 1-SPR"
        plotinfo <- pngfun(file=file, caption=caption)
        sprfunc2()
        dev.off()
      }
    }

    if(!uncertainty | sprtarg<=0){
      cat("skipped SPR ratio timeseries: requires both sprtarg>0 and uncertainty=TRUE.\n")
    }else{
      sprratiostd <- derived_quants[substring(derived_quants$LABEL,1,8)=="SPRratio",]
      sprratiostd$Yr <- as.numeric(substring(sprratiostd$LABEL,10))
      sprratiostd$period <- "fore"
      sprratiostd$period[sprratiostd$Yr<=(endyr)] <- "time"
      sprratiostd$upper <- sprratiostd$Value + 1.96*sprratiostd$StdDev
      sprratiostd$lower <- pmax(sprratiostd$Value - 1.96*sprratiostd$StdDev,0) # max of value or 0
      ylab <- managementratiolabels[1,2]
      ylim=c(0,max(1,sprratiostd$upper[sprratiostd$period=="time"]))
      sprfunc3 <- function(){
        if(!add) plot(sprratiostd$Yr[sprratiostd$period=="time"],sprratiostd$Value[sprratiostd$period=="time"],
                      xlab=labels[1],ylim=ylim,ylab=ylab,type="n")
        lines(sprratiostd$Yr[sprratiostd$period=="time"],sprratiostd$Value[sprratiostd$period=="time"],
              type="o",col=col2)
        abline(h=0,col="grey")
        abline(h=1,col=col4)
        text((min(sprratiostd$Yr)+4),(1+0.02),"Management target",adj=0)
        lines(sprratiostd$Yr[sprratiostd$period=="time"],sprratiostd$upper[sprratiostd$period=="time"],col=col2,lty="dashed")
        lines(sprratiostd$Yr[sprratiostd$period=="time"],sprratiostd$lower[sprratiostd$period=="time"],col=col2,lty="dashed")
      }
      if(3 %in% subplots){
        if(plot) sprfunc3()
        if(print){
          file <- file.path(plotdir,"/SPR3_ratiointerval.png")
          caption <- "Timeseries of SPR ratio"
          plotinfo <- pngfun(file=file, caption=caption)
          sprfunc3()
          dev.off()
        }
      }
    }

    if(4 %in% subplots){
      if(btarg<=0 | sprtarg<=0){
        cat("skipped SPR phase plot because btarg or sprtarg <= 0\n")
      }else{
        timeseries$Yr <- timeseries$Yr + (timeseries$Seas-1)/nseasons
        #!subsetting to area 1 only. This should be generalized
        ts <- timeseries[timeseries$Area==1 & timeseries$Yr <= endyr,] 
        tsyears <- ts$Yr[ts$Seas==1]
        tsspaw_bio <- ts$SpawnBio[ts$Seas==1]
        if(nsexes==1) tsspaw_bio <- tsspaw_bio/2
        depletionseries <- tsspaw_bio/tsspaw_bio[1]
        reldep <- depletionseries[tsyears %in% sprseries$Year]/btarg
        relspr <- (1-sprseries$spr[sprseries$Year <= endyr])/(1-sprtarg)
        xmax <- 1.1*max(reldep)
        ymax <- 1.1*max(1,relspr[!is.na(relspr)])
        ylab <- managementratiolabels[1,2]
        phasefunc <- function(){
          if(!add) plot(reldep,relspr,xlab="B/Btarget",
                        xlim=c(0,xmax),ylim=c(0,ymax),ylab=ylab,type="n")
          lines(reldep,relspr,type="o",col=col2)
          abline(h=0,col="grey")
          abline(v=0,col="grey")
          lines(reldep,relspr,type="o",col=col2)
          points(reldep[length(reldep)],relspr[length(relspr)],col=col4,pch=19)
          abline(h=1,col=col4,lty=2)
          abline(v=1,col=col4,lty=2)
        }

        if(plot) phasefunc()
        if(print){
          file <- file.path(plotdir,"/SPR4_phase.png")
          caption <- "Phase plot of biomass ratio vs. SPR ratio"
          plotinfo <- pngfun(file=file, caption=caption)
          phasefunc()
          dev.off()
        }
      }
    } # end test for making phase plot
  } # end check for number of seasons=1
  if(!is.null(plotinfo)) plotinfo$category <- "SPR"
  return(invisible(plotinfo))
}
