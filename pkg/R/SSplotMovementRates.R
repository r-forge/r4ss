SSplotMovementRates <-
  function(replist, plot=TRUE, print=FALSE, subplots=1:2,
           plotdir="default",
           colvec="default", ylim="default", 
           legend=TRUE, legendloc="topleft",
           moveseas="all",
           pwidth=7,pheight=7,punits="in",res=300,ptsize=12,cex.main=1,
           verbose=TRUE)
{
  #if(verbose) cat("Running SSplotMovementRates function\n")

  pngfun <- function(file,caption=NA){
    png(filename=file,width=pwidth,height=pheight,
        units=punits,res=res,pointsize=ptsize)
    plotinfo <- rbind(plotinfo,data.frame(file=file,caption=caption))
    return(plotinfo)
  }
  plotinfo <- NULL

  if(plotdir=="default") plotdir <- replist$inputs$dir
  
  # get values from replist
  accuage    <- replist$accuage
  move       <- replist$movement
  nseasons   <- replist$nseasons
  firstage   <- 0.5 # need to get firstage into repfile somewhere
  # firstage   <- 0 # need to get firstage into repfile somewhere
  seasdur    <- replist$seasdurations
  move       <- replist$movement
  parameters <- replist$parameters
  accuage    <- replist$accuage
  nareas     <- replist$nareas
  MGparmAdj  <- replist$MGparmAdj

  # some empty value to be replaced in subplot 2
  moveByYr   <- NULL 
  moveinfo   <- NULL

  # subplot 1: movement in end year
  if(1 %in% subplots){
    if(verbose) cat("  running subplot 1: movement rates in final year\n")
    
    if(moveseas[1]=="all") moveseas <- sort(unique(move$Seas))
    for(iseas in moveseas){
      move2   <- move[move$Seas==moveseas[iseas] &
                      move$Source_area!=move$Dest_area,]
      
      if(nrow(move2)==0){
        if(verbose) cat("Skipping movement rate plot: no movement in season",moveseas[iseas],"\n")
      }else{
        move3 <- move2[,-(1:6)]
        
        if(colvec[1]=="default") colvec=rich.colors.short(nrow(move2))
        if(ylim[1]=="default") ylim=c(0,1.1*max(move))
        main <- paste("Movement rates\n(fraction moving per year in season ",moveseas[iseas],")",sep="")
        # bundle plot as function below
        tempfun <- function(){
          matplot(0:accuage,t(move3),
                  type='l',lwd=3,lty=1,col=colvec,
                  ylab="Movement rate",xlab="Age (years)",
                  main=main,
                  cex.main=cex.main)
          abline(h=0,col='grey')
          if(legend){
            legend(legendloc,lwd=3,bty="n",
                   col=colvec,
                   legend=paste("area",move2$Source_area,"to area",move2$Dest_area)
                   )
          }
        }
        if(plot) tempfun()
        if(print){
          file <- paste(plotdir,"/move1_movement_rates.png",sep="")
          caption <- main
          plotinfo <- pngfun(file=file, caption=caption)
          tempfun()
          dev.off()
        }
      }
    } # end loop over seasons
  } # end subplot 1

  # subplot 2: time-varying movement
  if(2 %in% subplots){
    # subset some report values
    movepars <- parameters[grep("Move",replist$parameters$Label),]
    MGparmAdj <- MGparmAdj[,c(1,grep("MoveParm",names(MGparmAdj)))]
    time <- any(apply(MGparmAdj[,-1], 2, function(x){any(x!=x[1])}))

    if(time){
      if(verbose) cat("  running subplot 2: time-varying movement rates\n")

      moveinfo <- move[,1:6]
      moveinfo$LabelBase2 <- paste("seas_",moveinfo$Seas,"_GP_",moveinfo$Gpattern,
                                   "from_",moveinfo$Source,"to_",moveinfo$Dest,sep="")
      moveinfo <- moveinfo[moveinfo$LabelBase2 %in% substring(movepars$Label,12),]

      nmoves <- nrow(moveinfo)
      yrvec <- replist$startyr:replist$endyr
      nyrs <- length(yrvec)

      ## if(nmoves*2 != nrow(movepars)){
      ##   cat("warning!: In SSplotMovementRates function.\n
      ##                Problem with number of parameters.\n
      ##                2*nrow(moveinfo)=",2*nrow(moveinfo),"\n,
      ##                nrow(movepars)  =",nrow(movepars),"\n")
      ## }

      movecalc <- function(firstage, accuage, minage, maxage, valueA, valueB, from, to, seasdur) {
        # subfunction to calculate movement rates
        # similar to one in the "movepars" function.
        # in the future, these could be generalized and stand-alone in the r4ss package
        veclengths <- unique(c(length(minage),length(maxage),
                               length(valueA),length(valueB),
                               length(from),length(to)))
        if(length(veclengths)!=1){
          stop("Error! input vectors  minage, maxage, valueA, valueB, from, and to need to all have the same length.")
        }else{
          npars <- veclengths
        }
        
        agevec <- 0:accuage
        nages <- length(agevec)

        movemat1 <- matrix(NA,npars,nages) # raw values
        movemat2 <- matrix(NA,npars,nages) # normalized to sum to 1

        temp <- 1/(maxage-minage)
        temp1 <- temp*(valueB-valueA)
        
        for(iage in 1:nages){
          for(ipar in 1:npars){
            if(agevec[iage] <= minage[ipar]) movemat1[ipar,iage] <- valueA[ipar]
            if(agevec[iage] >= maxage[ipar]) movemat1[ipar,iage] <- valueB[ipar]
            if(agevec[iage] > minage[ipar] & agevec[iage] < maxage[ipar]) movemat1[ipar,iage] <- valueA[ipar] + (agevec[iage]-minage[ipar])*temp1[ipar]
          }
        }
        movemat1 <- exp(movemat1)
        movemat1[from!=to, ] <- 0.25*movemat1[from!=to, ]
        movemat2 <- movemat1/matrix(apply(movemat1,2,sum),npars,nages,byrow=T)
        names <- paste("from_",from,"to_",to,sep="")
        # fix movement at 0 for when from and to areas don't match
        movemat2[,0:accuage < firstage] <- from==to
        rownames(movemat2) <- names

        return(movemat2)
      } # end movecalc subfunction


      # make an array of movement rates by source area, age, destination area, and year
      moveByYr <- array(NA,dim=c(nareas,accuage+1,nmoves,nyrs),dimnames=list(area=1:nareas,age=0:accuage,par=1:nmoves,yr=yrvec))
      for(iyr in 1:nyrs){
        y <- yrvec[iyr]
        for(imove in 1:nmoves){
          LabelA <- paste("MoveParm_A_",moveinfo$LabelBase2[imove],sep="")
          LabelB <- paste("MoveParm_B_",moveinfo$LabelBase2[imove],sep="")
          basevalueA <- movepars$Value[movepars$Label==LabelA]
          basevalueB <- movepars$Value[movepars$Label==LabelB]
          valueA <- MGparmAdj[[LabelA]][MGparmAdj$Year==y]
          valueB <- MGparmAdj[[LabelB]][MGparmAdj$Year==y]
          #print(c(imove,valueA,valueB))
          moveByYr[,,imove,iyr] <-
            movecalc(firstage = firstage,
                     accuage  = accuage,
                     minage   = rep(moveinfo$minage[imove],2),
                     maxage   = rep(moveinfo$maxage[imove],2),
                     valueA   = c(valueA,0),
                     valueB   = c(valueB,0),
                     from     = rep(moveinfo$Source_area[imove],2),
                     to       = c(moveinfo$Dest_area[imove],moveinfo$Source_area[imove]),
                     seasdur = 0.25
                     )
        }
      } # end loop over years to calculate moveByYr array

      # make plots
      cat("Warning! Time-varying movement plots are experimental and might be totally wrong\n")
      for(imove in 1:nmoves){
        Source_area <- moveinfo$Source_area[imove]
        Dest_area <- moveinfo$Dest_area[imove]
        movetable <- moveByYr[dimnames(moveByYr)$area==Dest_area, ,imove,]
        movetable <- moveByYr[1, ,imove,]
        main <- paste("Time-varying movement from area",Source_area,"to area",Dest_area)
        tempfun <- function(){
          mountains(zmat=t(movetable),xvec=0:accuage,yvec=yrvec,xlab='Age',ylab='Year')
          title(main=main,cex.main=cex.main)
        }
        
        if(plot) tempfun()
        if(print){
          file <- paste(plotdir,"/move2_time-varying_movement_rates.png",sep="")
          caption <- main
          plotinfo <- pngfun(file=file, caption=caption)
          tempfun()
          dev.off()
        }
      }
    }else{
      if(verbose) cat("  no time-varying movement--skipped SSplotMovementRates subplot 2\n")
    } # end check for time-varying movement
  } # end subplot 2
  returnlist <- list()
  if(!is.null(moveByYr))
    returnlist <- list(moveinfo=moveinfo, moveByYr=moveByYr)
  if(!is.null(plotinfo)){
    plotinfo$category <- "Move"
    returnlist$plotinfo <- plotinfo
  }
  return(invisible(returnlist))
}
