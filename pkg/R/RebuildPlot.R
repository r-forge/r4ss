DoProjectPlots<-function(dirn="C:/myfiles/",fileN=c("res.csv"),Titles="",ncols=200,
                         Plots=list(1:25),Options=list(c(1:9)),LegLoc="bottomright",
                         yearmax= -1,Outlines=c(2,2),OutlineMulti=c(2,2),
                         AllTraj=c(1,2,3,4),AllInd=c(1,2,3,4,5,6,7),
                         BioType="Spawning biomass",CatchUnit="(mt)",BioUnit="(mt)",
                         BioScalar=1,ColorsUsed="default",Labels="default",
                         pdf=FALSE,pwidth=7,pheight=7,lwd=2)
{
  if(pdf){
    pdffile <- paste(dirn,"/rebuild_plots_",format(Sys.time(),'%d-%b-%Y_%H.%M' ),".pdf",sep="")
    pdf(file=pdffile,width=pwidth,height=pheight)
    cat("PDF file with plots will be:",pdffile,'\n')
  }else{
    
    ### Note: the following line has been commented out because it was identified
    ###       by Brian Ripley as "against CRAN policies".
    #if(exists(".SavedPlots",where=1)) rm(.SavedPlots,pos=1)
    windows(record=T,width=pwidth,height=pheight)
  }
  
 rich.colors.short <- function(n){
    # a subset of rich.colors by Arni Magnusson from the gregmisc package
    x <- seq(0, 1, length = n)
    r <- 1/(1 + exp(20 - 35 * x))
    g <- pmin(pmax(0, -0.8 + 6 * x - 5 * x^2), 1)
    b <- dnorm(x, 0.25, 0.15)/max(dnorm(x, 0.25, 0.15))
    rgb.m <- matrix(c(r, g, b), ncol = 3)
    rich.vector <- apply(rgb.m, 1, function(v) rgb(v[1], v[2], v[3]))
  }


#  ==================================================================================================

Net_Spawn_Graph<-function(UUU,Amin,Amax,Title)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# Age Fecu")+1
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Amax*5-Amin),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Amax*5-Amin),2])
 plot(Xvals,Yvals,xlab="Age (years)",ylab="Net Spawning Output",lty=1,type='l',lwd=lwd,xaxs="i",yaxs="i",ylim=c(0,1.05*max(Yvals)))
 title(Title)

}

#  ==================================================================================================

RecruitmentPlots<-function(UUU,Title)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# Recruitments")+2
 Npnt <- as.double(UUU[Ipnt-1,1])
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),2])
 plot(Xvals,Yvals,xlab="Year",ylab="Recruitment",lty=1,type='l',lwd=lwd,yaxs="i",ylim=c(0,1.05*max(Yvals)))
 title(Title)

 Ipnt <- which(UUU=="# Recruits-per-spawner")+2
 Npnt <- as.double(UUU[Ipnt-1,1])
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),2])
 plot(Xvals,Yvals,xlab="Year",ylab=paste("Recruits \\ ",BioType,sep=""),lty=1,type='l',lwd=lwd,yaxs="i",ylim=c(0,1.05*max(Yvals)))

}
#  ==================================================================================================

B0Dist<-function(UUU,Title)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# B0 Dist")+1
 Xvals <- as.double(UUU[Ipnt:(Ipnt+19),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+19),2])
 plot(Xvals,Yvals,xlab=expression(B[0]),ylab="Relative Density",type='n',yaxs="i",ylim=c(0,1.05*max(Yvals)))
 Inc <- (Xvals[2]-Xvals[1])/2
 for (II in 1:20)
  {
   xx <- c(Xvals[II]-Inc,Xvals[II]-Inc,Xvals[II]+Inc,Xvals[II]+Inc)
   yy <- c(0,Yvals[II],Yvals[II],0)
   polygon(xx,yy,col="gray")
  }
 title(Title)

}

#  ==================================================================================================

