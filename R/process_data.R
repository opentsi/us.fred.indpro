#' Process INDPRO Data into series.csv
#'
#' Fetches the most recent vintage of the Industrial Production: Total Index
#' (INDPRO) from FRED and writes it to \code{data-raw/indpro/series.csv}.
#'
#' @importFrom alfred get_fred_series
#' @param key Directory name under \code{data-raw/} where the CSV is written.
#'   Defaults to \code{"indpro"}.
#' @return Invisibly returns the output file path.
#' @export
process_data <- function(key = "indpro") {
  ts_data <- alfred::get_fred_series("INDPRO", "indpro")

  ts_df <- data.frame(
    time  = as.Date(ts_data$date),
    value = ts_data$indpro
  )

  print(head(ts_df))
  output_path <- file.path(".", "data-raw", key, "series.csv")
  write.csv(ts_df, file = output_path, row.names = FALSE)
  message(sprintf("Latest vintage of INDPRO written to %s", output_path))

  invisible(output_path)
}
