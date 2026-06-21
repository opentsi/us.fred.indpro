library(deloRean)
library(opentimeseries)

## Example Step 2, Generate History


library(alfred)
library(data.table)
library(tsbox)


indpro <- get_alfred_series("INDPRO", "indpro")
indpro_dt <- data.table::as.data.table(indpro)
head(indpro_dt)

# Get unique vintage (realtime) dates, sorted chronologically
vintage_dates <- sort(unique(indpro_dt$realtime_period))

# Build a named list: one tsbox-compatible data.table per vintage
tsl <- lapply(vintage_dates, function(vdate) {
  indpro_dt[realtime_period == vdate, .(time = date, value = indpro)]
})
names(tsl) <- paste0("idx.", format(vintage_dates, "%Y-%m")) # only 1 series: idx


## Step 3: Create vintages data.table
vintages_dt <- create_vintage_dt(vintage_dates, tsl)
head(vintages_dt, n = 100)

archive_import_history(vintages_dt, repository_path = ".")


## Step 5: Write & Validate Metadata

# check if info is available via api
indpau_meta <- read_dataset_ts_metadata("ch.fso.indpau")

render_metadata()
meta <- read_metadata(".")
validate_metadata(meta) # TRUE

## Step 6: Write handle_update & process_data

## Step 7: Seal Archive
devtools::load_all()
library(digest)
checksum_input <- generate_checksum_input()
archive_seal(checksum_input)

## Step 8: Check CRON schedule
# check if the cron schedule in .github/workflows/update_data.yaml
# is adequate for the dataset

## Step 9: Final Checks & Automation
devtools::load_all()
handle_update()

library(devtools)
check()
document()

## Step 10: Build Readme
# 1. write an example tsplot into the last code snippet of the Readme.Rmd
# 2. push the package & transfer to opentsi if needed (s.t. the example works)
build_readme() # 3.
