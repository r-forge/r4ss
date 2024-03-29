SSsummarize <- function(biglist,
                        keyvec=NULL,
                        numvec=NULL,
                        sizeselfactor="Lsel",
                        ageselfactor="Asel",
                        selfleet=NULL,
                        selyr="startyr",
                        selgender=1,
                        SpawnOutputUnits=NULL,
                        lowerCI=0.025,
                        upperCI=0.975){

  # a bunch of 'key' related stuff is more for Ian T's simulation work
  # the goal is to be able to extract a subset of the models in biglist in
  # a particular order as defined by a vector of strings used to rename model
  # output files. It can be ignored in general.

  if(is.null(names(biglist))) names(biglist) <- paste("replist",1:length(biglist),sep="")
  biglistkeys <- substring(names(biglist),8)
  if(length(biglistkeys)==0 | any(is.null(biglistkeys))) biglistkeys <- 1:length(biglist)

  ## check inputs in keyvec or numvec
  # too many inputs
  if(!is.null(keyvec) & !is.null(numvec))
    stop("don't input both 'keyvec' and 'numvec'")
  if(!is.null(keyvec) & is.null(numvec)){
    # if only keyvec is supplied, check to make sure it works
    if(length(setdiff(keyvec,biglistkeys)) > 0)
      stop("'keyvec' should include strings that follow 'replist_' in names(biglist)")
    n <- length(keyvec)
  }
  if(is.null(keyvec) & !is.null(numvec)){
    # if only numvec is supplied, check to make sure it works
    if(length(setdiff(numvec,1:length(biglist))) > 0)
      stop("'numvec' should include indices of elements of biglist")
    n <- length(numvec)
  }
  # no inputs to subset elements
  if(is.null(keyvec) & is.null(numvec)){
    keyvec <- substring(names(biglist),8)
    n <- length(biglist)
    if(length(keyvec)==0 | any(is.null(keyvec))) keyvec <- 1:n
  }

  # loop over outputs to create list of parameters, derived quantities, and years
  parnames <- NULL
  dernames <- NULL
  likenames <- NULL
  allyears <- NULL

  for(imodel in 1:n){
    element <- (1:length(biglist))[biglistkeys==keyvec[imodel]]
    if(length(element)!=1)
      stop("keyvec problem, element =",element,"\n",
           "keyvec[imodel] =",keyvec[imodel])
    stats <- biglist[[element]]
    parnames <- union(parnames,stats$parameters$Label)
    dernames <- union(dernames,stats$derived_quants$LABEL)
    allyears <- union(allyears,stats$timeseries$Yr)
    likenames <- union(likenames,rownames(stats$likelihoods_used))
  }
  allyears <- sort(allyears) # not actually getting any timeseries stuff yet

  # objects to store quantities
  pars <- parsSD <- parphases <- as.data.frame(matrix(NA,nrow=length(parnames),ncol=n))
  quants <- quantsSD <- as.data.frame(matrix(NA,nrow=length(dernames),ncol=n))
  growth     <- NULL
  maxgrad    <- NULL
  nsexes     <- NULL
  likelihoods <- likelambdas <- as.data.frame(matrix(NA,nrow=length(likenames),ncol=n))
  likelihoods_by_fleet <- NULL
  indices    <- NULL
  sizesel    <- NULL
  agesel     <- NULL
  # notes about what runs were used
  sim        <- NULL
  keyvec2    <- NULL
  listnames  <- NULL
  npars      <- NULL
  startyrs   <- NULL
  endyrs     <- NULL
  
  warn <- FALSE # flag for whether filter warning has been printed or not

  # loop over models within biglist
  for(imodel in 1:n){
    element <- (1:length(biglist))[biglistkeys==keyvec[imodel]]
    stats <- biglist[[element]]
    listname <- names(biglist)[element]

    key <- as.character(stats$key)
    if(length(key)==0 || is.null(key) || is.na(key)) key <- imodel
    keyvec2 <- c(keyvec2,key)
    cat("imodel=",imodel,"/",n,", element=",element,",",substring("      ",nchar(imodel)+nchar(element)),"got ", listname,sep="")

    # gradient
    maxgrad <- c(maxgrad, stats$maximum_gradient_component)

    # nsexes
    nsexes <- c(nsexes, stats$nsexes)

    # start and end years
    startyrs <- c(startyrs, stats$startyr)
    endyrs   <- c(endyrs,   stats$endyr)
    
    # size selectivity
    sizeseltemp <- stats$sizeselex
    if(is.null(sizeselfactor)) sizeselfactor <- unique(sizeseltemp$Factor)
    for(iselfactor in 1:length(sizeselfactor)){
      seltemp_i <- sizeseltemp[sizeseltemp$Factor==sizeselfactor[iselfactor],]
      seltemp_i$imodel <- imodel
      seltemp_i$key <- key
      # if sizesel is not NULL, then check for whether columns of new addition match existing file
      if(is.null(sizesel) || (ncol(seltemp_i)==ncol(sizesel) && all(names(seltemp_i)==names(sizesel)))){
        sizesel <- rbind(sizesel,seltemp_i)
      }else{
        cat("problem summarizing size selectivity due to mismatched columns (perhaps different bins)\n")
      }
    }
    rownames(sizesel) <- 1:nrow(sizesel)

    # age selectivity
    ageseltemp  <- stats$ageselex
    if(is.null(ageselfactor)) ageselfactor <- unique(ageseltemp$Factor)
    for(iselfactor in 1:length(ageselfactor)){
      seltemp_i <- ageseltemp[ageseltemp$factor==ageselfactor[iselfactor],]
      seltemp_i$imodel <- imodel
      seltemp_i$key <- key
      # if agesel is not NULL, then check for whether columns of new addition match existing file
      if(is.null(agesel) || (ncol(seltemp_i)==ncol(agesel) && all(names(seltemp_i)==names(agesel)))){
        agesel <- rbind(agesel,seltemp_i)
      }else{
        cat("problem summarizing age selectivity due to mismatched columns (perhaps different bins)\n")
      }
    }
    rownames(agesel) <- 1:nrow(agesel)

    
    ## growth (females only)
    growthtemp <- stats$growthseries
    imorphf <- ifelse(max(stats$morph_indexing$Index)==10,3,1)
    growthtemp <- growthtemp[growthtemp$Morph==imorphf,-(1:4)]
    growth <- cbind(growth, as.numeric(growthtemp[nrow(growthtemp),]))

    ## likelihoods
    liketemp <- stats$likelihoods_used
    for(irow in 1:nrow(liketemp)){
      likelihoods[likenames==rownames(liketemp)[irow], imodel] <- liketemp$values[irow]
      likelambdas[likenames==rownames(liketemp)[irow], imodel] <- liketemp$lambdas[irow]
    }
    liketemp2 <- data.frame(model=imodel,stats$likelihoods_by_fleet)
    if(is.null(likelihoods_by_fleet) ||
       (ncol(likelihoods_by_fleet)==ncol(liketemp2) &&
         all(names(likelihoods_by_fleet)==names(liketemp2)))){
      likelihoods_by_fleet <- rbind(likelihoods_by_fleet,liketemp2)
    }else{
      cat("\nproblem summarizing likelihoods by fleet due to mismatched columns\n")
    }

    ## compile parameters
    parstemp <- stats$parameters
    for(ipar in 1:nrow(parstemp)){
      pars[parnames==parstemp$Label[ipar], imodel] <- parstemp$Value[ipar]
      parsSD[parnames==parstemp$Label[ipar], imodel] <- parstemp$Parm_StDev[ipar]
      parphases[parnames==parstemp$Label[ipar], imodel] <- parstemp$Phase[ipar]
    }
    cat(",  N active pars=",sum(!is.na(parstemp$Active_Cnt)),"\n",sep="")
    
    ## compile derived quantities
    quantstemp <- stats$derived_quants
    for(iquant in 1:nrow(quantstemp)){
      quants[dernames==quantstemp$LABEL[iquant], imodel] <- quantstemp$Value[iquant]
      quantsSD[dernames==quantstemp$LABEL[iquant], imodel] <- quantstemp$StdDev[iquant]
    }

    ## indices
    indextemp <- stats$cpue
    indextemp$Model <- keyvec2[imodel]
    indextemp$imodel <- imodel
    if(is.null(indices) || ncol(indextemp)==ncol(indices)){
      indices <- rbind(indices, indextemp)
    }else{
      cat("problem summarizing indices due to mismatched columns\n")
    }

    # number of parameters
    npars <- c(npars, stats$N_estimated_parameters)

    # 2nd fecundity parameter indicates whether spawning output is proportional to biomass
    if(!is.null(SpawnOutputUnits)){
      # if 1 value is input, repeate n times
      if(length(SpawnOutputUnits)==1) SpawnOutputUnits <- rep(SpawnOutputUnits,n)
      # if total doesn't currently equal n, stop everything
      if(length(SpawnOutputUnits)!=n)
        stop("'SpawnOutputUnits' should have length = 1 or",n)
    }else{
      # if NULL, then make vector of NA values
      SpawnOutputUnits <- rep(NA,n)
    }
    # if NA value in vector for current model, replace with value from model
    if(is.na(SpawnOutputUnits[imodel]))
      if(stats$FecPar2==0){
        SpawnOutputUnits[imodel] <- "biomass"
      }else{
        SpawnOutputUnits[imodel] <- "numbers"
      }
  } # end loop over models

  if(!setequal(keyvec,keyvec2)){
    cat("problem with keys!\nkeyvec:\n")
    print(keyvec)
    cat("keyvec2:\n")
    print(keyvec2)
  }else{
    names(pars) <- names(parsSD) <- keyvec2
    names(quants) <- names(quantsSD) <- keyvec2
    names(likelihoods) <- names(likelambdas) <- keyvec2
  }
  pars$Label <- parsSD$Label <- parphases$Label <- parnames
  quants$Label <- quantsSD$Label <- dernames
  likelihoods$Label <- likelambdas$Label <- likenames
  # extract year values from labels for some parameters associated with years
  pars$Yr <- NA
  for(ipar in 1:nrow(pars)){
    substrings <- strsplit(as.character(pars$Label[ipar]),"_")[[1]]
    yr <- substrings[substrings %in% allyears][1]
    pars$Yr[ipar] <- ifelse(is.null(yr), NA, as.numeric(yr))
  }

  quants$Yr <- quantsSD$Yr <- NA
  for(iquant in 1:nrow(quants)){
    substrings <- strsplit(as.character(quants$Label[iquant]),"_")[[1]]
    yr <- substrings[substrings %in% allyears][1]
    quants$Yr[iquant] <- ifelse(is.null(yr), NA, as.numeric(yr))
    quantsSD$Yr[iquant] <- ifelse(is.null(yr), NA, as.numeric(yr))
  }


  # identify spawning biomass parameters
  SpawnBio <- quants[grep("SPB_",quants$Label), ]
  SpawnBioSD <- quantsSD[grep("SPB_",quants$Label), ]
  # add year values for Virgin and Initial years
  minyr <- min(SpawnBio$Yr,na.rm=TRUE)
  SpawnBio$Yr[grep("SPB_Virgin",SpawnBio$Label)] <- minyr - 2
  SpawnBio$Yr[grep("SPB_Initial",SpawnBio$Label)] <- minyr - 1
  SpawnBioSD$Yr <- SpawnBio$Yr

  SpawnBio <- SpawnBio[order(SpawnBio$Yr),]
  SpawnBioSD <- SpawnBioSD[order(SpawnBioSD$Yr),]
  if(any(is.na(SpawnBio[3,]))){
    cat("Models have different start years, so SpawnBio values in VIRG & INIT yrs are shifted to correct year\n")
    SpawnBio$Label[1:2] <- c("SPB_Virgin*","SPB_Initial*")
    SpawnBioSD$Label[1:2] <- c("SPB_Virgin*","SPB_Initial*")
    for(imodel in 1:n){ 
      if(is.na(SpawnBio[3,imodel])){
        minyr <- min(SpawnBio$Yr[-(1:2)][!is.na(SpawnBio[-(1:2),imodel])]) # first year with value
        SpawnBio[SpawnBio$Yr==minyr-2, imodel] <- SpawnBio[1,imodel]
        SpawnBio[SpawnBio$Yr==minyr-1, imodel] <- SpawnBio[2,imodel]
        SpawnBio[1:2,imodel] <- NA
        SpawnBioSD[SpawnBio$Yr==minyr-2, imodel] <- SpawnBioSD[1,imodel]
        SpawnBioSD[SpawnBio$Yr==minyr-1, imodel] <- SpawnBioSD[2,imodel]
        SpawnBioSD[1:2,imodel] <- NA
      }
    }
  }
  
  SpawnBioLower <- SpawnBioUpper <- SpawnBioSD
  SpawnBioLower[,1:n] <- qnorm(p=lowerCI, mean=as.matrix(SpawnBio[,1:n]),
                               sd=as.matrix(SpawnBioSD[,1:n]))
  SpawnBioUpper[,1:n] <- qnorm(p=upperCI, mean=as.matrix(SpawnBio[,1:n]),
                               sd=as.matrix(SpawnBioSD[,1:n]))

  # identify biomass ratio parameters
  Bratio <- quants[grep("^Bratio_",quants$Label),]
  BratioSD <- quantsSD[grep("^Bratio_",quantsSD$Label),]

  BratioLower <- BratioUpper <- BratioSD
  BratioLower[,1:n] <- qnorm(p=lowerCI, mean=as.matrix(Bratio[,1:n]),
                             sd=as.matrix(BratioSD[,1:n]))
  BratioUpper[,1:n] <- qnorm(p=upperCI, mean=as.matrix(Bratio[,1:n]),
                             sd=as.matrix(BratioSD[,1:n]))

  # identify biomass ratio parameters
  SPRratio <- quants[grep("^SPRratio_",quants$Label),]
  SPRratioSD <- quantsSD[grep("^SPRratio_",quantsSD$Label),]

  SPRratioLower <- SPRratioUpper <- SPRratioSD
  SPRratioLower[,1:n] <- qnorm(p=lowerCI, mean=as.matrix(SPRratio[,1:n]),
                             sd=as.matrix(SPRratioSD[,1:n]))
  SPRratioUpper[,1:n] <- qnorm(p=upperCI, mean=as.matrix(SPRratio[,1:n]),
                             sd=as.matrix(SPRratioSD[,1:n]))
  
  # identify recruitment parameters and their uncertainty
  recruits <- quants[grep("^Recr_",quants$Label), ]
  recruitsSD <- quantsSD[grep("^Recr_",quantsSD$Label), ]
  if(length(grep("Recr_Unfished",recruits$Label))>0)
    recruits <- recruits[-grep("Recr_Unfished",recruits$Label),]
  if(length(grep("Recr_Unfished",recruitsSD$Label))>0)
    recruitsSD <- recruitsSD[-grep("Recr_Unfished",recruitsSD$Label),]
  minyr <- min(recruits$Yr,na.rm=TRUE)
  
  recruits$Yr[grep("Recr_Virgin",recruits$Label)] <- minyr - 2
  recruits$Yr[grep("Recr_Initial",recruits$Label)] <- minyr - 1
  recruitsSD$Yr[grep("Recr_Virgin",recruitsSD$Label)] <- minyr - 2
  recruitsSD$Yr[grep("Recr_Initial",recruitsSD$Label)] <- minyr - 1
  recruits <- recruits[order(recruits$Yr),]
  recruitsSD <- recruitsSD[order(recruitsSD$Yr),]
  if(any(is.na(recruits[3,]))){
    cat("Models have different start years, so recruits values in VIRG & INIT yrs are shifted to correct year\n")
    recruits$Label[1:2] <- c("Recr_Virgin*","Recr_Initial*")
    for(imodel in 1:n){ 
      if(is.na(recruits[3,imodel])){
        minyr <- min(recruits$Yr[-(1:2)][!is.na(recruits[-(1:2),imodel])]) # first year with value
        recruits[recruits$Yr==minyr-2, imodel] <- recruits[1,imodel]
        recruits[recruits$Yr==minyr-1, imodel] <- recruits[2,imodel]
        recruits[1:2,imodel] <- NA
        recruitsSD[recruitsSD$Yr==minyr-2, imodel] <- recruitsSD[1,imodel]
        recruitsSD[recruitsSD$Yr==minyr-1, imodel] <- recruitsSD[2,imodel]
        recruitsSD[1:2,imodel] <- NA
      }
    }
  }
  recruitsLower <- recruitsUpper <- recruitsSD
  recruitsLower[,1:n] <- qnorm(p=lowerCI, mean=as.matrix(recruits[,1:n]),
                               sd=as.matrix(recruitsSD[,1:n]))
  recruitsUpper[,1:n] <- qnorm(p=upperCI, mean=as.matrix(recruits[,1:n]),
                               sd=as.matrix(recruitsSD[,1:n]))

  # identify parameters that are recruitment deviations
  pars$recdev <- FALSE
  pars$recdev[grep("RecrDev",pars$Label)] <- TRUE
  pars$recdev[grep("InitAge",pars$Label)] <- TRUE
  pars$recdev[grep("ForeRecr",pars$Label)] <- TRUE

  # if there are any initial age parameters, figure out what year they're from
  InitAgeRows <- grep("InitAge",pars$Label)
  if(length(InitAgeRows)>0){
    temp <- unlist(strsplit(pars$Label[InitAgeRows],"InitAge_")) # separate out values from string
    InitAgeVals <- as.numeric(temp[seq(2,length(temp),2)]) # get odd entries in above separation
    InitAgeYrs <- matrix(NA,nrow=length(InitAgeRows),ncol=n)
    for(imodel in 1:n){
      modelpars <- pars[,imodel]
      devyears <- pars$Yr[!is.na(modelpars) & pars$recdev]
      if(any(!is.na(devyears))) minyr <- min(devyears,na.rm=TRUE) else minyr <- NA
      good <- !is.na(modelpars[InitAgeRows])
      if(!is.na(minyr) & minyr>0 & any(good)) InitAgeYrs[good,imodel] <- minyr - InitAgeVals[good]
    }
    # check for differences in assignment of initial ages
    if(any(apply(InitAgeYrs,1,max,na.rm=TRUE) - apply(InitAgeYrs,1,min,na.rm=TRUE) != 0)){
      cat("warning: years for InitAge parameters are differ between models, use InitAgeYrs matrix\n")
    }else{
      pars$Yr[InitAgeRows] <- apply(InitAgeYrs,1,max,na.rm=TRUE)
    }
  }else{
    InitAgeYrs <- NA
  }
  if(any(pars$recdev)){
    recdevs <- pars[pars$recdev,]
    recdevsSD <- parsSD[pars$recdev,]
    myorder <- order(recdevs$Yr) # save order for use in both values and SDs
    recdevs <- recdevs[myorder,1:(n+2)]
    recdevsSD <- recdevsSD[myorder,1:(n+1)]
    recdevsSD$Yr <- recdevs$Yr
    recdevsLower <- recdevsUpper <- recdevsSD
    recdevsLower[,1:n] <- qnorm(p=lowerCI, mean=as.matrix(recdevs[,1:n]),
                                sd=as.matrix(recdevsSD[,1:n]))
    recdevsUpper[,1:n] <- qnorm(p=upperCI, mean=as.matrix(recdevs[,1:n]),
                                sd=as.matrix(recdevsSD[,1:n]))
  }else{
    recdevs <- recdevsSD <- recdevsLower <- recdevsUpper <- NULL
  }
  
  mylist <- list()
  mylist$n              <- n
  mylist$npars          <- npars
  mylist$listnames      <- names(biglist)
  mylist$keyvec         <- keyvec
  mylist$maxgrad        <- maxgrad
  mylist$nsexes         <- nsexes
  mylist$startyrs       <- startyrs
  mylist$endyrs         <- endyrs
  mylist$pars           <- pars
  mylist$parsSD         <- parsSD
  mylist$parphases      <- parphases
  mylist$quants         <- quants
  mylist$quantsSD       <- quantsSD
  mylist$likelihoods    <- likelihoods
  mylist$likelambdas    <- likelambdas
  mylist$likelihoods_by_fleet <- likelihoods_by_fleet
  mylist$SpawnBio       <- SpawnBio
  mylist$SpawnBioSD     <- SpawnBioSD
  mylist$SpawnBioLower  <- SpawnBioLower
  mylist$SpawnBioUpper  <- SpawnBioUpper
  mylist$Bratio         <- Bratio
  mylist$BratioSD       <- BratioSD
  mylist$BratioLower    <- BratioLower
  mylist$BratioUpper    <- BratioUpper
  mylist$SPRratio       <- SPRratio
  mylist$SPRratioSD     <- SPRratioSD
  mylist$SPRratioLower  <- SPRratioLower
  mylist$SPRratioUpper  <- SPRratioUpper
  mylist$recruits       <- recruits
  mylist$recruitsSD     <- recruitsSD
  mylist$recruitsLower  <- recruitsLower
  mylist$recruitsUpper  <- recruitsUpper
  mylist$recdevs        <- recdevs
  mylist$recdevsSD      <- recdevsSD
  mylist$recdevsLower   <- recdevsLower
  mylist$recdevsUpper   <- recdevsUpper
  mylist$growth         <- growth
  mylist$sizesel        <- sizesel
  mylist$agesel         <- agesel
  mylist$indices        <- indices
  mylist$InitAgeYrs     <- InitAgeYrs
  mylist$lowerCI        <- lowerCI
  mylist$upperCI        <- upperCI
  mylist$SpawnOutputUnits <- SpawnOutputUnits
  #mylist$lbinspop   <- as.numeric(names(stats$sizeselex)[-(1:5)])
  
  return(mylist)
} # end function
