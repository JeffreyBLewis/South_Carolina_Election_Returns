library(targets)
library(purrr)
library(tidyverse)
library(jsonlite)
library(httr)
library(lubridate)
library(xml2)

walk(list.files(path="R", pattern="*R$", full.names=TRUE), source)
tar_option_set(packages = c("tidyverse", "purrr", "rvest", "jsonlite",
                            "httr", "lubridate", "xml2"))
list(
  tar_target(
    elections,
    {
      eid <- get_election_ids()
      data.frame(eid = eid,
                 vid = map_dbl(eid, get_current_version))
    }
  ),
  tar_target(
    participating_counties,
    map2_df(elections$eid, elections$vid, get_participating_counties)
  ),
  tar_target(
    download_xml,
    get_precinct_xml(participating_counties)
  ),
  tar_target(
    precinct_level_data,
    list.files("precinct_xml", pattern="*zip$", full.name=TRUE) %>%
      map_df(parse_xml)
  ),
  tar_target(
    precinct_data_csv,
    { 
      csv_fn <- "csv/SC_precinct_level_election_returns.csv.gz"
      write_csv(precinct_level_data, csv_fn)
      csv_fn 
    },
    format = "file"
  )
)
