\name{SS_makedatlist}
\alias{SS_makedatlist}
\title{
  make a list for SS data
}
\description{
  create a list similar to those built by \code{\link{SS_readdat}} which
  can be written to a Stock Synthesis data file using
  \code{\link{SS_writedat}}. In hindsight, this function doesn't seem
  very useful and I haven't taken time to describe the arguments below.
}
\usage{
SS_makedatlist(styr = 1971, endyr = 2001, nseas = 1, months_per_seas =
12, spawn_seas = 1, Nfleet = 1, Nsurveys = 1, N_areas = 1, fleetnames =
c("fishery1", "survey1"), surveytiming = 0.5, areas = 1, units_of_catch
= 1, se_log_catch = 0.01, Ngenders = 2, Nages = 40, init_equil = 0,
catch = NULL, CPUE = NULL, N_discard_fleets = 0, discard_data = NULL,
meanbodywt = NULL, DF_for_meanbodywt = 30, lbin_method = 2,
binwidth = 2, minimum_size = 2,
maximum_size = 90, comp_tail_compression = -1e-04, add_to_comp = 1e-04,
max_combined_lbin = 0, lbin_vector = seq(22, 90, 2), lencomp = NULL,
agebin_vector = 1:25, ageerror = data.frame(rbind(0:40 + 0.5, 0.001,
0:40 + 0.5, seq(0.525, 2.525, 0.05))), agecomp = NULL, Lbin_method = 3,
max_combined_age = 1, MeanSize_at_Age_obs = NULL, N_environ_variables =
0, N_environ_obs = 0, N_sizefreq_methods = 0, do_tags = 0,
morphcomp_data = 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{styr}{
    start year of the model
  }
  \item{endyr}{
    end year of the model
  }
  \item{nseas}{
    number of seasons
  }
  \item{months_per_seas}{
    months per seasons
  }
  \item{spawn_seas}{
    spawning season
  }
  \item{Nfleet}{
    number of fishing fleets
  }
  \item{Nsurveys}{
    number of surveys
  }
  \item{N_areas}{
    number of areas
  }
  \item{fleetnames}{
    names of fleets
  }
  \item{surveytiming}{
    vector of survey timings
  }
  \item{areas}{
    area definitions for each fleet or survey
  }
  \item{units_of_catch}{
    units of catch for each fleet
  }
  \item{se_log_catch}{
    Uncertainty in catch (standard error in log space).
  }
  \item{Ngenders}{
    Number of genders.
  }
  \item{Nages}{
    Number of ages.
  }
  \item{init_equil}{
    Initial equilibrium catch.
  }
  \item{catch}{
    Catch data
  }
  \item{CPUE}{
    Indices of abundance (if present).
  }
  \item{N_discard_fleets}{
    Number of fleets with discard data.
  }
  \item{discard_data}{
    Discard data (if exists).
  }
  \item{meanbodywt}{
    Mean body weight data (if exists)
  }
  \item{DF_for_meanbodywt}{
    Degrees of freedom for mean body weight t-distribution.
  }
  \item{lbin_method}{
    Method for entering length bins. (1=use databins; 2=generate from
    binwidth,min,max below; 3=read vector). Not sure if all options
    implemented.
  }
  \item{binwidth}{
    Bin width for length bins.
  }
  \item{minimum_size}{
    Lower bound of length bins.
  }
  \item{maximum_size}{
    Upper bound of length bins.
  }
  \item{comp_tail_compression}{
    Value below which tails of composition data will be compressed
    (negative to turn off).
  }
  \item{add_to_comp}{
    Robustifying constant added to multinomial composition likelihoods.
  }
  \item{max_combined_lbin}{
    Maximum length bin below which length composition data will have genders combined.
  }
  \item{lbin_vector}{
    Vector of length bins.
  }
  \item{lencomp}{
    Length composition data (if exists).
  }
  \item{agebin_vector}{
    Vector of age bins.
  }
  \item{ageerror}{
    Ageing error matrices.
  }
  \item{agecomp}{
    Age composition data (if exists).
  }
  \item{Lbin_method}{
    Method of specifying length bins in conditional age-at-length data.
  }
  \item{max_combined_age}{
    Maximum age below which age composition data will have genders combined.
  }
  \item{MeanSize_at_Age_obs}{
    Data on mean size at age (if exists).
  }
  \item{N_environ_variables}{
    Number of environmental variables.
  }
  \item{N_environ_obs}{
    Number of environmental observations.
  }
  \item{N_sizefreq_methods}{
    Number of size frequency methods.
  }
  \item{do_tags}{
    Include tag data? NOT IMPLEMENTED YET.
  }
  \item{morphcomp_data}{
    Morph composition data. NOT IMPLEMENTED YET.
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
  \code{\link{SS_readdat}}, \code{\link{SS_writedat}}
}
% \examples{
% }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
