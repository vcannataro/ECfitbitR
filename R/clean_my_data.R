#' Clean my FitBit data for classroom analyses
#'
#' @param my_fitbit_data data structure saved from the `ECfitbitR::get_my_data(token=token)` function call.
#'
#' @return
#' @export
#'
#' @import dplyr
#' @import magrittr
#' @import tidyr
#'
#' @examples
clean_my_data <- function(my_fitbit_data){

  ## clean activity data ----

  # + calories ----
  # get calories data
  calories_intraday <- do.call(what = rbind, args = my_fitbit_data$my_activity_data$calories_list)

  # format the date and time
  calories_intraday$date_clean <-
    as.POSIXct(paste0(calories_intraday$dateTime, " ", calories_intraday$dataset_time), format="%Y-%m-%d %H:%M:%S",tz = "EST")

  # break time into buckets
  calories_intraday_cut <- calories_intraday %>%
    dplyr::mutate(Timeframe_6hr_start = as.POSIXct(cut(date_clean, breaks="6 hours"),tz = "EST"))

  # sum those buckets
  calories_intraday_summary <- calories_intraday_cut %>%
    dplyr::group_by(Timeframe_6hr_start) %>%
    dplyr::summarize(total_calories = sum(dataset_value))

  # + active minutes ----
  # get activity data, found in calorie data

  # active minutes are within the calories data
  # For the activities/log/calories resource,
  # each data point also includes the level field that reflects calculated activity level for that time period
  # (0 - sedentary; 1 - lightly active; 2 - fairly active; 3 - very active.)
  # https://dev.fitbit.com/build/reference/web-api/activity/


  activity_intraday_summary <- calories_intraday_cut %>%
    dplyr::mutate(levels_factor = as.factor(dataset_level)) %>%
    dplyr::group_by(Timeframe_6hr_start, levels_factor, .drop=F) %>%
    dplyr::tally() %>%
    tidyr::spread(levels_factor, n)

  colnames(activity_intraday_summary) <- c("Date_time",
                                           "Minutes_sedentary",
                                           "Minutes_lightly_active",
                                           "Minutes_fairly_active",
                                           "Minutes_very_active")



  # + distance ----
  # get distance data
  distance_intraday <- do.call(what = rbind, args = my_fitbit_data$my_activity_data$distance_list)

  # format the date and time
  distance_intraday$date_clean <-
    as.POSIXct(paste0(distance_intraday$dateTime, " ", distance_intraday$dataset_time), format="%Y-%m-%d %H:%M:%S",tz = "EST")

  # find buckets to cut
  distance_intraday_cut <- distance_intraday %>%
    dplyr::mutate(Timeframe_6hr_start = as.POSIXct(cut(date_clean, breaks="6 hours"),tz = "EST"))

  # sum those buckets
  distance_intraday_summary <- distance_intraday_cut %>%
    dplyr::group_by(Timeframe_6hr_start) %>%
    dplyr::summarize(total_distance_km = sum(dataset_value)) # looks like it is kilometers on test output


  # + steps
  steps_intraday <- do.call(what = rbind, args = my_fitbit_data$my_activity_data$steps_list)

  # format the date and time
  steps_intraday$date_clean <-
    as.POSIXct(paste0(steps_intraday$dateTime, " ", steps_intraday$dataset_time), format="%Y-%m-%d %H:%M:%S",tz = "EST")

  # find buckets to cut
  steps_intraday_cut <- steps_intraday %>%
    dplyr::mutate(Timeframe_6hr_start = as.POSIXct(cut(date_clean, breaks="6 hours"),tz = "EST"))

  # sum those buckets
  steps_intraday_summary <- steps_intraday_cut %>%
    dplyr::group_by(Timeframe_6hr_start) %>%
    dplyr::summarize(total_steps = sum(dataset_value))


  # clean heartrate data ----

  for(day_ind in 1:length(my_fitbit_data$my_heartrate_data$heartrate_intraday_data)){
    my_fitbit_data$my_heartrate_data$heartrate_intraday_data[[day_ind]]$date <-
      names(my_fitbit_data$my_heartrate_data$heartrate_intraday_data)[day_ind]
  }

  # need to find and eliminate dates with missing data
  # find rows of recordings for every date
  rows_in_data <- unlist(lapply(X = my_fitbit_data$my_heartrate_data$heartrate_intraday_data, FUN = function(x) nrow(x)))

  hr_intraday <- do.call(what = rbind, args = my_fitbit_data$my_heartrate_data$heartrate_intraday_data[names(rows_in_data)])

  # format the date and time
  hr_intraday$date_clean <-
    as.POSIXct(paste0(hr_intraday$date, " ", hr_intraday$time), format="%Y-%m-%d %H:%M:%S",tz = "EST")

  # find buckets to cut
  hr_intraday_cut <- hr_intraday %>%
    dplyr::mutate(Timeframe_6hr_start = as.POSIXct(cut(date_clean, breaks="6 hours"),tz = "EST"))


  hr_cutoffs <- my_fitbit_data$my_heartrate_data$heartrate_daily_summary

  hr_cutoffs$date_clean <- as.POSIXct(hr_cutoffs$date, format="%Y-%m-%d",tz = "EST")

  # bad way to do this, students look away
  #

  hr_intraday_summary <- data.frame(Timeframe_6hr_start=unique(hr_intraday_cut$Timeframe_6hr_start),
                                    Minutes_not_in_zones=NA,
                                    Minutes_in_fat_burn=NA,
                                    Minutes_in_cardio=NA,
                                    Minutes_in_peak=NA)

  for(time_block in 1:nrow(hr_intraday_summary)){


    hr_intraday_summary[time_block, "Minutes_not_in_zones"] <-
      length(which(hr_intraday_cut$Timeframe_6hr_start %in% hr_intraday_summary[time_block,"Timeframe_6hr_start"] &
                     hr_intraday_cut$value < hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"min_fatburn"]))

    hr_intraday_summary[time_block,"Minutes_in_fat_burn"] <-
      length(which(hr_intraday_cut$Timeframe_6hr_start %in% hr_intraday_summary[time_block,"Timeframe_6hr_start"] &
                     hr_intraday_cut$value >= hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"min_fatburn"] &
                     hr_intraday_cut$value < hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"max_fatburn"]))



    hr_intraday_summary[time_block,"Minutes_in_cardio"] <-
      length(which(hr_intraday_cut$Timeframe_6hr_start %in% hr_intraday_summary[time_block,"Timeframe_6hr_start"] &
                     hr_intraday_cut$value >= hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"min_cardio"] &
                     hr_intraday_cut$value < hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"max_cardio"]))

    hr_intraday_summary[time_block,"Minutes_in_peak"] <-
      length(which(hr_intraday_cut$Timeframe_6hr_start %in% hr_intraday_summary[time_block,"Timeframe_6hr_start"] &
                     hr_intraday_cut$value >= hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"min_peak"] &
                     hr_intraday_cut$value < hr_cutoffs[lubridate::date(hr_cutoffs$date_clean) %in% lubridate::date(hr_intraday_summary[time_block,"Timeframe_6hr_start"]),"max_peak"]))




  }

  hr_intraday_summary <- hr_intraday_summary %>%
    dplyr::rowwise() %>%
    mutate(total_minutes_recorded = sum(Minutes_not_in_zones,
                                        Minutes_in_fat_burn,
                                        Minutes_in_cardio,
                                        Minutes_in_peak))




  return(list(calories_intraday_summary=calories_intraday_summary,
              activity_intraday_summary=activity_intraday_summary,
              steps_intraday_summary=steps_intraday_summary,
              distance_intraday_summary=distance_intraday_summary,
              heartrate_intraday_summary=hr_intraday_summary))


}