RecHist<-function(UUU,Title)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# Recovery Histogram")+2
 Npnt <- as.double(UUU[Ipnt-1,1])
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),2])
 plot(Xvals,Yvals,xlab=expression(T[min] -Y[init]),ylab="Proportion of Simulations",type='n',yaxs="i",ylim=c(0,1.05*max(Yvals)))
 Inc <- (Xvals[2]-Xvals[1])/2
 for (II in 1:Npnt)
  {
   xx <- c(Xvals[II]-Inc,Xvals[II]-Inc,Xvals[II]+Inc,Xvals[II]+Inc)
   yy <- c(0,Yvals[II],Yvals[II],0)
   polygon(xx,yy,col="gray")
  }
 title(Title)

 Npnt <- as.double(UUU[Ipnt-1,2])
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),4])
 plot(Xvals,Yvals,xlab=expression(T[max] -Y[init]),ylab="Proportion of Simulations",type='n',yaxs="i",ylim=c(0,1.05*max(Yvals)))
 Inc <- (Xvals[2]-Xvals[1])/2
 for (II in 1:Npnt)
  {
   xx <- c(Xvals[II]-Inc,Xvals[II]-Inc,Xvals[II]+Inc,Xvals[II]+Inc)
   yy <- c(0,Yvals[II],Yvals[II],0)
   polygon(xx,yy,col="gray")
  }

}

# =============================================================================================================

