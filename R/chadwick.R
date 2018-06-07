
#' Install Chadwick
#' @param obj An \code{etl_retro} object
#' @param ... currectly ignored
#' @importFrom utils download.file untar

install_chadwick <- function(obj, ...) {
  url <- "https://github.com/chadwickbureau/chadwick/archive/v0.7.0.tar.gz"
  lcl <- file.path(attr(obj, "raw_dir"), basename(url))
  utils::download.file(url, destfile = lcl)
  utils::untar(lcl, exdir = attr(obj, "raw_dir"))
  # export LD_LIBRARY_PATH=/usr/local/lib
  # autoreconf -i
  # ./configure
  # make
  # sudo make install
  system(file.path(".", tempdir(), "chadwick-0.7.0", "configure"))
}
