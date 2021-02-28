#!/bin/bash

# Add a swap file to prevent build time OOM errors
fallocate -l 8G /swapfile
mkswap /swapfile
swapon /swapfile

# add CRAN to apt sources
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
printf '\n#CRAN mirror\ndeb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/\n' | tee -a /etc/apt/sources.list

# update apt
apt-get -y update
apt-get -y upgrade

# requisites for RStudio
apt-get -y install gdebi-core

# requisites for different R packages
# this aims at covering as much packages as possible
# see https://packagemanager.rstudio.com/client/#/repos/1/overview
# and also
# https://geocompr.github.io/post/2020/installing-r-spatial-ubuntu/
# http://dirk.eddelbuettel.com/blog/2020/06/22#027_ubuntu_binaries
# this a broad, general setup, no fine detail here
apt-get -y install software-properties-common libopenblas-dev libsodium-dev texlive default-jdk

add-apt-repository -y ppa:c2d4u.team/c2d4u4.0+
apt-get -y update

# install R
apt-get -y install r-base r-base-dev
R CMD javareconf

# RSPM site-wide
sed -i 's/cloud\.r-project\.org/packagemanager\.rstudio\.com\/all\/latest/g' /usr/lib/R/etc/Rprofile.site

# install Digital Ocean agent
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

# install R packages
apt-get -y install r-cran-devtools r-cran-usethis r-cran-tidyverse r-cran-janitor r-cran-writexl r-cran-data.table r-cran-roxygen2 r-cran-knitr r-cran-rmarkdown r-cran-bookdown r-cran-xaringan r-cran-rdpack r-cran-dbi r-cran-dbplyr r-cran-rmariadb r-cran-rpostgres r-cran-glue r-cran-doparallel r-cran-future r-cran-shiny r-cran-shinyjs r-cran-shinydashboard r-cran-dt

R --vanilla << EOF
options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/latest"))

install.packages("tidymodels")
install.packages("pkgdown")
install.packages("highcharter")

q()
EOF

# install RStudio Server
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
gdebi --n rstudio-server-1.4.1106-amd64.deb
rm rstudio-server-1.4.1106-amd64.deb

# install Shiny Server
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
gdebi --n shiny-server-1.5.16.958-amd64.deb
rm shiny-server-1.5.16.958-amd64.deb

# add some security
echo "y" | ufw enable
apt-get -y install fail2ban
systemctl start fail2ban
systemctl enable fail2ban
printf '[sshd]\nenabled = true\nport = 22\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 5' | tee -a /etc/fail2ban/jail.local
printf '\n\n[http-auth]\nenabled = true\nport = http,https\nlogpath = /var/log/auth.log\nmaxretry = 5' | tee -a /etc/fail2ban/jail.local
systemctl restart fail2ban

# open ports
ufw allow http
ufw allow https
ufw allow ssh
ufw allow 8787
ufw allow 3838

# Disable and remove the swapfile prior to snapshotting
swapoff /swapfile
rm -f /swapfile
