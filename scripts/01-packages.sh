#!/bin/bash

# Add a swap file to prevent build time OOM errors
fallocate -l 8G /swapfile
mkswap /swapfile
swapon /swapfile

# add CRAN to apt sources
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
printf '\n#CRAN mirror\ndeb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/\n' | sudo tee -a /etc/apt/sources.list

# update apt
apt-get -y update
apt-get -y upgrade

# requisites for RStudio
apt-get -y install gdebi-core

# requisites for R packages
apt-get -y install libxml2-dev libssl-dev libcurl4-openssl-dev libudunits2-dev gdal-bin libgdal-dev libproj-dev libv8-dev default-jdk

# requisites for Markdown
apt-get -y install texlive-full pandoc-citeproc

# requisites for DB connectors
apt-get -y install libmysqlclient-dev libpq-dev

# install optimized BLAS
apt-get -y install libopenblas-dev

# install R
apt-get -y install r-base r-base-dev

# install Digital Ocean agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

# install R packages
R --vanilla << EOF
# development
if (!require("pacman")) {
  install.packages("pacman", repos = "http://cran.us.r-project.org")
}
q()
EOF

R --vanilla << EOF
# development
pacman::p_install(devtools)
pacman::p_install(packrat)
pacman::p_install(vcr)
pacman::p_install(crul)
pacman::p_install(testthat)
pacman::p_install(usethis)

# general
pacman::p_install(data.table)
pacman::p_install(tidyverse)
pacman::p_install(lubridate)
pacman::p_install(janitor)
pacman::p_install(haven)
pacman::p_install(readxl)
pacman::p_install(openxlsx)
pacman::p_install(here)
pacman::p_install(fs)

# documentation
pacman::p_install(roxygen2)
pacman::p_install(rmarkdown)
pacman::p_install(bookdown)
pacman::p_install(pkgdown)
pacman::p_install(xaringan)
pacman::p_install(Rdpack)

# databases
pacman::p_install(DBI)
pacman::p_install(dbplyr)
pacman::p_install(RMariaDB)
pacman::p_install(RPostgreSQL)
pacman::p_install(glue)
pacman::p_install(chunked)

# paralelization
pacman::p_install(doParallel)

# statistics
pacman::p_install(lme4)
pacman::p_install(glm2)
pacman::p_install(lmtest)
pacman::p_install(MASS)
pacman::p_install(censReg)
pacman::p_install(multiwayvcov)
pacman::p_install(rstan)
pacman::p_install(broom)
pacman::p_install(modelr)
pacman::p_install(forecast)
pacman::p_install(prophet)
pacman::p_install(tsibble)
pacman::p_install(fable)
pacman::p_install(tidymodels)
pacman::p_install(h2o)
pacman::p_install(e1071)
pacman::p_install(rpart)
pacman::p_install(nnet)
pacman::p_install(randomForest)
pacman::p_install(caret)
pacman::p_install(kernlab)
pacman::p_install(glmnet)
pacman::p_install(ROCR)
pacman::p_install(pROC)
pacman::p_install(gbm)
pacman::p_install(party)
pacman::p_install(arules)
pacman::p_install(tree)
pacman::p_install(klaR)
pacman::p_install(RWeka)
pacman::p_install(lars)
pacman::p_install(earth)
pacman::p_install(CORElearn)
pacman::p_install(mboost)
pacman::p_install(mlr)

# maps
pacman::p_install(sf)
pacman::p_install(spData)
pacman::p_install(tmap)
pacman::p_install(cartography)

# visualization
pacman::p_install(corrplot)
pacman::p_install(lattice)
pacman::p_install(shiny)
pacman::p_install(shinydashboard)
pacman::p_install(golem)
pacman::p_install(shinyjs)
pacman::p_install(V8)
pacman::p_install(highcharter)
pacman::p_install(plotly)
pacman::p_install(ggvis)
pacman::p_install(DT)
pacman::p_install(shinyWidgets)
pacman::p_install(shinydashboardPlus)
pacman::p_install(bsplus)
pacman::p_install(plotly)
pacman::p_install(shinyML)

# networks
pacman::p_install(igraph)
pacman::p_install(ggraph)
pacman::p_install(tidygraph)
pacman::p_install(visNetwork)
pacman::p_install(network)
pacman::p_install(networkDynamic)
pacman::p_install(ndtv)
pacman::p_install(intergraph)
pacman::p_install(igraphdata)
pacman::p_install(qgraph)

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

# Disable and remove the swapfile prior to snapshotting
swapoff /swapfile
rm -f /swapfile
