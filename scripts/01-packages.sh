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
install.packages("devtools", repos = "http://cran.us.r-project.org")
install.packages("packrat", repos = "http://cran.us.r-project.org")
install.packages("vcr", repos = "http://cran.us.r-project.org")
install.packages("crul", repos = "http://cran.us.r-project.org")
install.packages("testthat", repos = "http://cran.us.r-project.org")
install.packages("usethis", repos = "http://cran.us.r-project.org")

# general
install.packages("data.table", repos = "http://cran.us.r-project.org")
install.packages("tidyverse", repos = "http://cran.us.r-project.org")
install.packages("lubridate", repos = "http://cran.us.r-project.org")
install.packages("janitor", repos = "http://cran.us.r-project.org")
install.packages("haven", repos = "http://cran.us.r-project.org")
install.packages("readxl", repos = "http://cran.us.r-project.org")
install.packages("openxlsx", repos = "http://cran.us.r-project.org")
install.packages("here", repos = "http://cran.us.r-project.org")
install.packages("fs", repos = "http://cran.us.r-project.org")

# documentation
install.packages("roxygen2", repos = "http://cran.us.r-project.org")
install.packages("rmarkdown", repos = "http://cran.us.r-project.org")
install.packages("bookdown", repos = "http://cran.us.r-project.org")
install.packages("pkgdown", repos = "http://cran.us.r-project.org")
install.packages("xaringan", repos = "http://cran.us.r-project.org")
install.packages("Rdpack", repos = "http://cran.us.r-project.org")

# databases
install.packages("DBI", repos = "http://cran.us.r-project.org")
install.packages("dbplyr", repos = "http://cran.us.r-project.org")
install.packages("RMariaDB", repos = "http://cran.us.r-project.org")
install.packages("RPostgreSQL", repos = "http://cran.us.r-project.org")
install.packages("glue", repos = "http://cran.us.r-project.org")
install.packages("chunked", repos = "http://cran.us.r-project.org")

# paralelization
install.packages("doParallel", repos = "http://cran.us.r-project.org")

# statistics
install.packages("lme4", repos = "http://cran.us.r-project.org")
install.packages("glm2", repos = "http://cran.us.r-project.org")
install.packages("lmtest", repos = "http://cran.us.r-project.org")
install.packages("MASS", repos = "http://cran.us.r-project.org")
install.packages("censReg", repos = "http://cran.us.r-project.org")
install.packages("multiwayvcov", repos = "http://cran.us.r-project.org")
install.packages("rstan", repos = "http://cran.us.r-project.org")
install.packages("broom", repos = "http://cran.us.r-project.org")
install.packages("modelr", repos = "http://cran.us.r-project.org")
install.packages("forecast", repos = "http://cran.us.r-project.org")
install.packages("prophet", repos = "http://cran.us.r-project.org")
install.packages("tsibble", repos = "http://cran.us.r-project.org")
install.packages("fable", repos = "http://cran.us.r-project.org")
install.packages("tidymodels", repos = "http://cran.us.r-project.org")
install.packages("h2o", repos = "http://cran.us.r-project.org")
install.packages("e1071", repos = "http://cran.us.r-project.org")
install.packages("rpart", repos = "http://cran.us.r-project.org")
install.packages("nnet", repos = "http://cran.us.r-project.org")
install.packages("randomForest", repos = "http://cran.us.r-project.org")
install.packages("caret", repos = "http://cran.us.r-project.org")
install.packages("kernlab", repos = "http://cran.us.r-project.org")
install.packages("glmnet", repos = "http://cran.us.r-project.org")
install.packages("ROCR", repos = "http://cran.us.r-project.org")
install.packages("pROC", repos = "http://cran.us.r-project.org")
install.packages("gbm", repos = "http://cran.us.r-project.org")
install.packages("party", repos = "http://cran.us.r-project.org")
install.packages("arules", repos = "http://cran.us.r-project.org")
install.packages("tree", repos = "http://cran.us.r-project.org")
install.packages("klaR", repos = "http://cran.us.r-project.org")
install.packages("RWeka", repos = "http://cran.us.r-project.org")
install.packages("lars", repos = "http://cran.us.r-project.org")
install.packages("earth", repos = "http://cran.us.r-project.org")
install.packages("CORElearn", repos = "http://cran.us.r-project.org")
install.packages("mboost", repos = "http://cran.us.r-project.org")
install.packages("mlr", repos = "http://cran.us.r-project.org")

# maps
install.packages("sf", repos = "http://cran.us.r-project.org")
install.packages("spData", repos = "http://cran.us.r-project.org")
install.packages("tmap", repos = "http://cran.us.r-project.org")
install.packages("cartography", repos = "http://cran.us.r-project.org")

# visualization
install.packages("corrplot", repos = "http://cran.us.r-project.org")
install.packages("lattice", repos = "http://cran.us.r-project.org")
install.packages("shiny", repos = "http://cran.us.r-project.org")
install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
install.packages("golem", repos = "http://cran.us.r-project.org")
install.packages("shinyjs", repos = "http://cran.us.r-project.org")
install.packages("V8", repos = "http://cran.us.r-project.org")
install.packages("highcharter", repos = "http://cran.us.r-project.org")
install.packages("plotly", repos = "http://cran.us.r-project.org")
install.packages("ggvis", repos = "http://cran.us.r-project.org")
install.packages("DT", repos = "http://cran.us.r-project.org")
install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
install.packages("shinydashboardPlus", repos = "http://cran.us.r-project.org")
install.packages("bsplus", repos = "http://cran.us.r-project.org")
install.packages("plotly", repos = "http://cran.us.r-project.org")
install.packages("shinyML", repos = "http://cran.us.r-project.org")

# networks
install.packages("igraph", repos = "http://cran.us.r-project.org")
install.packages("ggraph", repos = "http://cran.us.r-project.org")
install.packages("tidygraph", repos = "http://cran.us.r-project.org")
install.packages("visNetwork", repos = "http://cran.us.r-project.org")
install.packages("network", repos = "http://cran.us.r-project.org")
install.packages("networkDynamic", repos = "http://cran.us.r-project.org")
install.packages("ndtv", repos = "http://cran.us.r-project.org")
install.packages("intergraph", repos = "http://cran.us.r-project.org")
install.packages("igraphdata", repos = "http://cran.us.r-project.org")
install.packages("qgraph", repos = "http://cran.us.r-project.org")

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
