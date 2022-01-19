get_participating_counties <- function(sw_eid, sw_vid) {
  url <- sprintf("https://www.enr-scvotes.org/SC/%i/%i/json/en/electionsettings.json",
                 as.integer(sw_eid), as.integer(sw_vid))
  res <- safely(fromJSON)(url) # Catch 404 errors for old elections using different system...
  if (!is.null(res$error)) {
    return(NULL)
  }
  res <- res$result
  res$settings$electiondetails$participatingcounties %>%
    as.data.frame() %>%
    rename("x" = ".") %>%
    separate(x, sep="\\|", 
             into=c("county", "eid", "vid", "timestamp", "z")) %>%
    mutate(sw_eid = sw_eid,
           sw_vid = sw_vid) %>%
    select(starts_with("sw"), everything())
}
#get_participating_counties(106502, 277849)