get_current_version <- function(eid) {
  sprintf("https://www.enr-scvotes.org/SC/%i/current_ver.txt", 
          as.integer(eid)) %>%
    scan()
}


  