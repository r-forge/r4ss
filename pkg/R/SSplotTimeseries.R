SSplotTimeseries <-
  function(replist,subplot,add=FALSE,areas="all",
           areacols="default",areanames="default",
           forecastplot=TRUE,uncertainty=TRUE,bioscale="default",
           minyr=NULL,maxyr=NULL,
           plot=TRUE,print=FALSE,plotdir="default",verbose=TRUE,
           btarg="default",minbthresh="default",xlab="Year",
           labels=NULL,
           pwidth=7,pheight=7,punits="in",res=300,ptsize=12,cex.main=1)
{

  # individual function for plotting time series of total or summary biomass
  # subplot1 = total biomass total all areas
  # subplot2 = total biomass by area
  # subplot3 = total biomass in all areas in spawning season
  # subplot4 = summary biomass total all areas
  # subplot5 = summary biomass by area
  # subplot6 = summary biomass in all areas in spawning season
  # subplot7 = spawning biomass total (with or without uncertainty)
  # subplot8 = spawning biomass by area
  # subplot9 = spawning depletion total (with or without uncertainty)
  # subplot10 = spawning depletion by area
  # subplot11 = recruitment total (with or without uncertainty)
  # subplot12 = recruitment by area
  # subplot13 = fraction of recruitment by area
  # subplot14 = recruitment by birth season
  # subplot15 = fraction of recruitment by birth season
  if(missing(subplot)) stop("'subplot' input required")
  if(length(subplot)>1) stop("function can only do 1 subplot at a time")
  pngfun <- function(file,caption=NA){
    png(filename=file,width=pwidth,height=pheight,
        units=punits,res=res,pointsize=ptsize)
    plotinfo <- rbind(plotinfo,data.frame(file=file,caption=caption))
    return(plotinfo)
  }
  plotinfo <- NULL

  # get values from replist
  SS_versionshort <- replist$SS_versionshort
  timeseries     <- replist$timeseries
  nseasons       <- replist$nseasons
  spawnseas      <- replist$spawnseas
  birthseas      <- replist$birthseas
  startyr        <- replist$startyr
  endyr          <- replist$endyr
  nsexes         <- replist$nsexes
  nareas         <- replist$nareas
  derived_quants <- replist$derived_quants
  FecPar2        <- replist$FecPar2
  B_ratio_denominator <- replist$B_ratio_denominator
  seasfracs      <- replist$seasfracs
  recruitment_dist <- replist$recruitment_dist

  if(btarg=="default") btarg <- replist$btarg
  if(minbthresh=="default") minbthresh <- replist$minbthresh
  
  if(areacols[1]=="default"){
    areacols  <- rich.colors.short(nareas)
    if(nareas > 2) areacols <- rich.colors.short(nareas+1)[-1]
  }
  if(!is.null(birthseas)){
    nbirthseas <- length(birthseas)
    seascols <- rich.colors.short(nbirthseas)
    if(nbirthseas > 2) seascols <- rich.colors.short(nbirthseas+1)[-1]
  }
  
  # temporary fix for SS_output versions prior to 9/20/2010
  if(is.null(B_ratio_denominator)) B_ratio_denominator <- 1
  
  # check if spawning output rather than spawning biomass is plotted
  if(plotdir=="default") plotdir <- replist$inputs$dir
  if(FecPar2!=0) labels[5] <- labels[7]

  # check area subsets
  if(areas[1]=="all"){
    areas <- 1:nareas
  }else{
    if(length(intersect(areas,1:nareas))!=length(areas))
      stop("Input 'areas' should be 'all' or a vector of values between 1 and nareas.")
  }
  if(nareas>1 & areanames[1]=="default"){
    areanames <- paste("area",1:nareas)
  }

  #scaling factor for single sex models
  if(bioscale=="default"){
    if(nsexes==1) bioscale <- 0.5 else bioscale <- 1
  }
  # modifying data to subset for a single season
  ts <- timeseries
  if(nseasons>1){
    if(SS_versionshort=="SS-V3.11"){
      ts$YrSeas <- ts$Yr + (ts$Seas-1)/nseasons
    }else{
      ts$YrSeas <- ts$Yr + seasfracs
    }
  }else{
    ts$YrSeas <- ts$Yr
  }

  # warn about spawning season--seems to no longer be necessary now that title
  # is update for to reflect spawning season
  ## if(spawnseas>1 & subplot %in% c(3,6,7,8,9,10) ){
  ##   cat("Note: spawning seems to be in season ",spawnseas,". Some plots will show only this season.\n",sep="") 
  ## }

  # define which years are forecast or not
  ts$period <- "time"
  ts$period[ts$Yr < startyr] <- "equilibria"
  ts$period[ts$Yr > endyr+1] <- "fore"

  if(!forecastplot) ts$period[ts$Yr > endyr + 1] <- "exclude"

  # a function to make the plot
  biofunc <- function(subplot){
    # make the logical vector of which time-series entries to use
    plot1 <- ts$Area==1 & ts$Era=="VIRG" # T/F for in area & is virgin value
    plot2 <- ts$Area==1 & ts$period=="time" & ts$Era!="VIRG" # T/F for in area & not virgin value
    plot3 <- ts$Area==1 & ts$period=="fore" & ts$Era!="VIRG" # T/F for in area & not virgin value
    if(subplot %in% c(3,6,7,9)){
      plot1 <- ts$Area==1 & ts$Era=="VIRG" & ts$Seas == spawnseas # T/F for in area & is virgin value
      plot2 <- ts$Area==1 & ts$period=="time" & ts$Era!="VIRG" & ts$Seas == spawnseas # T/F for in area & not virgin value
      plot3 <- ts$Area==1 & ts$period=="fore" & ts$Era!="VIRG" & ts$Seas == spawnseas # T/F for in area & not virgin value
    }

    # switch for which column of the TIME_SERIES table is being plotted
    # subplot1,2,3 = total biomass
    if(subplot %in% 1:3){
      yvals <- ts$Bio_all
      ylab <- labels[1]
      if(subplot==3){ylab <- paste(labels[2],spawnseas)}
    }
    # subplot4,5,6 = summary biomass
    if(subplot %in% 4:6){
      yvals <- ts$Bio_smry
      ylab <- labels[3]
      if(subplot==6){ylab <- paste(labels[4],spawnseas)}
    }
    # subplot7&8 = spawning biomass
    if(subplot %in% 7:8){
      yvals <- bioscale*ts$SpawnBio
      ylab <- labels[5]
    }
    # subplot9&10 = spawning depletion
    if(subplot %in% 9:10){
      # yvals for spatial models are corrected later within loop over areas
      yvals <- ts$SpawnBio/ts$SpawnBio[!is.na(ts$SpawnBio)][1]
      ylab <- labels[6]
    }

    # subplot11&12 = recruitment
    if(subplot %in% 11:15){
      yvals <- ts$Recruit_0
      ylab <- labels[8]
    }

    # change ylab to represent fractions for those plots
    if(subplot %in% c(13,15)) ylab <- labels[9]
       
    # title initially set equal to y-label
    main=ylab

    # birth season-related calculations
    yrshift <- 0 # years of shift for fish spawning to next birth season
    if(!is.null(birthseas) && max(birthseas) < spawnseas){
      # case where fish are born in the year after spawning
      yrshift <- 1
    }
    if(!is.null(birthseas) && nbirthseas > 1){
      if(subplot==11){
        # sum total recruitment across birth seasons
        for(y in ts$Yr){
          yvals[ts$Yr==y & ts$Seas==1] <- sum(yvals[ts$Yr==y],na.rm=TRUE)
          yvals[ts$Yr==y & ts$Seas >1] <- 0
        }
      }
      if(subplot==15){
        # sum total recruitment across birth seasons
        for(y in ts$Yr){
          yvals[ts$Yr==y] <- yvals[ts$Yr==y]/sum(yvals[ts$Yr==y],na.rm=TRUE)
        }
      }
      if(subplot %in% c(14,15)) main=paste(main,"by birth season")
    }
    
    # sum up total across areas if needed
    if(nareas>1){
      if(subplot %in% c(2,3,5,6,8,10,12,13)){
        # these plots have separate lines for each area
        main=paste(main,"by area")
      }
      if(subplot %in% c(1,4,7,11,13)){
        # these plots have sum across areas
        yvals2 <- rep(NA,length(ts$YrSeas))
        for(iyr in 1:length(yvals)){
          y <- ts$YrSeas[iyr]
          yvals2[iyr] <- sum(yvals[ts$YrSeas==y])
        }
        if(subplot==13){
          yvals <- yvals/yvals2
        }else{
          yvals <- yvals2
        }
      }
      if(subplot==9){
        # sum up total across areas differently for spawning depletion
        yvals2 <- rep(NA,length(ts$YrSeas))
        for(iyr in 1:length(yvals)){
          y <- ts$YrSeas[iyr]
          yvals[iyr] <- sum(ts$SpawnBio[ts$YrSeas==y])
        }
        yvals <- yvals/yvals[!is.na(yvals)][1] # total depletion
      }
      ymax <- max(yvals,1,na.rm=TRUE)

      # correct ymax value for plot 10 (other plots may need it too)
      if(subplot==10){
        for(iarea in 1:nareas){
          yvals <- ts$SpawnBio[ts$Area==iarea]/(ts$SpawnBio[ts$Area==iarea & ts$Seas == spawnseas][1])
          ymax <- max(ymax,yvals,na.rm=TRUE)
        }
      }
    }
    if(subplot==10){
      yvals[1] <- NA
    }
    
    if(forecastplot) main <- paste(main,"with forecast")
    # calculating intervals around spawning biomass, depletion, or recruitment
    # area specific confidence intervals?
    if(uncertainty & subplot %in% c(7,9,11)){
      main <- paste(main,"with ~95% asymptotic intervals")
      if(!"SPB_Virgin" %in% derived_quants$LABEL){
        cat("Skipping spawning biomass with uncertainty plot because 'SPB_Virgin' not in derived quantites.\n",
            "  Try changing 'min yr for Spbio_sdreport' in starter file to -1.\n")
      }else{
        # get subset of DERIVED_QUANTITIES
        if(subplot==7){ # spawning biomass
          stdtable <- derived_quants[grep("SPB_Virgin",derived_quants[,1]):(grep("Recr_Virgin",derived_quants[,1])-1),1:3]
          # year as part of the LABEL string starting with 5th character
          stdtable$Yr <- substring(stdtable$LABEL,5)
          # filling in Virgin and Initial years as 2 and 1 years prior to following years
          stdtable$Yr[1:2] <- as.numeric(stdtable$Yr[3])-(2:1)  - yrshift
          stdtable$Yr <- as.numeric(stdtable$Yr)
        }
        if(subplot==9){ # spawning depletion
          stdtable <- derived_quants[substring(derived_quants$LABEL,1,6)=="Bratio",]
          stdtable$Yr <- as.numeric(substring(stdtable$LABEL,8))

          ### these temporary fixes now replaced using "B_ratio_denominator"
          ## if(abs(stdtable$Value[1] - 4)<.1) bioscale <- 1/4 # temporary fix
          ## if(abs(stdtable$Value[1] - 2.5)<.1) bioscale <- 1/2.5 # temporary fix
          bioscale <- B_ratio_denominator
        }
        if(subplot==11){ # recruitment
          stdtable <- derived_quants[substring(derived_quants$LABEL,1,5)=="Recr_",]
          stdtable <- stdtable[stdtable$LABEL!="Recr_Unfished",]
          # year as the part of the LABEL string starting with 6th character
          stdtable$Yr <- substring(stdtable$LABEL,6)
          # filling in Virgin and Initial years as 2 and 1 years prior to following years
          stdtable$Yr[1:2] <- as.numeric(stdtable$Yr[3])-(2:1)
          stdtable$Yr <- as.numeric(stdtable$Yr) + yrshift
          bioscale <- 1
        }

        # scaling and calculation of confidence intervals
        v <- stdtable$Value * bioscale
        std <- stdtable$StdDev * bioscale
        if(subplot==11){
          # assume recruitments have log-normal distribution 
          # from first principals (multiplicative survival probabilities)
          stdtable$logint <- sqrt(log(1+(std/v)^2))
          stdtable$lower <- exp(log(v) - 1.96*stdtable$logint)
          stdtable$upper <- exp(log(v) + 1.96*stdtable$logint)
        }else{ # assume normal distribution matching internal assumptions of ADMB
          stdtable$upper <- v + 1.96*std
          stdtable$lower <- pmax(v - 1.96*std, 0) # max of value or 0
        }
        if(max(stdtable$Yr) < max(floor(ts$YrSeas))){
          cat("  !warning:\n",
              "   ",max(stdtable$Yr),"is last year with uncertainty in Report file, but",max(ts$YrSeas),"is last year of time series.\n",
              "    Consider changing starter file input for 'max yr for sdreport outputs' to -2\n")
        }
      }
    }

    # improved y-range for plot (possibly excluding time periods that aren't plotted)
    #   only works on single area models
    if(nareas==1){
      ymax <- max(yvals[plot1 | plot2 | plot3], na.rm=TRUE)
    }
    if(subplot%in%c(13,15)) ymax <- 1 # these plots show fractions
    
    if(uncertainty & subplot %in% c(7,9,11)) ymax <- max(ymax,stdtable$upper, na.rm=TRUE)

    if(print){ # if printing to a file
      # adjust file names
      filename <- main
      filename <- gsub(",","",filename,fixed=TRUE)
      filename <- gsub("~","",filename,fixed=TRUE)
      filename <- gsub("%","",filename,fixed=TRUE)
      if(forecastplot) filename <- paste(filename,"forecast")
      if(uncertainty & subplot %in% c(5,7,9)) filename <- paste(filename,"intervals")
      filename <- paste("ts",subplot," ",filename,".png",sep="")
      filename <- paste(plotdir,filename,sep="")
      # if(verbose) cat("printing plot to file:",filename,"\n")
      plotinfo <- pngfun(file=filename,caption=main)
    }

    # move VIRG value from startyr-2 to startyr-1 to show closer to plot
    # this one didn't work:   if(exists("stdtable")) stdtable$Yr[stdtable$Yr %in% ts$Yr[plot1]] <- stdtable$Yr[stdtable$Yr %in% ts$Yr[plot1]]+1
    ts$Yr[ts$Era=="VIRG"] <- ts$Yr[ts$Era=="VIRG"]+1
    ts$YrSeas[ts$Era=="VIRG"] <- ts$YrSeas[ts$Era=="VIRG"]+1
    
             
    # create an empty plot (if not adding to existing plot)
    if(!add){
      yrvals  <- ts$YrSeas[ plot1 | plot2 | plot3]
      # axis limits
      if(is.null(minyr)) minyr <- min(yrvals)
      if(is.null(maxyr)) maxyr <- max(yrvals)
      xlim <- c(minyr,maxyr)
      plot(yrvals,yvals[plot1 | plot2 | plot3],
           type='n', xlab=xlab, ylim=c(0,ymax), ylab=ylab,
           main=main, cex.main=cex.main,xlim=xlim)
      abline(h=0,col="grey")
    }

    # add references points to plot of depletion
    if(subplot %in% c(9,10))
    {
      addtarg <- function(){
        if(btarg>0 & btarg<1){
          abline(h=btarg,col="red")
          text(max(startyr,minyr)+4,btarg+0.03,labels[10],adj=0)
        }
        if(minbthresh>0 & minbthresh<1){
          abline(h=minbthresh,col="red")
          text(max(startyr,minyr)+4,minbthresh+0.03,labels[11],adj=0)
        }
      }
      addtarg()
    }
    # add references points to plot of abundance
    if(subplot %in% 7:9)
    {
      addtarg <- function(){
        if(btarg>1){
          abline(h=btarg,col="red")
          text(max(startyr,minyr)+4,btarg+0.02*diff(par()$usr[3:4]),
               labels[10],adj=0)
        }
        if(minbthresh>1){
          abline(h=minbthresh,col="red")
          text(max(startyr,minyr)+4,minbthresh+0.02*diff(par()$usr[3:4]),
               labels[11],adj=0)
        }
      }
      addtarg()
    }
    if(subplot %in% 14:15){
      # these plots show lines for each birth season,
      # but probably won't work if there are multiple birth seasons and multiple areas
      for(iseas in 1:nbirthseas){
        s <- birthseas[iseas]
        mycol <- seascols[iseas]
        mytype <- "o" # overplotting points on lines for most time series
        plot1 <- ts$Seas==s & ts$Era=="VIRG"  # T/F for in seas & is virgin value
        plot2 <- ts$Seas==s & ts$period=="time" & ts$Era!="VIRG" # T/F for in seas & not virgin value
        plot3 <- ts$Seas==s & ts$period=="fore" & ts$Era!="VIRG" # T/F for in seas & is forecast
        points(ts$Yr[plot1],yvals[plot1],pch=19,  col=mycol) # filled points for virgin conditions
        lines(ts$Yr[plot2],yvals[plot2],type=mytype,col=mycol) # open points and lines in middle
        points(ts$Yr[plot3],yvals[plot3],pch=19,  col=mycol) # filled points for forecast
      }
      legend("topright",legend=paste("Season",birthseas),lty=1,pch=1,col=seascols,bty="n")
    }else{
      # always loop over areas, but for plots with only one line,
      # change vector of areas to equal 1.
      if(subplot %in% c(1,4,7,9,11,14,15)) myareas <- 1 else myareas <- areas     
      for(iarea in myareas){ # loop over chosen areas
        ###
        # subset for time period to allow different colors in plot
        #   plot1 = subset for equilibrium (virgin) values
        #   plot2 = subset for main timeseries
        #   plot3 = subset for forecast
        ###
        if(subplot==10){
          yvals <- ts$SpawnBio/(ts$SpawnBio[ts$Area==iarea & ts$Seas == spawnseas][1])
        }
        if(subplot %in% c(3,6,7,8,9,10)){
          plot1 <- ts$Area==iarea & ts$Era=="VIRG" & ts$Seas == spawnseas # T/F for in area & is virgin value
          plot2 <- ts$Area==iarea & ts$period=="time" & ts$Era!="VIRG" & ts$Seas == spawnseas # T/F for in area & not virgin value
          plot3 <- ts$Area==iarea & ts$period=="fore" & ts$Era!="VIRG" & ts$Seas == spawnseas # T/F for in area & not virgin value
        }else{
          plot1 <- yvals>0 & ts$Area==iarea & ts$Era=="VIRG" # T/F for in area & is virgin value
          plot2 <- yvals>0 & ts$Area==iarea & ts$period=="time" & ts$Era!="VIRG" # T/F for in area & not virgin value
          plot3 <- yvals>0 & ts$Area==iarea & ts$period=="fore" & ts$Era!="VIRG" # T/F for in area & not virgin value
        }
        if(subplot %in% 9:10){
          plot1 <- NULL
          plot2[3] <- FALSE
        }
        mycol <- areacols[iarea]
        mytype <- "o" # overplotting points on lines for most time series
        if(subplot==11 & uncertainty) mytype <- "p" # just points without connecting lines if plotting recruitment with confidence intervals
        if(!uncertainty){
          points(ts$YrSeas[plot1],yvals[plot1],pch=19,  col=mycol) # filled points for virgin conditions
          lines( ts$YrSeas[plot2],yvals[plot2],type=mytype,col=mycol) # open points and lines in middle
          points(ts$YrSeas[plot3],yvals[plot3],pch=19,  col=mycol) # filled points for forecast
        }else{
          # add lines for confidence intervals areas if requested
          # lines and points on integer years
          points(ts$Yr[plot1],yvals[plot1],pch=19,  col=mycol) # filled points for virgin conditions
          lines( ts$Yr[plot2],yvals[plot2],type=mytype,col=mycol) # open points and lines in middle
          points(ts$Yr[plot3],yvals[plot3],pch=19,  col=mycol) # filled points for forecast
          if(subplot %in% c(7,9,11)){
            # subset years for confidence intervals
            if(subplot==7){
              plot1 <- stdtable$LABEL=="SPB_Virgin"
              stdtable$Yr[plot1] <- stdtable$Yr[plot1]+yrshift
            }
            if(subplot==9){
              plot1 <- stdtable$LABEL=="Bratio_Virgin" # note: this doesn't exist
            }
            if(subplot==11){
              plot1 <- stdtable$LABEL=="Recr_Virgin"
              stdtable$Yr[plot1] <- stdtable$Yr[plot1]+1 # shifting as in other cases to make Virgin year adjacent to first year of timeseries
            }
            plot2 <- stdtable$Yr %in% ts$Yr[plot2]
            plot3 <- stdtable$Yr %in% ts$Yr[plot3]
            plotall <- plot1 | plot2 | plot3
            ## stdtable$plot1 <- plot1
            ## stdtable$plot2 <- plot2
            ## stdtable$plot3 <- plot3
          }
          if(subplot %in% c(7,9)){
            # add lines for main period
            lines(stdtable$Yr[plot2], stdtable$upper[plot2], lty=2, col=mycol)
            lines(stdtable$Yr[plot2], stdtable$lower[plot2], lty=2, col=mycol)

            # add dashes for early period
            points(stdtable$Yr[plot1]+1, stdtable$upper[plot1], pch="-", col=mycol) # +1 is because VIRG was shifted right 1 year
            points(stdtable$Yr[plot1]+1, stdtable$lower[plot1], pch="-", col=mycol) # +1 is because VIRG was shifted right 1 year

            # add dashes for forecast period
            points(stdtable$Yr[plot3], stdtable$upper[plot3], pch="-", col=mycol)
            points(stdtable$Yr[plot3], stdtable$lower[plot3], pch="-", col=mycol)
          }
          if(subplot==11){ # confidence intervals as error bars because recruitment is more variable
            old_warn <- options()$warn      # previous setting
            options(warn=-1)                # turn off "zero-length arrow" warning
            arrows(x0=stdtable$Yr[plotall], y0=stdtable$lower[plotall], y1=stdtable$upper[plotall],
                   length=0.01, angle=90, code=3, col=mycol)
            options(warn=old_warn)  #returning to old value
          }
        } # end if uncertainty
      } # end loop over areas
      if(nareas>1 & subplot%in%c(2,3,5,6,8,10,12)) legend("topright",legend=areanames[areas],lty=1,pch=1,col=areacols[areas],bty="n")
    } # end test for birthseason plots or not
    if(verbose) cat("  finished time series subplot ",subplot,": ",main,"\n",sep="")
    if(print) dev.off()
    return(plotinfo)
  } # end biofunc

  # make plots
  # for(iplot in subplot){ # doesn't work for more than one subplota at a time
  skip <- FALSE
  # plots 2, 5, 8, 10, and 12 are redundant for 1-area models
  if(nareas==1 & subplot %in% c(2,5,8,10,12:13)) skip <- TRUE
  # plots 3 and 6 are redundant for 1-season models
  if(nseasons==1 & subplot %in% c(3,6)) skip <- TRUE
  if(subplot %in% c(14:15) & (is.null(birthseas) || nbirthseas==1)) skip <- TRUE

  if(!skip){
    plotinfo <- biofunc(subplot=subplot)
    if(!is.null(plotinfo)) plotinfo$category <- "Timeseries"
    return(invisible(plotinfo))
  }
}
