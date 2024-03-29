\name{SS_plots}
\alias{SS_plots}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  plot many quantities related to output from Stock Synthesis
}
\description{
  Creates a user-chosen set of plots, including biological quantities,
  time series, and fits to data.  Plots are sent to R GUI, single PDF
  file, or multiple PNG files. This is now just a wrapper which calls on
  separate functions to make all the plots.
}
\usage{
SS_plots(
  replist=NULL, plot=1:24, print=NULL, pdf=FALSE, png=FALSE, html=png,
  printfolder="plots", dir="default", fleets="all", areas="all",
  fleetnames="default", fleetcols="default", fleetlty=1, fleetpch=1,
  lwd=1, areacols="default", areanames="default",
  verbose=TRUE, uncertainty=TRUE, forecastplot=FALSE,
  datplot=FALSE, Natageplot=TRUE, samplesizeplots=TRUE,
  compresidplots=TRUE, sprtarg="default", btarg="default",
  minbthresh="default", pntscalar=NULL,
  bub.scale.pearson=1.5,bub.scale.dat=3,pntscalar.nums=2.6,
  minnbubble=8, aalyear=-1, aalbin=-1, aalresids=FALSE, maxneff=5000,
  cohortlines=c(), smooth=TRUE, showsampsize=TRUE, showeffN=TRUE,
  showlegend=TRUE, pwidth=7, pheight=7, punits="in", ptsize=12, res=300,
  cex.main=1,selexlines=1:5, rows=1, cols=1, maxrows=6, maxcols=6,
  maxrows2=2, maxcols2=4, tagrows=3, tagcols=3, fixdims=TRUE, new=TRUE,
  SSplotDatMargin=8, filenotes=NULL, catchasnumbers=NULL,
  catchbars=TRUE, legendloc="topleft", minyr=NULL, maxyr=NULL,
  scalebins=FALSE, scalebubbles=FALSE,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{replist}{
    List created by \code{SS_output}
  }
  \item{plot}{
    Plot sets to be created, see list of plots below.  Use to
    specify only those plot sets of interest, e.g., c(1,2,5,10). Plots
    for data not available in the model run will automatically be
    skipped, whether called or not.
  }
  \item{print}{
    Deprecated input for backward compatability, now replaced by \code{png = TRUE/FALSE}.
  }
  \item{pdf}{
    Send plots to PDF file instead of R GUI?
  }
  \item{png}{
    Send plots to PNG files instead of R GUI?
  }
  \item{html}{
    Run \code{\link{SS_html}} on completion? By default has
    same value as \code{png}.
  }
  \item{printfolder}{
    Name of subfolder to create within the working
    directory into which any PNG files specified by \code{print} will be
    saved. By default the working directory is used with no subfolder.
    Default="".
  }
  \item{dir}{
    The directory in which any PNG files requested by
    \code{print} are created. By default it will be the same directory
    that the report file was read from by the \code{SS_output
    }
    function. Default="default".
  }
  \item{fleets}{
    Either the string "all", or a vector of numerical
    values, like c(1,3), listing fleets or surveys for which plots should
    be made. By default, plots will be made for all fleets and surveys.
    Default="all".
  }
  \item{areas}{
    Either the string "all", or a vector of numerical
    values, like c(1,3), listing areas for which plots should be made in
    a multi-area model. By default, plots will be made for all areas
    (excepting cases where the function has not yet been updated for
    multi-area models). Default="all".
  }
  \item{fleetnames}{
    Either the string "default", or a vector of
    characters strings to use for each fleet name. Default="default".
  }
  \item{fleetcols}{
    Either the string "default", or a vector of colors
    to use for each fleet.  Default="default".
  }
  \item{fleetlty}{
    Vector of line types used for each fleet in some
    plots. Default=1.
  }
  \item{fleetpch}{
    Vector of point types used for each fleet in some
    plots. Default=1.
  }
  \item{lwd}{
    Line width for some plots. Default=1.
  }
  \item{areacols}{
    Either the string "default", or a vector of colors
    to use for each area. Default="default".
  }
  \item{areanames}{
    Optional vector of names for each area used in
    titles. Default="default".
  }
  \item{verbose}{
    Return updates of function progress to the R GUI?
    Default=T.
  }
  \item{uncertainty}{
    Include values in plots showing estimates of
    uncertainty (requires positive definite hessian in model and
    \code{covar}=T in \code{SS_output})?  Default=T.
  }
  \item{forecastplot}{
    Include forecast years in the plots? Obviously
    requires forecast options to have been used in the model.  Default=T.
  }
  \item{datplot}{
    Plot the data by itself? This is useful in document
    preparation. Setting datplot=F is equivalent to leaving off plots 15
    and 16.  Default=F.
  }
  \item{Natageplot}{
    Plot the expected numbers at age bubble plots and
    mean-age time series?  Default=T.
  }
  \item{samplesizeplots}{
    Show sample size plots?  Default=T.
  }
  \item{compresidplots}{
    Show residuals for composition plots?
  }
  \item{sprtarg}{
    Specify the F/SPR proxy target. Default=0.4.
  }
  \item{btarg}{
    Target depletion to be used in plots showing
    depletion. May be omitted by setting to NA.  Default=0.4.
  }
  \item{minbthresh}{
    Threshold depletion to be used in plots showing
    depletion. May be omitted by setting to NA. Default=0.25.
  }
  \item{pntscalar}{
    This scalar defines the maximum bubble size for
    bubble plots. This option is still available but a better choice is
    to use bub.scale.pearson and bub.scale.dat, which are allow the same
    scaling throughout all plots.
  }
  \item{pntscalar.nums}{
    This scalar defines the maximum bubble size for
    numbers-at-age and numbers-at-length plots.
    
  }
  \item{bub.scale.pearson}{
    Character expansion (cex) value for a proportion of 1.0 in bubble plot of
    Pearson residuals. Default=1.5.
    
  }
  \item{bub.scale.dat}{
    Character expansion (cex) value for a proportion of 1.0 in bubble plot of
    composition data. Default=3.
    
  }
  \item{minnbubble}{
    This defines the minimum number of years below
    which blank years will be added to bubble plots to avoid cropping.
    Default=8.
  }
  \item{aalyear}{
    Years to plot multi-panel conditional age-at-length
    fits for all length bins; must be in a "c(YYYY,YYYY)" format. Useful
    for checking the fit of a dominant year class, critical time period,
    etc. Default=-1. 
  }
  \item{aalbin}{
    The length bin for which multi-panel plots of the fit
    to conditional age-at-length data will be produced for all years.
    Useful to see if growth curves are ok, or to see the information on
    year classes move through the conditional data. Default=-1. 
  }
  \item{aalresids}{
    Plot the full set of conditional age-at-length
    Pearson residuals? Default=F. 
  }
  \item{maxneff}{
    The maximum value to include on plots of input and
    effective sample size. Occasionally a calculation of effective N
    blows up to very large numbers, rendering it impossible to observe
    the relationship for other data. Default=5000. 
  }
  \item{cohortlines}{
    Optional vector of birth years for cohorts for
    which to add growth curves to numbers at length bubble plots.
    Default=c(). 
  }
  \item{smooth}{
    Add loess smoother to observed vs. expected index plots
    and input vs. effective sample size? Default=T. 
  }
  \item{showsampsize}{
    Display sample sizes on composition plots?
    Default=T. 
  }
  \item{showeffN}{
    Display effective sample sizes on composition plots?
    Default=T. 
  }
  \item{showlegend}{
    Display legends in various plots? Default=T. 
  }
  \item{pwidth}{
    Default width of plots printed to files in units of
    \code{punits}. Default=7. 
  }
  \item{pheight}{
    Default height width of plots printed to files in
    units of \code{punits}. Default=7. 
  }
  \item{punits}{
    Units for \code{pwidth} and \code{pheight}. Can be "px"
    (pixels), "in" (inches), "cm" or "mm". Default="in". 
  }
  \item{ptsize}{
    Point size for plotted text in plots printed to files
    (see help("png") in R for details). Default=12. } =
  \item{res}{
    Resolution of plots printed to files. Default=300. 
  }
  \item{cex.main}{
    Character expansion parameter for plot titles (not yet
    implemented for all plots). Default=1. 
  }
  \item{selexlines}{
    Vector controling which lines should be shown on
    selectivity plots if the model includes retention. Default=1:5. 
  }
  \item{rows}{
    Number of rows to use for single panel plots. Default=1. 
  }
  \item{cols}{
    Number of columns to use for single panel plots. Default=1. 
  }
  \item{maxrows}{
    Maximum number of rows to for multi-panel plots.
    Default=6. 
  }
  \item{maxcols}{
    Maximum number of columns for multi-panel plots.
    Default=6. 
  }
  \item{maxrows2}{
    Maximum number of rows for conditional age at length
    multi-panel plots. Default=2. 
  }
  \item{maxcols2}{
    Maximum number of rows for conditional age at length
    multi-panel plots. Default=4. 
  }
  \item{tagrows}{
    Number of rows for tagging-related plots. Default=3. 
  }
  \item{tagcols}{
    Number of columns for tagging-related plots.
    Default=3. 
  }
  \item{fixdims}{
    Control whether multi-panel plots all have dimensions
    equal to maxrows by maxcols, or resized within those limits to fit
    number of plots. Default=T. 
  }
  \item{new}{
    Open a new window or add to existing plot windows.
    Default=T. 
  }
  \item{SSplotDatMargin}{
    Size of right-hand margin in data plot (may be
    too small if fleet names are long) 
  }
  \item{filenotes}{
    Optional vector of character strings to be added to
    intro HTML page (if created) with notes about the model. 
  }
  \item{catchasnumbers}{
    Is catch input in numbers instead of biomass?
    Default=F. 
  }
  \item{catchbars}{
    show catch by fleet as barplot instead of stacked
    polygons (default=TRUE)  }  
  \item{legendloc}{
    Location for all legends. Default="topleft". 
  }
  \item{minyr}{
    First year to show in time-series plots
    (changes xlim parameters). 
  }
  \item{maxyr}{
    Last year to show in time-series plots
    (changes xlim parameters). 
  }
  \item{scalebins}{
    Rescale expected and observed proportions in composition plots by
    dividing by bin width for models where bins have different widths?
    Caution!: May not work correctly in all cases.
  }
  \item{scalebubbles}{
    scale data-only bubbles by sample size, not just proportion within
    sample? Default=FALSE.
  }
  \item{\dots}{
    Additional arguments that will be passed to some
    subfunctions. 
  }
}
% \details{
%   %%  ~~ If necessary, more details than the description above ~~
% }
% \value{
%   %%  ~Describe the value returned
%   %%  If it is a LIST, use
%   %%  \item{comp1 }{Description of 'comp1'}
%   %%  \item{comp2 }{Description of 'comp2'}
%   %% ...
% }
\references{
  Walters, Hilborn, and  Christensen, 2008, Surplus production dynamics
  in declining and recovering fish populations. Can. J. Fish. Aquat.
  Sci. 65: 2536-2551.
}
\author{
  Ian Stewart, Ian Taylor
}
% \note{
%   %%  ~~further notes~~
% }

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{SS_output}}, \code{\link{SSplotBiology}},
  \code{\link{SSplotCatch}}, \code{\link{SSplotComps}},
  \code{\link{SSplotDiscard}}, \code{\link{SSplotIndices}},
  \code{\link{SSplotMnwt}}, \code{\link{SSplotNumbers}},
  \code{\link{SSplotRecdevs}}, \code{\link{SSplotSelex}},
  \code{\link{SSplotSpawnrecruit}}, \code{\link{SSplotSPR}},
  \code{\link{SSplotTags}}, \code{\link{SSplotTimeseries}},
  \code{\link{SSplotYield}}
}
% \examples{
% }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ hplot }
