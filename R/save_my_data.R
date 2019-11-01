#' Saves your fitbit data
#'
#' @param raw_data the data you created with `ECfitbitR::get_my_data`
#' @param save_directory directory to save fitbit data. Defaults to the desktop
#' @param clean_data the data from `clean_my_data`
#' @param MAC_or_PC Has to be either "MAC" or "PC"
#'
#' @return
#' @export
#'
#' @examples
save_my_data <- function(raw_data, clean_data, save_directory=NULL,MAC_or_PC="MAC"){


  if(MAC_or_PC == "MAC"){
  if(is.null(save_directory)){

    dir.create(path = file.path("~","Desktop","my_fitbit_data"),showWarnings = F)
    save_directory <- file.path("~","Desktop","my_fitbit_data")

  }else{
    dir.create(path = file.path(save_directory,"my_fitbit_data"),showWarnings = F)
    save_directory <- file.path(save_directory,"my_fitbit_data")

  }

  write.csv(x = clean_data$steps_intraday_summary,
            file = file.path(save_directory, "steps_intraday_summary.csv"),quote = F,row.names = F)

  write.csv(x = clean_data$activity_intraday_summary,
            file = file.path(save_directory, "activity_intraday_summary.csv"),quote = F,row.names = F)

  write.csv(x = clean_data$distance_intraday_summary,
            file = file.path(save_directory, "distance_intraday_summary.csv"),quote = F,row.names = F)

  write.csv(x = clean_data$calories_intraday_summary,
            file = file.path(save_directory, "calories_intraday_summary.csv"),quote = F,row.names = F)

  write.csv(x = raw_data$my_heartrate_data$heartrate_daily_summary,
            file = file.path(save_directory, "heartrate_summary.csv"),quote = F,row.names = F)

  write.csv(x = clean_data$heartrate_intraday_summary,
            file = file.path(save_directory, "heartrate_intraday_summary.csv"),quote = F,row.names = F)

  write.csv(x = raw_data$my_sleep_data$sleep_data_output,
            file = file.path(save_directory, "sleep_summary.csv"),quote = F,row.names = F)

  }




  if(MAC_or_PC=="PC"){
    if(is.null(save_directory)){

      dir.create(path = file.path(path.expand("~"),"my_fitbit_data",fsep="\\"),showWarnings = F)
      save_directory <- file.path(path.expand("~"),"my_fitbit_data",fsep="\\")

    }else{
      dir.create(path = file.path(save_directory,"my_fitbit_data",fsep="\\"),showWarnings = F)
      save_directory <- file.path(save_directory,"my_fitbit_data",fsep = "\\")

    }

    write.csv(x = clean_data$steps_intraday_summary,
              file = file.path(save_directory, "steps_intraday_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = clean_data$activity_intraday_summary,
              file = file.path(save_directory, "activity_intraday_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = clean_data$distance_intraday_summary,
              file = file.path(save_directory, "distance_intraday_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = clean_data$calories_intraday_summary,
              file = file.path(save_directory, "calories_intraday_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = raw_data$my_heartrate_data$heartrate_daily_summary,
              file = file.path(save_directory, "heartrate_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = clean_data$heartrate_intraday_summary,
              file = file.path(save_directory, "heartrate_intraday_summary.csv",fsep = "\\"),quote = F,row.names = F)

    write.csv(x = raw_data$my_sleep_data$sleep_data_output,
              file = file.path(save_directory, "sleep_summary.csv",fsep = "\\"),quote = F,row.names = F)
  }
}