AltStrategies<-function(FileN,UUUs,Options,Title,yearmax,Titles,cols=c("red","blue","green","orange","black","pink"))
{
 par(mfrow=c(OutlineMulti[1],OutlineMulti[2]))

 Ipnt <- which(UUUs[[1]]=="# Recovery Histogram")
 Tmax <- as.double(UUUs[[1]][Ipnt-1,1])
 Yinit <-as.double(UUUs[[1]][Ipnt-7,1])
 MinRev <-as.double(UUUs[[1]][Ipnt-10,1])
 Tmin <- MinRev+Yinit

 if (length(FileN) > 0)
  for (Ifile in 2:length(FileN))
   {
    Ipnt <- which(UUUs[[1]]=="# Recovery Histogram")
    Tmax2 <- as.double(UUUs[[1]][Ipnt-1,1])
    Yinit2 <-as.double(UUUs[[1]][Ipnt-7,1])
    MinRev2 <-as.double(UUUs[[1]][Ipnt-10,1])
    Tmin2 <- MinRev2+Yinit2
    if (Tmin != Tmin2)
     {
      stop("Tmin values in the different files don't match")
     }
   }

 NOpts <- 0
 for (Ifile in 1:length(FileN)) NOpts <- NOpts+ length(Options[[Ifile]])

 if (NOpts > 8) cat("WARNING - you have a large number of lines - perhaps create separate plots for subsets\n")

 Files <- NULL
 Opts <- NULL
 LastCatch <- NULL
 for (Ifile in 1:length(FileN))
  for (II in Options[[Ifile]])
   {
    Files <- c(Files,Ifile)
    Opts <- c(Opts,II)
    Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
     Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
     Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+10+II])
     LastCatch <- c(LastCatch,Yvals[length(Yvals)])
   }
 Xint <- sort.int(LastCatch,index.return=T)
 Files <- Files[Xint$ix]
 Opts <- Opts[Xint$ix]
 Labels <- Labels[Xint$ix]

 if (ColorsUsed[1] == "default") ColorsUsed <- rich.colors.short(NOpts)

 # get the x-axis right
 xmin <- 1.0e20
 xmax <- 0
 for (Ifile in 1:length(FileN))
  {
   Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
   Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
   Xvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),1])
   if (yearmax > 0)
    Use <- Xvals <= yearmax
   else
    Use <- rep(T,length=length(Xvals))
   Xvals <- Xvals[Use]
   if (min(Xvals) < xmin) xmin <- min(Xvals)
   if (max(Xvals) > xmax) xmax <- max(Xvals)
  }

 # define empty list to store values collected in loops below
 OutputList <- list(ProbRecovery=NULL,
                    Catch=NULL,
                    Depletion=NULL,
                    Bio=NULL)
 for (ii in AllTraj)
  {

   if (ii == 1)
    {
     plot(xmin,0,xlab="Year",ylab="Probability Above Target (%)",type='n',yaxs="i",ylim=c(0,105),xlim=c(xmin,xmax),axes=F)
     axis(1)
     axis(2,at=seq(0,100,25))
     box()
     IlineType <- 0
     
     for (Icnt in 1:NOpts)
      {
       Ifile <- Files[Icnt]
       II <- Opts[Icnt]
       IlineType <- IlineType + 1
       Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
       Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
       Xvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),1])
       Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+II])*100
       lines(Xvals,Yvals,lty=IlineType,col=ColorsUsed[IlineType],lwd=lwd)

       # store stuff in output list
       if(is.null(OutputList$ProbRecovery)) OutputList$ProbRecovery <- data.frame(Yr=Xvals)
       OutputList$ProbRecovery[,Icnt+1] <- Yvals
      }
     abline(h=50,lwd=3)
     abline(v=Tmin,lwd=1,lty=2)
     abline(v=Tmax,lwd=1,lty=2)
   }

   if (ii == 2)
    {
     ymax <- 0
     for (Ifile in 1:length(FileN))
      for (II in Options[[Ifile]])
       {
       Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
       Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
       Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+10+II])
       if (max(Yvals)  > ymax) ymax <- max(Yvals)
      }
     plot(xmin,0,xlab="Year",ylab=paste("Catch",CatchUnit),type='n',yaxs="i",ylim=c(0,1.05*ymax),xlim=c(xmin,xmax))
     IlineType <- 0
     for (Icnt in 1:NOpts)
      {
       Ifile <- Files[Icnt]
       II <- Opts[Icnt]
       IlineType <- IlineType + 1
       Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
       Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
       Xvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),1])
       Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+10+II])
       lines(Xvals,Yvals,lty=IlineType,col=ColorsUsed[IlineType],lwd=lwd)

       # store stuff in output list
       if(is.null(OutputList$Catch)) OutputList$Catch <- data.frame(Yr=Xvals)
       OutputList$Catch[,Icnt+1] <- Yvals
      }
    }

   if (ii == 3)
    {
     ymax <- 0
     for (Ifile in 1:length(FileN))
      for (II in Options[[Ifile]])
       {
        Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
        Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
        Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+20+II])*100
        if (max(Yvals)  > ymax) ymax <- max(Yvals)
       }
     plot(xmin,0,xlab="Year",ylab=paste(BioType,"\\ Target (x100)"),type='n',yaxs="i",ylim=c(0,1.05*ymax),xlim=c(xmin,xmax))
     IlineType <- 0
     for (Icnt in 1:NOpts)
      {
       Ifile <- Files[Icnt]
       II <- Opts[Icnt]
       IlineType <- IlineType + 1
       Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
       Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
       Xvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),1])
       Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+20+II])*100
       lines(Xvals,Yvals,lty=IlineType,col=ColorsUsed[IlineType],lwd=lwd)

       # store stuff in output list
       if(is.null(OutputList$Depletion)) OutputList$Depletion <- data.frame(Yr=Xvals)
       OutputList$Depletion[,Icnt+1] <- Yvals
      }
    }

   if (ii == 4)
    {
     ymax <- 0
     for (Ifile in 1:length(FileN))
      for (II in Options[[Ifile]])
       {
        Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
        Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
        Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+30+II])/BioScalar
        if (max(Yvals[Xvals<=xmax])  > ymax) ymax <- max(Yvals[Xvals<=xmax])
       }
     plot(xmin,0,xlab="Year",ylab=paste(BioType,BioUnit),type='n',yaxs="i",ylim=c(0,1.05*ymax),xlim=c(xmin,xmax))
     IlineType <- 0
     for (Icnt in 1:NOpts)
      {
       Ifile <- Files[Icnt]
       II <- Opts[Icnt]
       IlineType <- IlineType + 1
       Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
       Npnt <- as.double(UUUs[[Ifile]][Ipnt-2,1])
       Xvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),1])
       Yvals <- as.double(UUUs[[Ifile]][Ipnt:(Ipnt+Npnt-1),2+30+II])/BioScalar
       lines(Xvals,Yvals,lty=IlineType,col=ColorsUsed[IlineType],lwd=lwd)

       # store stuff in output list
       if(is.null(OutputList$Bio)) OutputList$Bio <- data.frame(Yr=Xvals)
       OutputList$Bio[,Icnt+1] <- Yvals
      }
     Jpnt <- which(UUUs[[1]]=="# Recruitments")-8
     B0 <- as.double(UUUs[[1]][Jpnt,1])
     abline(h=0.4*B0/BioScalar,lwd=1,lty=2)
     abline(h=0.25*B0/BioScalar,lwd=1,lty=2)
     cat('40% line at',0.4*B0/BioScalar,"\n")
     cat('25% line at',0.25*B0/BioScalar,"\n")
   }

   if (ii == AllTraj[1]) title(Title)
 }

 plot(0,0,xlab="",ylab="",axes=F,type="n",cex=0)

 Ltys <- NULL
 legs <- NULL
 IlineType <- 0
 col2 <- NULL
 for (Icnt in 1:NOpts)
  {
   Ifile <- Files[Icnt]
   II <- Opts[Icnt]
   Ipnt <- which(UUUs[[Ifile]]=="# Summary 1")+3
   titles <- UUUs[[Ifile]][Ipnt-1,3:11]

   IlineType <- IlineType + 1
   if (any(Labels == "default"))
    {
     titls <- titles[II]
     if (length(FileN) > 0) titls <- paste(Titles[Ifile],": ",titls,sep="")
    }
   else
    titls <- Labels[IlineType]

   legs <- c(legs, titls)
   Ltys <- c(Ltys,IlineType)
   col2 <- c(col2,ColorsUsed[IlineType])
  }

 legend(LegLoc,legend=legs,lty=Ltys,cex=1,col=col2,lwd=lwd)
 for(i in 1:4) if(!is.null(OutputList[[i]])) names(OutputList[[i]])[-1]  <- legs

 return(OutputList)
}
# =============================================================================================================

