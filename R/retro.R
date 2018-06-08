#' Download Retrosheet data
#' @param obj the ETL object
#' @param season the season
#' @param ... currently ignored
#' @export
#' @import etl
#' @importFrom etl smart_download
#' @source Retrosheet: \url{http://www.retrosheet.org/game.htm}
#' @references \url{http://www.retrosheet.org/location.htm}
#' @examples
#' \dontrun{
#'   system("mysql -e 'CREATE DATABASE IF NOT EXISTS retrosheet;'")
#'   db <- src_mysql_cnf("retrosheet")
#'   retro <- etl("retro", db = db, dir = "~/dumps/retro/")
#'
#'   retro %>%
#'     etl_extract(season = 2013:2016) %>%
#'     etl_transform(season = 2014:2016) %>%
#'     etl_load(season = 2014)
#' }

etl_extract.etl_retro <- function(obj, season = 2017, ...) {
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
#' @importFrom utils unzip

etl_transform.etl_retro <- function(obj, season = 2017, ...) {
  # game logs
  zipped <- match_files_by_year_months(
    list.files(attr(obj, "raw"), full.names = TRUE),
    pattern = "gl%Y.zip", years = season)
  lapply(zipped, utils::unzip, exdir = attr(obj, "load"))

  cmds <- paste0("cd ", attr(obj, "load"), "; ",
                 "cwgame -n -f 0-83 -y ", season, " ", season,
                 "*.EV* > games_", season, ".csv")
  message(paste0("\n", cmds))
  lapply(cmds, system)

  # events
  zipped <- match_files_by_year_months(
    list.files(attr(obj, "raw"), full.names = TRUE),
    pattern = "%Yeve.zip", years = season)
  lapply(zipped, utils::unzip, exdir = attr(obj, "load"))

  cmds <- paste0("cd ", attr(obj, "load"), "; ",
                 "cwevent -n -f 0-96 -x 0-60 -y ", season, " ", season,
                 "*.EV* > events_", season, ".csv")
  message(paste0("\n", cmds))
  lapply(cmds, system)

  # subs
  cmds <- paste0("cd ", attr(obj, "load"), "; ",
                 "cwsub -n -y ", season, " ", season,
                 "*.EV* > subs_", season, ".csv")
  message(paste0("\n", cmds))
  lapply(cmds, system)

  invisible(obj)
}

#' @rdname etl_extract.etl_retro
#' @importFrom etl smart_upload
#' @export

etl_load.etl_retro <- function(obj, season = 2017, ...) {
  src <- match_files_by_year_months(
    list.files(attr(obj, "load"), full.names = TRUE),
    pattern = "games_%Y.csv", years = season)
  etl::smart_upload(obj, src = src, tablenames = "games")

  src <- match_files_by_year_months(
    list.files(attr(obj, "load"), full.names = TRUE),
    pattern = "events_%Y.csv", years = season)
  smart_upload(obj, src = src, tablenames = "events")

  src <- match_files_by_year_months(
    list.files(attr(obj, "load"), full.names = TRUE),
    pattern = "subs_%Y.csv", years = season)
  smart_upload(obj, src = src, tablenames = "subs")

  invisible(obj)
}
