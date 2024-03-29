\name{SS_profile}
\alias{SS_profile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Run a likelihood profile in Stock Synthesis. }
\description{
  Iteratively changes the control file using SS_changepars.
}
\usage{
SS_profile(dir = "C:/myfiles/mymodels/myrun/", masterctlfile =
  "control.ss_new", newctlfile = "control_modified.ss",
  linenum = NULL, string = NULL, profilevec = NULL,
  usepar = TRUE, dircopy = TRUE, exe.delete = FALSE,
  model = "ss3", extras = "-nox", systemcmd = FALSE, saveoutput = TRUE,
  overwrite = TRUE, verbose = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dir}{
    Directory where input files and executable are located.}
  \item{masterctlfile}{
    Source control file. Default = "control.ss_new"
  }
  \item{newctlfile}{
    Destination for new control files (must match entry
    in starter file). Default = "control_modified.ss".
  }
  \item{linenum}{
    Line number of parameter to be changed.
    Can be used instead of \code{string} or left as NULL.
  }
  \item{string}{
    String partially matching name of parameter to be
    changed. Can be used instead of \code{linenum} or left as NULL.
  }
  \item{usepar}{
    Use PAR file from previous profile step for starting
    values? NOT IMPLEMENTED YET.
  }
  \item{dircopy}{
    Copy directories for each run? NOT IMPLEMENTED YET.
  }
  \item{exe.delete}{
    Delete exe files in each directory?
    NOT IMPLEMENTED YET.
  }
  \item{profilevec}{
    Vector of values to profile over.  Default = NULL.
  }
  \item{model}{
    Name of executable. Default = "ss3".
  }
  \item{extras}{
    Additional commands to use when running SS. Default = "-nox" will
    reduce the amound of command-line output.
  }
  \item{systemcmd}{
    Should R call SS using "system" function intead of
    "shell". This may be required when running R in Emacs. Default = FALSE.
  }
  \item{saveoutput}{
    Copy output .SSO files to unique names.
    Default = TRUE.
  }
  \item{overwrite}{
    Overwrite any existing .SSO files.
  }
  \item{verbose}{
    Controls amount of info output to command line.
    Default = TRUE.
  }
}
% \details{
%   ~~ If necessary, more details than the description above ~~
% }
% \value{
%   ~Describe the value returned
%   If it is a LIST, use
%   \item{comp1 }{Description of 'comp1'}
%   \item{comp2 }{Description of 'comp2'}
%   ...
% }
% \references{ ~put references to the literature/web site here ~ }
\author{ Ian Taylor }
\note{
  The starting values used in this profile are not ideal and some models
  may not converge. Care should be taken in using an automated tool
  like this, and some models are likely to require rerunning with
  alternate starting values.

  Also, someday this function will be improved to work directly with the
  plotting function \code{\link{SSplotProfile}}, but they don't yet
  work well together. Thus, even if \code{\link{SS_profile}} is used,
  the output should be read using \code{\link{SSgetoutput}} or by
  multiple calls to \code{\link{SS_output}} before sending to
  \code{\link{SSplotProfile}}.
}
\seealso{
  \code{\link{SSplotProfile}}, \code{\link{SSgetoutput}},
  \code{\link{SS_changepars}}, \code{\link{SS_parlines}}
}
\examples{
  \dontrun{
# note: don't run this in your main directory
# make a copy in case something goes wrong
mydir <- "C:/ss/Simple - Copy"

# the following commands related to starter.ss could be done by hand
# read starter file
starter <- SS_readstarter(file.path(mydir, 'starter.ss'))
# change control file name in the starter file
starter$ctlfile <- "control_modified.ss"
# make sure the prior likelihood is calculated
# for non-estimated quantities
starter$prior_like <- 1
# write modified starter file
SS_writestarter(starter, dir=mydir, overwrite=TRUE)

# vector of values to profile over
h.vec <- seq(0.3,0.9,.1)
Nprofile <- length(h.vec)

# run SS_profile command
profile <- SS_profile(dir=mydir, # directory
                      # "NatM" is a subset of one of the
                      # parameter labels in control.ss_new
                      model="ss3_safe",
                      masterctlfile="control.ss_new",
                      newctlfile="control_modified.ss",
                      string="steep",
                      profilevec=h.vec)


# read the output files (with names like Report1.sso, Report2.sso, etc.)
profilemodels <- SSgetoutput(dirvec=mydir, keyvec=1:Nprofile)
# summarize output
profilesummary <- SSsummarize(profilemodels)

# OPTIONAL COMMANDS TO ADD MODEL WITH PROFILE PARAMETER ESTIMATED
MLEmodel <- SS_output("C:/ss/SSv3.24l_Dec5/Simple")
profilemodels$MLE <- MLEmodel
profilesummary <- SSsummarize(profilemodels)
# END OPTIONAL COMMANDS

# plot profile using summary created above
SSplotProfile(profilesummary,           # summary object
              profile.string = "steep", # substring of profile parameter
              profile.label="Stock-recruit steepness (h)") # axis label

# make timeseries plots comparing models in profile
SSplotComparisons(profilesummary,legendlabels=paste("h =",h.vec))

}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ data }
\keyword{ manip }
% \keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
