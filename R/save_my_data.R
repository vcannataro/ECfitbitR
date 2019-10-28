#' Saves your fitbit data
#'
#' @param raw_data the data you created with `ECfitbitR::get_my_data`
#' @param cleaned_data the data you created with `ECfitbitR::clean_my_data`
#' @param save_directory directory to save fitbit data. Defaults to the desktop
#'
#' @return
#' @export
#'
#' @examples
save_my_data <- function(raw_data, clean_data, save_directory=NULL){

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




}
