\name{SSplotCohorts}
\alias{SSplotCohorts}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Plot cumulative catch by cohort.
}
\description{
  Cumulative catch contributions for each cohort are plotted based on
  estimated catch-at-age matrix and weight-at-age values by fleet.
  Curves are shown in units of both numbers and biomass.
}
\usage{
SSplotCohorts(replist,subplots=1:2,add=FALSE,
           plot=TRUE,print=FALSE,
           cohortcols="default",
           cohortfrac=1,
           cohortvec=NULL,
           cohortlabfrac=0.1,
           cohortlabvec=NULL,
           lwd=3, 
           plotdir="default",
           xlab="Year",
           labels=c("Age",
             "Cumulative catch by cohort (in numbers x1000)",
             "Cumulative catch by cohort (x1000 mt)"),
           pwidth=7,pheight=7,punits="in",res=300,ptsize=12,
           cex.main=1,
           verbose=TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{replist}{
    List created by \code{SS_output}
  }
  \item{subplots}{
    Vector controlling which subplots to create
  }
  \item{add}{
    Add to existing plot? (not yet implemented)
  }
  \item{plot}{
    Plot to active plot device?
  }
  \item{print}{
    Print to PNG files?
  }
  \item{cohortcols}{
    Vector of colors to show for each cohort. Default is range of colors
    shade indicating time period.
  }
  \item{cohortfrac}{
    What fraction of the cohorts to include in plot. If value < 1 is
    used, then cohorts are filtered to only include those with the
    highest maximum cumulative catch. Value will be overridden by
    \code{cohortvec}.
  }
  \item{cohortvec}{
    Optional vector of birth years for cohorts to include in plot. Value
    overrides \code{cohortfrac}.
  }
  \item{cohortlabfrac}{
    What fraction of the cohorts to label in plot. By default, top
    10\% of cohorts are labeled. Value will be overridden by
    \code{cohortlabvec}.
  }
  \item{cohortlabvec}{
    Optional vector of birth years for cohorts to label in plot. Value
    overrides \code{cohortlabfrac}.
  }
  \item{lwd}{
    Line width
  }
  \item{plotdir}{
    Directory where PNG or PDF files will be written. By default it will
    be the directory where the model was run.
  }
  \item{xlab}{
    x-label for all plots
  }
  \item{labels}{
    Vector of labels for plots (titles and axis labels)
  }
  \item{pwidth}{
    Width of plot written to PNG file
  }
  \item{pheight}{
    Height of plot written to PNG file
  }
  \item{punits}{
    Units for PNG file
  }
  \item{res}{
    Resolution for PNG file
  }
  \item{ptsize}{
    ptsize for PNG file
  }
  \item{cex.main}{
    Character expansion for plot titles (no titles in this function yet)
  }
  \item{verbose}{
    Report progress to R console?
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
% \references{
%   %% ~put references to the literature/web site here ~
% }
\author{
  Ian Taylor
}
% \note{
%   %%  ~~further notes~~
% }

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{SS_plots}}, \code{\link{SS_output}}
}
% \examples{
% }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ aplot }
\keyword{ hplot }% __ONLY ONE__ keyword per line
