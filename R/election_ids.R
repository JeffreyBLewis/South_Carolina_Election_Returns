get_election_ids <- function() {
  read_html("https://www.scvotes.gov/election-results") %>%
    html_nodes("#block-sc-votes-theme-content a") %>%
    html_attr("href") %>%
    str_extract("(?<=enr-scvotes\\.org/SC/)\\d+") %>%
    na.omit() %>%
    as.integer()
}
#get_election_ids()