#' Collect fitbit heartrate data
#'
#' @param token The token you received from `fitbitr` function \code{\link[fitbitr]{oauth_token}}
#' @param start_date The date that you want to start collecting the data in "YYYY-MM-DD" format. If `NULL` (default) then it chooses yesterday.
#' @param period_to_collect Resolution of the data to collect. Default is `1m` (one month). Options are "1d", "7d", "30d", "1w", "1m".
#' @param intraday T/F for whether to collect intraday data
#'
#' @return
#' @export
#'
#' @import fitbitr
#' @import lubridate
#'
#' @examples
collect_heartrate <- function(token, start_date=NULL, period_to_collect="1m", intraday=T){

  # set date as yesterday if we do not have a date
  if(is.null(start_date)){
    this_date <- lubridate::today()-1
  }else{
    this_date = as.Date(start_date)
  }

  # get data
  heartrate_df <- fitbitr::get_heart_rate_time_series(token, date= as.character(this_date), period=period_to_collect, simplify = F)

  # initialize data for output
  heartrate_df_out <- data.frame(date=heartrate_df$`activities-heart`$dateTime,
                                 resting_hr = heartrate_df$`activities-heart`$value$restingHeartRate,
                                 time_in_fat_burn = NA,
                                 time_in_cardio = NA,
                                 time_in_peak = NA,
                                 min_fatburn = NA,
                                 max_fatburn = NA,
                                 min_cardio = NA,
                                 max_cardio = NA,
                                 min_peak = NA,
                                 max_peak = NA
  )


  # loop through the dates to get the time in each zone

  for(this_date_ind in 1:nrow(heartrate_df_out)){

    if(!is.null(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$minutes[
      which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Fat Burn")])){

      heartrate_df_out[this_date_ind,"time_in_fat_burn"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$minutes[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Fat Burn")]

      heartrate_df_out[this_date_ind,"min_fatburn"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$min[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Fat Burn")]

      heartrate_df_out[this_date_ind,"max_fatburn"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$max[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Fat Burn")]


      heartrate_df_out[this_date_ind,"time_in_cardio"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$minutes[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Cardio")]

      heartrate_df_out[this_date_ind,"min_cardio"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$min[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Cardio")]

      heartrate_df_out[this_date_ind,"max_cardio"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$max[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Cardio")]

      heartrate_df_out[this_date_ind,"time_in_peak"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$minutes[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Peak")]


      heartrate_df_out[this_date_ind,"min_peak"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$min[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Peak")]

      heartrate_df_out[this_date_ind,"max_peak"] <-
        heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$max[
          which(heartrate_df$`activities-heart`$value$heartRateZones[[this_date_ind]]$name=="Peak")]
    }

  }


  # intraday heartrate
  if(intraday){

    # convert fitbit language to days
    period_to_collect_choices <- stats::setNames(object = c(1,7,30,7,30), nm = c("1d", "7d", "30d", "1w", "1m"))
    days_prior_to_start <- as.numeric(period_to_collect_choices[period_to_collect])

    # create list to hold heartrate data
    dates_to_calc <- seq(to=this_date,from=(this_date-days_prior_to_start),"days")
    hr_list <- vector(mode = "list", length = length(dates_to_calc))
    names(hr_list)  <- as.character(dates_to_calc)

    for(this_date_ind in 1:length(dates_to_calc)){

      this_date <- dates_to_calc[this_date_ind]
      hr_list[[this_date_ind]] <- fitbitr::get_heart_rate_intraday_time_series(token, date=this_date, detail_level="1min")
      message(paste0("Finished date: ", this_date, "... ", length(dates_to_calc)-this_date_ind, " dates left."))

    }



  }




  if(intraday){
    return(list(heartrate_daily_summary = heartrate_df_out,
                heartrate_intraday_data = hr_list
    ))
  }else{
    return(list(heartrate_daily_summary =heartrate_df_out))
  }

}