IndividualPlots<-function(UUU,Title,yearmax)
{
 par(mfrow=c(OutlineMulti[1],OutlineMulti[2]))

 Ipnt <- which(UUU=="# Individual")+2
 Npnt <- as.double(UUU[Ipnt-1,1])

 for (ii in AllInd)
  {

   if (ii==1) PlotA(UUU,0,"Spawning Output \\ Target",Ipnt,Npnt,yearmax,1)

   if (ii==2) PlotA(UUU,6,paste("Catch",CatchUnit),Ipnt,Npnt,yearmax,1)

   if (ii==3) PlotA(UUU,12,"Recruitment",Ipnt,Npnt,yearmax,1)

   if (ii==4) PlotA(UUU,18,expression(paste("Fishing Mortality ", (yr^-1))),Ipnt,Npnt,yearmax,1)

   if (ii==5) PlotA(UUU,24,paste("Exploitable Biomass",BioUnit),Ipnt,Npnt,yearmax,BioScalar)

   if (ii==6) PlotA(UUU,30,paste("Cumulative (discounted) Catch",CatchUnit),Ipnt,Npnt,yearmax,1)

   if (ii==7)
    {
     PlotA(UUU,36,"Spawning Biomass",Ipnt,Npnt,yearmax,BioScalar)
     Jpnt <- which(UUU=="# Recruitments")-8
     B0 <- as.double(UUU[Jpnt,1])
     abline(h=0.4*B0/BioScalar,lwd=1,lty=2)
     abline(h=0.25*B0/BioScalar,lwd=1,lty=2)
    }

  if (ii == AllInd[1]) title(Title)
 }
}

#  ==================================================================================================

PlotA <- function(UUU,offset,title,Ipnt,Npnt,yearmax,BioScalar)
{
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 if (yearmax > 0)
  Use <- Xvals <= yearmax
 else
  Use <- rep(T,length=length(Xvals))
 Xvals <- Xvals[Use]

 Y1 <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),offset+2])/BioScalar
 Y2 <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),offset+3])/BioScalar
 Y3 <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),offset+4])/BioScalar
 Y4 <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),offset+5])/BioScalar
 Y5 <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),offset+6])/BioScalar

 ymax <- max(Y5[Use])*1.1
 plot(Xvals,Y5[Use],xlab="Year",ylab=title,type='n',yaxs="i",ylim=c(0,ymax))
 XX <- c(Xvals,rev(Xvals))
 polygon(XX,c(Y1[Use],rev(Y5[Use])),col="lightgray")
 polygon(XX,c(Y2[Use],rev(Y4[Use])),col="gray")
 lines(Xvals,Y3[Use],lty=1,lwd=4)

}

#  ==================================================================================================

FirstFive<-function(UUU,Title,yearmax)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# Individual")+2
 Npnt <- as.double(UUU[Ipnt-1,1])

 Ipnt <- which(UUU=="# First Five")+1
 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 if (yearmax > 0)
  Use <- Xvals <= yearmax
 else
  Use <- rep(T,length=length(Xvals))
 Xvals <- Xvals[Use]

 ymax <- 0
 for (II in 1:5)
  {
   Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1+II])
   if (max(Yvals[Use])  > ymax) ymax <- max(Yvals[Use])
  }
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),2])
 plot(Xvals,Yvals[Use],xlab="Year",ylab="Spawning Output \\ Target",type='n',yaxs="i",ylim=c(0,1.05*ymax))
 for (II in 1:5)
  {
   Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1+II])
   lines(Xvals,Yvals[Use],lty=II)
  }
 title(Title)

}

