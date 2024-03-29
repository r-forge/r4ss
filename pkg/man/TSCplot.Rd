\name{TSCplot}
\alias{TSCplot}
%- Also NEED an '\alias' for EACH other topic documented here.

\title{
  Create a plot for the TSC report
}

\description{
  Creates a plot of catch and spawning biomass from the output of 
  \code{\link{SS_output}} for the NOAA TSC report.
}

\usage{
TSCplot(SSout,yrs="default",ylimBar="default",ylimDepl=c(0,1.025),
colBar="yellow",cexBarLabels=1.1,cex.axis=1.1,space=0.0,pchDepl=19,
colDepl="red",lwdDepl=3,shiftDepl = 0.25,pchSpace = 5,ht=4,wd=7,
labelLines=2.8,makePDF=NULL,makePNG=NULL,MCMC=F)
}
%- maybe also 'usage' for other objects documented here.

\arguments{
  \item{SSout}{
    The output from \code{\link{SS_output}}
  }
  \item{yrs}{
    The vector of years to plot
  }
  \item{ylimBar}{
    y-axis limits for catch barplot
  }
  \item{ylimDepl}{
    y-axis limits for depletion line
  }
  \item{colBar}{
    colors of the bars
  }
  \item{cexBarLabels}{
    character expansion for the labels underneath the bars (years)
  }
  \item{cex.axis}{
    character expansion for the axis labels
  }
  \item{space}{
    space between bars (see space argument of \code{barplot})
  }
  \item{pchDepl}{
    character type for points on the depletion line
  }
  \item{colDepl}{
    color of the points on the depletion line
  }
  \item{lwdDepl}{
    width of the depletion line
  }
  \item{shiftDepl}{
    shift from beginning of the year for the points on the depletion line. Helps to guide the eye for exactly which year it corresponds to.
  }
  \item{pchSpace}{
    number of years between points on the depletion line. Higher numbers help tidy up the plot when plotting many years.
  }
  \item{ht}{
    Height of the plot in inches
  }
  \item{wd}{
    Width of the plot in inches
  }
  \item{labelLines}{
    line argument for \code{mtext} to move the axis labels
  }
  \item{makePDF}{
    filename for a pdf file. If NULL it does not make a pdf.  Can specify a pdf filename or a png filename. Not both at the same time.
  }
  \item{makePNG}{
    filename for a png image. If NULL it does not make a png.  Can specify a pdf filename or a png filename. Not both at the same time.
  }
  \item{MCMC}{
    If TRUE, will use mcmc results. It needs a list element called 'mcmc' on SSout.
  }
}

\details{
It creates a plot on the current graphics device, in a pdf file, or as a png image of the figure used in the TSC report produced by the NWFSC.  
It expects the SS results read in by \code{\link{SS_output}}.  If MCMC results are to be plotted, a 'mcmc' list element should be added using the 
\code{\link{SSgetMCMC}} function. See the examples below.
}

\value{
  Returns a data frame with the years, spawning biomass, depletion, and total dead catch.

  %%  ~Describe the value returned
  %%  If it is a LIST, use
  %%  \item{comp1 }{Description of 'comp1'}
  %%  \item{comp2 }{Description of 'comp2'}
  %% ...
}

% \references{
%   %% ~put references to the literature/web site here ~
% }

\author{
  Allan Hicks
}

% \note{
% }

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{SS_output}}
  \code{\link{SSgetMCMC}}
}
\examples{
  \dontrun{
  ######################################
  #DO NOT RUN
    library(r4ss)
    update_r4ss_files()

    # ** CHANGE TO THE BASE DIRECTORY
    directory <- "C:\\NOAA2011\\Dover\\Models\\base_20110701"

    base <- SS_output(dir=directory,covar=F,verbose=F)

    #show the plot in R
    TSCplot(base)
    TSCplot(base,yrs=2000:2011,pchSpace = 1)
    #Create the plot as a PNG file
    TSCplot(base,makePNG="C:\\NOAA2012\\Assessments\\TSCdover.png")
    #Create the plot as a PDF file
    TSCplot(base,makePDF="C:\\NOAA2012\\Assessment\\TSCdover.pdf")

    # ** Hake model with MCMC results
    SSdir <- "C:/NOAA2012/Hake/Models"
    base <- SS_output(dir=paste(SSdir,"81_base_MCMC",sep="/"),covar=F)
    tmp <- SSgetMCMC(dir=paste(SSdir,"81_base_MCMC",sep="/"),writecsv=F)
    base$mcmc <- data.frame(tmp$model1)
    TSCplot(base,ylimDepl = c(0,1.25),pchSpace=1,MCMC=T)


  ###############################################
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ data }
\keyword{ manip }
\keyword{ list }
\keyword{ plot }
