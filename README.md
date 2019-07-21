retro
================

[![Travis-CI Build
Status](https://travis-ci.org/beanumber/retro.svg?branch=master)](https://travis-ci.org/beanumber/retro)

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

![](http://www.retrosheet.org/hitloc.jpg)

## Compare To

  - (<https://github.com/rmscriven/retrosheet>): last commit was 2015;
    not on CRAN; does not require `chadwick`
  - (<https://github.com/davidbmitchell/Baseball-PostgreSQL>): Only for
    PostgreSQL; also requires `chadwick`

## Installing Chadwick

On Ubuntu:

``` bash
wget https://sourceforge.net/projects/chadwick/files/chadwick-0.7/chadwick-0.7.2/chadwick-0.7.2.tar.gz -P /tmp
tar xvzf chadwick-0.7.2.tar.gz
cd chadwick-0.7.2
./configure
# if bash: ./configure: No such file or directory
make
sudo make install
export LD_LIBRARY_PATH=/usr/local/lib
```

    Libraries have been installed in:
       /usr/local/lib
    
    If you ever happen to want to link against installed libraries
    in a given directory, LIBDIR, you must either use libtool, and
    specify the full pathname of the library, or use the `-LLIBDIR'
    flag during linking and do at least one of the following:
       - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
         during execution
       - add LIBDIR to the `LD_RUN_PATH' environment variable
         during linking
       - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
       - have your system administrator add LIBDIR to `/etc/ld.so.conf'