#  ==================================================================================================

FinalRecovery<-function(UUU,Title)
{
 par(mfrow=c(Outlines[1],Outlines[2]))

 Ipnt <- which(UUU=="# Final Recovery")+2
 Npnt <- as.double(UUU[Ipnt-1,1])
 Npnt <- Npnt - 1

 Xvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),1])
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),3])
 ymax <- max(Yvals)
 plot(Xvals,Yvals,xlab="Year",ylab="Proportion of Simulations",type='n',yaxs="i",ylim=c(0,1.4*ymax))

 Inc <- (Xvals[2]-Xvals[1])/2
 for (II in 1:Npnt)
  {
   xx <- c(Xvals[II]-Inc,Xvals[II]-Inc,Xvals[II]+Inc,Xvals[II]+Inc)
   yy <- c(0,Yvals[II],Yvals[II],0)
   polygon(xx,yy,col="gray")
  }
 Yvals <- as.double(UUU[Ipnt:(Ipnt+Npnt-1),6])*ymax*1.2
 lines(Xvals,Yvals,lty=1,lwd=5,col="red")
 title(Title)


}
#  ==================================================================================================

 UUUs <- vector("list",5)
 for (Ifile in 1:length(fileN))
  {

   FileName <- paste(dirn,fileN[Ifile],sep="\\")
   cat("FileName:",FileName,"\n")
   UUU <- read.table(file=FileName,col.names=1:ncols,fill=T,
                     colClasses="character",comment.char="$",sep=",")
   UUUs[[Ifile]] <- UUU

   # Extract key parameters
   Nsim <- as.double(UUU[3,1])
   Amin <- as.double(UUU[4,1])
   Amax <- as.double(UUU[5,1])
   Nsex <- as.double(UUU[6,1])
   RecType <- as.double(UUU[7,1])
   Ncatch <- as.double(UUU[8,1])
   Ioutput <- as.double(UUU[9,1])

   # Plot Age versus fecudity
   if (1 %in% Plots[[Ifile]]) Net_Spawn_Graph(UUU,Amin,Amax,Titles[Ifile])

   # Recruitment and Recruits/Spawners
   if (2 %in% Plots[[Ifile]]) RecruitmentPlots(UUU,Titles[Ifile])

   # Histogram of B0
   if (3 %in% Plots[[Ifile]]) B0Dist(UUU,Titles[Ifile])

   # Histogram of recovery times
   if (4 %in% Plots[[Ifile]]) RecHist(UUU,Titles[Ifile])

   #Individual plots
   if (6 %in% Plots[[Ifile]]) IndividualPlots(UUU,Titles[Ifile],yearmax)

   # First five trajectories of SSB/target
   if (7 %in% Plots[[Ifile]]) FirstFive(UUU,Titles[Ifile],yearmax)

   # Plot of when recovery occurs
   if (8 %in% Plots[[Ifile]]) FinalRecovery(UUU,Titles[Ifile])

  }

 # Results across strategies
 DoStrategies <- F
 for (Ifile in 1:length(fileN))
  if (5 %in% Plots[[Ifile]]) DoStrategies <- T
 if (DoStrategies==T) OutputList <- AltStrategies(fileN,UUUs,Options,"",yearmax,Titles)

 if(pdf) dev.off()
 if (DoStrategies==T) return(invisible(OutputList))
}

# ================================================================================================================


 ## # Plots - set to get specific plots
 ## # Options - set to get specific strategies in the trajectory plots

 ## Titles <- c("Res1","Res2","Res3")
 ## Plots <- list(c(1:9),c(6:7))
 ## Options = list(c(7:9,3),c(5,7))
 ## DoProjectPlots(fileN=c("res1.csv","res2.csv"),Titles=Titles,Plots=Plots,Options=Options,LegLoc="bottomleft",yearmax=-1,Outlines=c(2,2),OutlineMulti=c(3,3),AllTraj=c(1:4),AllInd=c(1:7),
 ##                BioType="Spawning numbers",BioUnit="(lb)",BioScalar=1000,CatchUnit="(lb)",ColorsUse=rep(c("red","blue"),5),Labels=c("A","B","C","D","E","F"))
