#!/bin/bash

# add CRAN to apt sources
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
printf '\n#CRAN mirror\ndeb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/\n' | sudo tee -a /etc/apt/sources.list

# update apt
apt-get -y update
apt-get -y upgrade

# requisites for RStudio
apt-get -y install gdebi-core

# requisites for R packages
apt-get -y install libxml2-dev libssl-dev libcurl4-openssl-dev libudunits2-dev gdal-bin libgdal-dev libproj-dev libv8-dev

# requisites for Markdown
apt-get -y install texlive-full pandoc-citeproc

# requisites for DB connectors
apt-get -y instal libmysqlclient-dev libpq-dev

# install optimized BLAS
apt-get -y install libopenblas-dev

# install R
apt-get -y install r-base r-base-dev

# install Digital Ocean agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

# install R packages
R --vanilla << EOF
# development
if (!require("pacman")) { install.packages("pacman", repos = "https://cran.rstudio.com/") }
pacman::p_load(devtools, packrat, vcr, crul, testthat, usethis)

# general
pacman::p_load(data.table, tidyverse, lubridate, janitor, haven, jsonlite, here, fs)

# documentation
pacman::p_load(roxygen2, rmarkdown, bookdown, pkgdown, xaringan, Rdpack)

# databases
pacman::p_load(DBI, dbplyr, RMariaDB, RPostgreSQL, glue, chunked)

# paralelization
pacman::p_load(doParallel)

# visualization
pacman::p_load(corrplot, lattice, shiny, shinydashboard, golem, shinyjs, V8, highcharter, plotly, ggvis, DT)

# statistics
pacman::p_load(lme4, glm2, lmtest, MASS, censReg, survival, multiwayvcov, rstan, broom, modelr,
forecast, prophet, tsibble, fable, tidymodels,
h2o, shinyML, e1071, rpart, igraph, nnet, randomForest, caret,
kernlab, glmnet, ROCR, pROC, gbm, party, arules, tree, klaR,
RWeka, ipred, lars, earth, CORElearn, mboost, mlr)

# maps
pacman::p_load(sf, spData, tmap, cartography)
q()
EOF

# install RStudio Server
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5001-amd64.deb
gdebi --n rstudio-server-1.2.5001-amd64.deb
rm rstudio-server-1.2.5001-amd64.deb

# install Shiny Server
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb
gdebi --n shiny-server-1.5.12.933-amd64.deb
rm shiny-server-1.5.12.933-amd64.deb

# open ports
ufw allow http
ufw allow https
ufw allow ssh
ufw allow 8787
ufw allow 3838
