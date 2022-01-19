xml_grandparent <- function(node) xml_parent(xml_parent(node))

parse_xml <- function(xmlzip) {
  cat(sprintf("Parsing election results found in %s ...\n", xmlzip))
  
  res <- safely(xml2::read_xml)(xmlzip)
  if (!is.null(res$error)) {
    return(NULL)
  }
  else{
    res <- res$result
  }
  timestamp <- xml_find_first(res, "/ElectionResult/Timestamp") %>% 
                  xml_text() %>%
                  parse_date_time("%m/%d/%Y %H:%M:%S %p") 
  election_date <- xml_find_first(res, "/ElectionResult/ElectionDate") %>% xml_text()
  election_name <- xml_find_first(res, "//ElectionResult/ElectionName") %>% xml_text()
  county <- xml_find_first(res, "//Region") %>% xml_text()
  turnout_block <- xml_find_all(res, "/ElectionResult/VoterTurnout/Precincts/Precinct")
  if (length(turnout_block)==0) {
     turnout_by_precinct <- data.frame(precinct = character(0))
  }
  else {
    turnout_by_precinct <- turnout_block %>%
                            map_df(~data.frame(precinct = xml_attr(.x, "name"),
                                               ballots_cast_all_ways = as.integer(xml_attr(.x, "ballotsCast")),
                                               total_voters = as.integer(xml_attr(.x, "totalVoters")),
                                               precent_reporting = as.integer(xml_attr(.x, "percentReporting")))) %>%
                            rename_with(.cols = -precinct, function(nm) paste0("VTOR_", nm))
  }
  votes <- xml_find_all(res, "Contest") %>%
             map_df(function(contest) {
                contest_name <- xml_attr(contest, "text")
                votetype_block <- xml_find_all(contest, "./VoteType/Precinct")
                if (length(votetype_block) == 0) {
                  voteType = data.frame(precinct = character(0))
                }
                else {
                  voteType <-  votetype_block %>%
                     map_df(function(precinct) {
                        data.frame(precinct = xml_attr(precinct, "name"),
                                   value = as.integer(xml_attr(precinct, "votes")),
                                   label = xml_attr(xml_parent(precinct), "name"))
                     }) %>%
                     pivot_wider(names_from = label, values_from = value) %>%
                     rename_with(.cols = -precinct, function(nm) paste0("VTR_", nm, "_all_ways")) 
                }
                xml_find_all(contest, "./Choice/VoteType/Precinct") %>%
                  map_df(function(choice) {
                    data.frame(county = county,
                               election = election_name,
                               date = election_date,
                               timestamp = timestamp,
                               contest = contest_name,    
                               is_question = xml_attr(contest, "isQuestion") == "true",
                               candidate = xml_attr(xml_grandparent(choice), "text"),
                               precinct = xml_attr(choice, "name"),
                               vote_type = xml_attr(xml_parent(choice), "name"),
                               votes = as.integer(xml_attr(choice, "votes")),
                               countywide_cand_vote_total_by_mode = as.integer(xml_attr(xml_parent(choice), "votes")),
                               countywide_cand_vote_total = as.integer(xml_attr(xml_grandparent(choice), "totalVotes")))
    
                  }) %>%
                  left_join(voteType, by = "precinct")
             }) %>%
             left_join(turnout_by_precinct, by="precinct") 
}

#parse_xml("precinct_xml/detail_107556_275242_Liberty.zip") %>%
#  glimpse()