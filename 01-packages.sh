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
pacman::p_load(data.table, readr, haven, jsonlite)
pacman::p_load(dplyr, tidyr, purrr, janitor)
pacman::p_load(ggplot2)
pacman::p_load(lubridate)
pacman::p_load(roxygen2, rmarkdown, bookdown, pkgdown)
pacman::p_load(RMariaDB, RPostgreSQL)
pacman::p_load(doParallel)
pacman::p_load(shiny)
pacman::p_load(tidyverse)
q()
EOF

# install RStudio Server
wget https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb
gdebi --n rstudio-server-1.1.463-amd64.deb
rm rstudio-server-1.1.463-amd64.deb

# install Shiny Server
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
gdebi --n shiny-server-1.5.9.923-amd64.deb
rm shiny-server-1.5.9.923-amd64.deb
