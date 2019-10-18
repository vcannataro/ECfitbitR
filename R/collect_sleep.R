#' Collect fitbit sleep data
#'
#' @param token The token you received from `fitbitr` function \code{\link[fitbitr]{oauth_token}}
#' @param start_date The date that you want to start collecting the data in "YYYY-MM-DD" format. If `NULL` (default) then it chooses yesterday.
#' @param days_prior_to_start Days before `start_date` that you want to collect data from. Default is 30 days.
#'
#' @return
#' @export
#'
#' @import lubridate
#' @import fitbitr
#' @import httr
#' @import jsonlite
#'
#' @section Citations:
#' Much of the code in this function was learned from the excellent blog post https://www.r-bloggers.com/downloading-fitbit-data-histories-with-r/
#'
#' @examples
collect_sleep <- function(token, start_date=NULL, days_prior_to_start=30){

  # set date as yesterday if we do not have a date
  if(is.null(start_date)){
    this_date <- lubridate::today()-1
  }else{
    this_date = start_date
  }


  get_sleep_url <- paste0("https://api.fitbit.com/1.2/user/-/sleep/date/",
                          this_date-days_prior_to_start,"/",this_date,".json")

  sleep_data_raw <- httr::GET(url = get_sleep_url, httr::config(token=token$token))
  sleep_data_transform <- jsonlite::fromJSON(httr::content(sleep_data_raw, as="text"))

  rate_limit_info <- sleep_data_raw$headers
  # head(sleep_data_transform$sleep)
  sleep_data_transform_keep <- sleep_data_transform$sleep[sleep_data_transform$sleep$isMainSleep==T,]

  #TODO: if dump all isMainSleep==F data, then still have some "classic" instead of "stages" data.

  sleep_data_output <- data.frame(date=sleep_data_transform_keep$dateOfSleep,
                                  sleep_score = sleep_data_transform_keep$efficiency,
                                  sleep_total_time_minutes = (sleep_data_transform_keep$duration/1000/60),
                                  min_in_awake=NA,
                                  min_in_REM=NA,
                                  min_in_light=NA,
                                  min_in_deep=NA)


  for(date_ind in 1:length(unique(sleep_data_transform_keep$dateOfSleep))){

    if("wake" %in% sleep_data_transform_keep$levels$data[[date_ind]]$level){

      sleep_data_output[date_ind,"min_in_awake"] <- sum(sleep_data_transform_keep$levels$data[[date_ind]]$seconds[which(sleep_data_transform_keep$levels$data[[date_ind]]$level=="wake")])/60

    }


    if("rem" %in% sleep_data_transform_keep$levels$data[[date_ind]]$level){

      sleep_data_output[date_ind,"min_in_REM"] <- sum(sleep_data_transform_keep$levels$data[[date_ind]]$seconds[which(sleep_data_transform_keep$levels$data[[date_ind]]$level=="rem")])/60

    }


    if("light" %in% sleep_data_transform_keep$levels$data[[date_ind]]$level){

      sleep_data_output[date_ind,"min_in_light"] <- sum(sleep_data_transform_keep$levels$data[[date_ind]]$seconds[which(sleep_data_transform_keep$levels$data[[date_ind]]$level=="light")])/60

    }


    if("deep" %in% sleep_data_transform_keep$levels$data[[date_ind]]$level){

      sleep_data_output[date_ind,"min_in_deep"] <- sum(sleep_data_transform_keep$levels$data[[date_ind]]$seconds[which(sleep_data_transform_keep$levels$data[[date_ind]]$level=="deep")])/60

    }



  }



  #TODO: what to do about naps? got rid of

  # sleep_data_output <- sleep_data_output




  return(list(sleep_data_output=sleep_data_output,
              rate_limit_info=rate_limit_info))

}
