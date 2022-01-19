sGET <- safely(GET)

get_precinct_xml <- function(participating_counties) {
  participating_counties %>%
    pwalk(function(...) {
      current <- tibble(...)
      if (current$county != "-1") {
        url <- sprintf("https://www.enr-scvotes.org/SC/%s/%i/%i/reports/detailxml.zip",                   
                       current$county,
                       as.integer(current$eid), 
                       as.integer(current$vid))
        destfile <- sprintf("precinct_xml/detail_%i_%i_%s_%s.zip",
                            as.integer(current$eid),
                            as.integer(current$vid),
                            current$county,
                            current$timestamp %>% 
                              parse_date_time("%m/%d/%Y %H:%M:%S %p") %>%
                              str_replace(" UTC$", "") %>%
                              str_replace(" ", "_"))
        cat(sprintf("Getting %s...", destfile))
        res <- sGET(url)
        if (!is.null(res$result)) {    
          if (status_code(res$result) == 200) { 
            writeBin(content(res$result, as="raw"), destfile) 
            cat("sucess!\n")
          }
          else {
            cat(sprintf("failed (%i)\n", status_code(res$result)))
          }
        }
      }
    })
  "completed"
}


