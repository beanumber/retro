retro
================

[![Travis-CI Build Status](https://travis-ci.org/beanumber/retro.svg?branch=master)](https://travis-ci.org/beanumber/retro)

An R package for creating a Retrosheet database using the ETL framework

``` r
devtools::install_github("beanumber/retro")
library(retro)
```

``` r
system("mysql -e 'CREATE DATABASE IF NOT EXISTS retrosheet;'")
db <- src_mysql_cnf("retrosheet")
retro <- etl("retro", db = db, dir = "~/dumps/retro/")

retro %>%
  etl_init() %>%
  etl_extract(season = 2013:2016) %>%
  etl_transform(season = 2014:2016) %>%
  etl_load(season = 2014)

# add partitions
dbRunScript(retro$con, 
            system.file("sql", "optimize.mysql", package = "retro"))
```
