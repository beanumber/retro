
#' Install Chadwick
#' @param obj An \code{etl_retro} object
#' @param ... currectly ignored
#' @importFrom utils download.file untar

install_chadwick <- function(obj, ...) {
  url <- "https://github.com/chadwickbureau/chadwick/archive/v0.7.2.tar.gz"
  lcl <- file.path(attr(obj, "raw_dir"), basename(url))
  utils::download.file(url, destfile = lcl)
  utils::untar(lcl, exdir = attr(obj, "raw_dir"))
  # export LD_LIBRARY_PATH=/usr/local/lib
  # autoreconf -i
  # ./configure
  # make
  # sudo make install
  system(file.path(".", tempdir(), "chadwick-0.7.2", "configure"))
}

#' @rdname install_chadwick
#' @export

check_chadwick <- function() {
  out <- system2("which", "cwevent", stdout = TRUE)
  if (!file.exists(out)) {
    warning("cwevent could not be found.")
    linker <- system2("echo", "$LD_LIBRARY_PATH", stdout = TRUE)
    message(paste("LD_LIBRARY_PATH:", linker))
    stop(paste(out, "is not a valid path to cwevent"))
  } else {
    message("Chadwick found at: ", out)
    return(invisible(TRUE))
  }
  FALSE
}

#' @rdname install_chadwick
#' @export

find_chadwick <- function() {
  out <- fs::path_dir(system2("which", "cwevent", stdout = TRUE))
  if (!fs::dir_exists(out)) {
    stop("Chadwick could not be find. Try install_chadwick()")
  } else {
    return(fs::path(out))
  }
}

#' @rdname install_chadwick
#' @export

set_library_path <- function() {
  ld_lib_path <- system2("echo", "$LD_LIBRARY_PATH", stdout = TRUE)
  chadwick_dir <- find_chadwick()
  if (!grepl(chadwick_dir, ld_lib_path)) {
    message(paste("LD_LIBRARY_PATH:", ld_lib_path))
    message("Attempting to modify LD_LIBRARY_PATH...")
    system2(
      "export",
      paste0("LD_LIBRARY_PATH=", chadwick_dir, ":$LD_LIBRARY_PATH")
    )
  }
  return(system2("echo", "$LD_LIBRARY_PATH", stdout = TRUE))
}
