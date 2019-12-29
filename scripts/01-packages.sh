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
apt-get -y install libxml2-dev libssl-dev libcurl4-openssl-dev libudunits2-dev gdal-bin libgdal-dev libproj-dev libv8-dev default-jdk libmagick++-dev

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
pacman::p_install(devtools, force = FALSE)
pacman::p_install(testthat, force = FALSE)
pacman::p_install(usethis, force = FALSE)

# general
pacman::p_install(data.table, force = FALSE)
pacman::p_install(tidyverse, force = FALSE)
pacman::p_install(lubridate, force = FALSE)
pacman::p_install(janitor, force = FALSE)
pacman::p_install(haven, force = FALSE)
pacman::p_install(readxl, force = FALSE)
pacman::p_install(writexl, force = FALSE)
pacman::p_install(here, force = FALSE)
pacman::p_install(fs, force = FALSE)

# documentation
pacman::p_install(roxygen2, force = FALSE)
pacman::p_install(rmarkdown, force = FALSE)
pacman::p_install(bookdown, force = FALSE)
pacman::p_install(pkgdown, force = FALSE)
pacman::p_install(xaringan, force = FALSE)
pacman::p_install(Rdpack, force = FALSE)

# databases
pacman::p_install(DBI, force = FALSE)
pacman::p_install(dbplyr, force = FALSE)
pacman::p_install(RMariaDB, force = FALSE)
pacman::p_install(RPostgres, force = FALSE)
pacman::p_install(glue, force = FALSE)
pacman::p_install(chunked, force = FALSE)

# paralelization
pacman::p_install(doParallel, force = FALSE)

# statistics
pacman::p_install(broom, force = FALSE)
pacman::p_install(modelr, force = FALSE)
pacman::p_install(tidymodels, force = FALSE)

# visualization
pacman::p_install(shiny, force = FALSE)
pacman::p_install(shinyjs, force = FALSE)
pacman::p_install(shinydashboard, force = FALSE)
pacman::p_install(highcharter, force = FALSE)
pacman::p_install(DT, force = FALSE)

q()
EOF

# install RStudio Server
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5033-amd64.deb
gdebi --n rstudio-server-1.2.5033-amd64.deb
rm rstudio-server-1.2.5033-amd64.deb

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
