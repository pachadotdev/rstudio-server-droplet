#!/bin/bash

# add CRAN to apt sources
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
printf '\n#CRAN mirror\ndeb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/\n' | sudo tee -a /etc/apt/sources.list

# update apt
apt-get -y update

# requisites for some R packages
apt-get -y install gdebi-core libxml2-dev libssl-dev libcurl4-openssl-dev texlive-full pandoc-citeproc libmariadbclient-dev libpq-dev

# optimized BLAS
apt-get -y install libopenblas-dev

# install R 3.5
apt-get -y install r-base r-base-dev

# install devtools and pacman
R --vanilla << EOF
if (!require("pacman")) { install.packages("pacman", repos = "https://cran.rstudio.com/") }
pacman::p_load(devtools)
pacman::p_load(packrat, vcr, crul, testthat)
pacman::p_load(data.table, tidyverse, lubridate, janitor, haven, jsonlite)
pacman::p_load(roxygen2, rmarkdown, bookdown, pkgdown)
pacman::p_load(DBI, dbplyr, RMariaDB, RPostgreSQL, chunked)
pacman::p_load(doParallel)
pacman::p_load(shiny, shinydashboard, golem, shinyjs, V8)
pacman::p_load(corrplot, lattice, highcharter, plotly, ggvis, DT)
pacman::p_load(forecast, prophet, tsibble, fable)
pacman::p_load(h2o, shinyML, e1071, rpart, igraph, nnet, randomForest, caret, kernlab,
glmnet, ROCR, pROC, gbm, party, arules, tree, klaR, RWeka, ipred, lars, earth, CORElearn,
mboost, mlr)
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

# install DO cloud init
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

# open ports
ufw allow http
ufw allow https
ufw allow ssh
ufw allow 8787
ufw allow 3838
