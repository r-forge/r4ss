\name{SSplotTags}
\alias{SSplotTags}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Plot tagging data and fits
}
\description{
  Plot observed and expected tag recaptures in aggregate and by tag group.
}
\usage{
SSplotTags(replist = replist, subplots = 1:8, latency = 0, rows = 1,
cols = 1, tagrows = 3, tagcols = 3, plot = TRUE, print = FALSE,
pntscalar = 2.6, minnbubble = 8, pwidth = 7, pheight = 7, punits = "in",
ptsize = 12, res = 300, cex.main = 1, col1 = "blue", col2 = "red",
col3 = "grey95", col4 = "grey70", 
labels = c("Year", "Frequency", "Tag Group",
           "Fit to tag recaptures by tag group",
           "Tag recaptures aggregated across tag groups",
           "Observed tag recaptures by year and tag group",
           "Residuals for tag recaptures: (obs-exp)/sqrt(exp)",
           "Observed and expected tag recaptures by year and tag group"),
plotdir = "default", verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{replist}{
    list created by \code{SS_output}
  }
  \item{subplots}{
    vector controlling which subplots to create
  }
  \item{latency}{
    period of tag mixing to exclude from plots (in future could be
    included in SS output)
  }
  \item{rows}{
    number or rows of panels for regular plots
  }
  \item{cols}{
    number or columns of panels for regular plots
  }
  \item{tagrows}{
    number or rows of panels for multi-panel plots
  }
  \item{tagcols}{
    number or columns of panels for multi-panel plots
  }
  \item{plot}{
    plot to active plot device?
  }
  \item{print}{
    print to PNG files?
  }
  \item{pntscalar}{
    maximum bubble size for
    balloon plots; each plot scaled independently based on this maximum
    size and the values plotted. Often some plots look better with one
    value and others with a larger or smaller value. Default=2.6
  }
  \item{minnbubble}{
    minimum number of years below
    which blank years will be added to bubble plots to avoid cropping
  }
  \item{pwidth}{
    default width of plots printed to files in units of \code{punits}. Default=7.
  }
  \item{pheight}{
    default height width of plots printed to files in units of \code{punits}. Default=7.
  }
  \item{punits}{
    units for \code{pwidth} and \code{pheight}. Can be "px" (pixels), "in" (inches), "cm" or "mm". Default="in".
  }
  \item{ptsize}{
    point size for plotted text in plots printed to files (see help("png") in R for details). Default=12.
  }
  \item{res}{
    resolution of plots printed to files. Default=300
  }
  \item{cex.main}{
    character expansion parameter for plot titles
  }
  \item{col1}{
    color for bubbles
  }
  \item{col2}{
    color for lines with expected values
  }
  \item{col3}{
    shading color for observations within latency period
  }
  \item{col4}{
    shading color for observations after latency period
  }
  \item{labels}{
    vector of labels for plots (titles and axis labels)
  }
  \item{plotdir}{
    directory where PNG files will be written. by default it will
    be the directory where the model was run.
  }
  \item{verbose}{
    return updates of function progress to the R GUI?
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
  Andre Punt, Ian Taylor
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
\keyword{ hplot }
