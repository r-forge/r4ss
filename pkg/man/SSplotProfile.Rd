\name{SSplotProfile}
\alias{SSplotProfile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Plot likelihood profile results
}
\description{
  Makes a plot of change in negative-log-likelihood for each likelihood
  component that contributes more than some minimum fraction of change in
  total.
}
\usage{
SSplotProfile(summaryoutput, plot = TRUE, print = FALSE,
models = "all", profile.string = "steep", profile.label =
"Spawner-recruit steepness (h)", ylab = "Change in -log-likelihood",
components = c("TOTAL", "Catch", "Equil_catch", "Survey", "Discard",
"Mean_body_wt", "Length_comp", "Age_comp", "Size_at_age", "SizeFreq",
"Morphcomp", "Tag_comp", "Tag_negbin", "Recruitment",
"Forecast_Recruitment", "Parm_priors", "Parm_softbounds", "Parm_devs",
"Crash_Pen"),
component.labels = c("Total", "Catch", "Equilibrium catch",
"Index data", "Discard", "Mean body weight", "Length data",
"Age data", "Size-at-age data", "Generalized size data",
"Morph composition data", "Tag recapture distribution",
"Tag recapture total", "Recruitment", "Forecast recruitment", "Priors",
"Soft bounds", "Parameter deviations", "Crash penalty"),
minfraction = 0.01,
sort.by.max.change = TRUE, col = "default", pch = "default", lty = 1,
lty.total = 1, lwd = 2, lwd.total = 3, cex = 1, cex.total = 1.5, xlim =
"default", ymax = "default", xaxs = "r", yaxs = "r", type = "o", legend
= TRUE, legendloc = "topright", pwidth = 7, pheight = 7, punits = "in",
res = 300, ptsize = 12, cex.main = 1, plotdir = NULL,
verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{summaryoutput}{
    List created by the function \code{\link{SSsummarize}}.
  }
  \item{plot}{
    Plot to active plot device?
  }
  \item{print}{
    Print to PNG files?
  }
  \item{models}{
    Optional subset of the models described in \code{summaryoutput}.
    Either "all" or a vector of numbers indicating columns in summary
    tables.
  }
  \item{profile.string}{
    Character string used to find parameter over which the profile was
    conducted. Needs to match substring of one of the SS parameter
    labels found in the Report.sso file. For instance, the default input
    'steep' matches the parameter 'SR_BH_steep'.
  }
  \item{profile.label}{
    Label for x-axis describing the parameter over which the profile was
    conducted.
  }
  \item{ylab}{
    Label for y-axis. Default is "Change in -log-likelihood".
  }
  \item{components}{
    Vector of likelihood components that may be included in plot. List is
    further refined by any components that are not present in model or
    have little change over range of profile (based on limit
    \code{minfraction}). Hopefully this doesn't need to be changed.
  }
  \item{component.labels}{
    Vector of labels for use in the legend that matches the vector in
    \code{components}.
  }
  \item{minfraction}{
    Minimum change in likelihood (over range considered) as a fraction
    of change in total likelihood for a component to be included in the
    figure.
  }
  \item{sort.by.max.change}{
    Switch giving option to sort components in legend in order of
    maximum amount of change in likelihood (over range considered).
    Default=TRUE.
  }
  \item{col}{
    Optional vector of colors for each line.
  }
  \item{pch}{
    Optional vector of plot characters for the points.
  }
  \item{lty}{
    Line total for the liklihood components.
  }
  \item{lty.total}{
    Line type for the total likelihood.
  }
  \item{lwd}{
    Line width for the liklihood components.
  }
  \item{lwd.total}{
    Line width for the total likelihood.
  }
  \item{cex}{
    Character expansion for the points representing the likelihood
    components.
  }
  \item{cex.total}{
    Character expansion for the points representing the total likelihood.
  }
  \item{xlim}{
    Range for x-axis. Change in likelihood is calculated relative to
    values within this range.
  }
  \item{ymax}{
    Maximum y-value. Default is 10\% greater than largest value plotted.
  }
  \item{xaxs}{
    The style of axis interval calculation to be used for the x-axis
    (see ?par for more info)
  }
  \item{yaxs}{
    The style of axis interval calculation to be used for the y-axis
    (see ?par for more info).
  }
  \item{type}{
    Line type (see ?plot for more info).
  }
  \item{legend}{
    Include legend?
  }
  \item{legendloc}{
    Location of legend (see ?legend for more info).
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
    Point size for PNG file
  }
  \item{cex.main}{
    Character expansion for plot titles
  }
  \item{plotdir}{
    Directory where PNG files will be written. by default it will
    be the directory where the model was run.
  }
  \item{verbose}{
    Return updates of function progress to the R GUI? (Doesn't do
    anything yet.)
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
  Ian Taylor, Ian Stewart
}
\note{
  Someday the function \code{\link{SS_profile}} will be improved and
  made to work directly with this plotting function, but they don't yet
  work well together. Thus, even if \code{\link{SS_profile}} is used,
  the output should be read using \code{\link{SSgetoutput}} or by
  multiple calls to \code{\link{SS_output}}.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{SSsummarize}}, \code{\link{SS_profile}},
  \code{\link{SS_output}}, \code{\link{SSgetoutput}}
}
% \examples{
%   \dontrun{

%   }

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ aplot }
\keyword{ hplot }% __ONLY ONE__ keyword per line
