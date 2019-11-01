#' Get my data
#'
#' A wrapper function to collect all the data in a single step
#'
#' @param token The token you received from `fitbitr` function \code{\link[fitbitr]{oauth_token}}
#' @param start_date The date that you want to start collecting the data in "YYYY-MM-DD" format. If `NULL` (default) then it chooses yesterday.
#'
#' @return
#' @export
#'
#' @examples
get_my_data <- function(token, start_date=NULL){

  # if no start date is specifed then it is yesterday
  if(is.null(start_date)){
    this_date <- lubridate::today()-1
  }else{
    this_date = start_date
  }

  message("Getting my data...")

  message("Collecting activity data...")

  my_activity_data <- ECfitbitR::collect_activity(token=token,start_date=start_date)

  message("Collecting heart rate data...")

  my_heartrate_data <- ECfitbitR::collect_heartrate(token = token,start_date = start_date)

  message("Collecting sleep data...")

  my_sleep_data <- ECfitbitR::collect_sleep(token=token,start_date = start_date)

  message("All data collected!")

  return(list(
    my_activity_data = my_activity_data,
    my_heartrate_data = my_heartrate_data,
    my_sleep_data = my_sleep_data))

}
