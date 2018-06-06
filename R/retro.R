#' Download Retrosheet data
#' @param obj the ETL object
#' @param season the season
#' @param ... currently ignored
#' @export
#' @examples
#' \dontrun{
#'   system("mysql -e 'CREATE DATABASE IF NOT EXISTS retrosheet;'")
#'   db <- src_mysql_cnf("retrosheet", hostname = "127.0.0.1")
#'   retro <- etl("retro", db = db, dir = "~/dumps/retro/")
#'
#'   retro %>%
#'     etl_extract(season = 2013:2016) %>%
#'     etl_transform(season = 2014:2016) %>%
#'     etl_load(season = 2014)
#' }

etl_extract.etl_retro <- function(obj, season, ...) {
  # game logs
  remote <- paste0("http://www.retrosheet.org/gamelogs/gl", season, ".zip")
  local <- file.path(attr(obj, "raw"), paste0("gl", season, ".zip"))
  etl::smart_download(obj, src = remote)

  # events
  remote <- paste0("http://www.retrosheet.org/events/", season, "eve.zip")
  local <- file.path(attr(obj, "raw"), basename(remote))
  etl::smart_download(obj, src = remote)

  invisible(obj)
}

#' @rdname etl_extract.etl_retro
#' @export

etl_transform.etl_retro <- function(obj, season, ...) {
  # game logs
  zipped <- match_files_by_year_months(
    list.files(attr(obj, "raw"), full.names = TRUE),
    pattern = "gl%Y.zip", year = season)
  lapply(zipped, unzip, exdir = attr(obj, "load"))

  # events
  zipped <- match_files_by_year_months(
    list.files(attr(obj, "raw"), full.names = TRUE),
    pattern = "%Yeve.zip", year = season)
  lapply(zipped, unzip, exdir = attr(obj, "load"))

  parsed <- match_files_by_year_months(
    list.files(attr(obj, "load"), full.names = TRUE),
    pattern = "GL%Y.TXT", year = season)

  cmds <- paste0("cwgame -n -f 0-83 -y ", season, " ", season,
                 "*.ev* > GL", season, ".TXT")
  system(cmds)
  invisible(obj)
}

#' @rdname etl_extract.etl_retro
#' @export

etl_load.etl_retro <- function(obj, season, ...) {
  src <- match_files_by_year_months(
    list.files(attr(obj, "load"), full.names = TRUE),
    pattern = "GL%Y.TXT", year = season)
  smart_upload(obj, src = src, tablenames = "games")
  invisible(obj)
}
