#' Collect fitbit activity data
#'
#' Collects all of the "activity" data from the FitBit API.
#'
#' @param token The token you received from `fitbitr` function \code{\link[fitbitr]{oauth_token}}
#' @param start_date The date that you want to start collecting the data in "YYYY-MM-DD" format. If `NULL` (default) then it chooses yesterday.
#' @param days_prior_to_start Days before `start_date` that you want to collect data from. Default is 30 days.
#'
#' @return Returns a list of lists for each type of activity.
#' @export
#'
#' @import fitbitr
#' @import lubridate
#'
#' @examples
collect_activity <- function(token, start_date=NULL,days_prior_to_start=30){

  # if no start date is specifed then it is yesterday
  if(is.null(start_date)){
    this_date <- lubridate::today()-1
  }else{
    this_date = start_date
  }

  # range of dates according to days_prior
  dates_to_calc <- seq(to=this_date,from=(this_date-days_prior_to_start),"days")

  # initiate data structures

  steps_list <- vector(mode = "list", length = length(dates_to_calc))
  names(steps_list) <- as.character(dates_to_calc)

  # active_minutes_list <- vector(mode = "list", length = length(dates_to_calc))
  # names(active_minutes_list) <- dates_to_calc

  distance_list <- vector(mode = "list", length = length(dates_to_calc))
  names(distance_list) <- as.character(dates_to_calc)

  calories_list <- vector(mode = "list", length = length(dates_to_calc))
  names(calories_list) <- as.character(dates_to_calc)

  # start collecting data
  message("Collecting activity data...")
  for(this_date_ind in 1:length(dates_to_calc)){

    this_date <- dates_to_calc[this_date_ind]

    # get calories
    calories_list[[this_date_ind]] <- fitbitr::get_activity_intraday_time_series(token = token, "calories", date=this_date, detail_level="1min",simplify = T)

    # active minutes are within the calories data
    # For the activities/log/calories resource,
    # each data point also includes the level field that reflects calculated activity level for that time period
    # (0 - sedentary; 1 - lightly active; 2 - fairly active; 3 - very active.)
    # https://dev.fitbit.com/build/reference/web-api/activity/

    # get steps
    steps_list[[this_date_ind]] <- fitbitr::get_activity_intraday_time_series(token = token, "steps", date=this_date, detail_level="1min",simplify = T)

    # get distance
    distance_list[[this_date_ind]] <- fitbitr::get_activity_intraday_time_series(token = token, "distance", date=this_date, detail_level="1min",simplify = T)


    message(paste0("Finished date: ", this_date, "... ", length(dates_to_calc)-this_date_ind, " dates left."))

  }

  return(
    list(
      calories_list = calories_list,
      steps_list = steps_list,
      distance_list = distance_list
    )
  )



}
