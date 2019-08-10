# Application description

RStudio Server is the premier integrated development environment for R that allows to move computation close to the data and scale compute and RAM centrally.

This is a pre-configured image with open source editions of RStudio Server 1.1. and Shiny Server 1.5. All dependencies are solved for you to just go and use the next compiled R packages (the setup already includes R 3.5, TeX Live 2018 and OpenBLAS):

- Databases: dbplyr, RMariaDB, RPostgreSQL
- Development: devtools, testthat
- Documentation: bookdown, pkgdown, rmarkdown, roxygen2
- Parallelization: doParallel
- Package management: pacman
- Manipulate data: dplyr, forcats, janitor, lubridate, purrr, stringr, tidyr
- Metapackages: tidyverse
- Plots: ggplot2
- Read/write data: data.table, haven, jsonlite, readr, readxl
- Reproducibility: crul, packrat, reprex, vcr
- Statistics: broom, modelr
- Web applications: shiny
- Web scraping: rvest

# Getting started information

**Creating a system administrator account**

It is highly recommended that you create an administrator account separate from root.

With your just created droplet, open a terminal on your local and login as root:

```
ssh root@server_ip_address
```

Let's create the user paul:

```
adduser paul
usermod -aG sudo paul
```

For the full reference please check this [DigitalOcean tutorial](<https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart>).

**Adding more users**

Let's create three users that will only be able to install R packages to their personal directory (and of course to use R, RStudio and Shiny):

```
adduser john 
adduser george 
adduser ringo
```

**Using RStudio Server**

From any modern browser such as Firefox, type `server_ip_address:8787` (see your droplet IP at DigitalOcean control panel) on the address bar and then enter with any of the users you created before.

Another option is to access by using an ssh tunnel, with nice benefit of being encrypted. Run this command from the terminal:

```
ssh -f root@134.209.125.2 -L 8787:134.209.125.2:8787 -N
```

And then, from the browser go to `localhost:8787`.

Please notice that the droplet already includes different R packages and full LaTeX installation. The next packages are ready to use and you don't need to re-install them:

- Databases: RMariaDB and RPostgreSQL
- Data visualization: ggplot2 and shiny
- Data wrangling: data.table, dplyr, haven, janitor, jsonlite, lubridate, purrr, readr and tidyr
- Development: crul, devtools, pacman, packrat and testthat
- Documentation: bookdown, pkgdown, rmarkdown, roxygen2
- Parallelization: doParallel**Optional: custom domain and enabled https**Let's say that you want people from your organization access RStudio Server from `rstudio.ourcompany.us` instead of `server_ip_address:8787`. DigitalOcean tutorials already covered the additional steps to do that by using [Nginx](<https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04>) or [Apache](<https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-18-04>).
