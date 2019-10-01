#!/bin/bash

# Add a swap file to prevent build time OOM errors
fallocate -l 4G /swapfile
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
install.packages("devtools")
install.packages("packrat")
install.packages("vcr")
install.packages("crul")
install.packages("testthat")
install.packages("usethis")

# general
install.packages("data.table")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("janitor")
install.packages("haven")
install.packages("readxl")
install.packages("openxlsx")
install.packages("here")
install.packages("fs")

# documentation
install.packages("roxygen2")
install.packages("rmarkdown")
install.packages("bookdown")
install.packages("pkgdown")
install.packages("xaringan")
install.packages("Rdpack")

# databases
install.packages("DBI")
install.packages("dbplyr")
install.packages("RMariaDB")
install.packages("RPostgreSQL")
install.packages("glue")
install.packages("chunked")

# paralelization
install.packages("doParallel")

# statistics
install.packages("lme4")
install.packages("glm2")
install.packages("lmtest")
install.packages("MASS")
install.packages("censReg")
install.packages("multiwayvcov")
install.packages("rstan")
install.packages("broom")
install.packages("modelr")
install.packages("forecast")
install.packages("prophet")
install.packages("tsibble")
install.packages("fable")
install.packages("tidymodels")
install.packages("h2o")
install.packages("e1071")
install.packages("rpart")
install.packages("nnet")
install.packages("randomForest")
install.packages("caret")
install.packages("kernlab")
install.packages("glmnet")
install.packages("ROCR")
install.packages("pROC")
install.packages("gbm")
install.packages("party")
install.packages("arules")
install.packages("tree")
install.packages("klaR")
install.packages("RWeka")
install.packages("lars")
install.packages("earth")
install.packages("CORElearn")
install.packages("mboost")
install.packages("mlr")

# maps
install.packages("sf")
install.packages("spData")
install.packages("tmap")
install.packages("cartography")

# visualization
install.packages("corrplot")
install.packages("lattice")
install.packages("shiny")
install.packages("shinydashboard")
install.packages("golem")
install.packages("shinyjs")
install.packages("V8")
install.packages("highcharter")
install.packages("plotly")
install.packages("ggvis")
install.packages("DT")
install.packages("shinyWidgets")
install.packages("shinydashboardPlus")
install.packages("bsplus")
install.packages("plotly")
install.packages("shinyML")

# networks
install.packages("igraph")
install.packages("ggraph")
install.packages("tidygraph")
install.packages("visNetwork")
install.packages("network")
install.packages("networkDynamic")
install.packages("ndtv")
install.packages("intergraph")
install.packages("igraphdata")
install.packages("qgraph")

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
