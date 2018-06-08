#' Ballpark codes and information
#'
#' @docType data
#' @source \url{http://www.retrosheet.org/parkcode.txt}
#' @format Data frame with columns
#' \describe{
#' \item{parkid}{Ballpark ID}
#' \item{name}{Name of the ballpark}
#' \item{aka}{Alternative name for the ballpark}
#' \item{city}{City in which the ballpark is located}
#' \item{state}{State in which the ballpark is located}
#' \item{start}{Date the ballpark came into service}
#' \item{end}{Date of the ballpark's last service}
#' \item{league}{League in which the ballpark (primarily) served}
#' \item{notes}{additional information}
#' }
"ballparks"

#' Event codes
#' @docType data
#' @source \url{https://github.com/chadwickbureau/chadwick/blob/master/doc/cwevent.rst}
#' @format Data frame with two columns
#' \describe{
#' \item{EVENT_CD}{Event code}
#' \item{EVENT}{Description of the event}
#' }
"event_codes"
