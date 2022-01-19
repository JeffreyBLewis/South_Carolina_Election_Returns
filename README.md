South Carolina precinct-level election returns
================
Jeff Lewis
18 January 2022

\[This is a preliminary work in progress. Use at your own risk.\]

## Overview

This repository contains code to download and parse precinct-level
election returns from the state of Georgia. The code is written in
[`R`](https://www.r-project.org/) and uses the
[`targets`](https://books.ropensci.org/targets/) pipeline toolkit to
manage the production of the data.

The all of parsed and de-normalized data are contained in the file
`csv/SC_precinct_level_election_returns.csv.gz` in this repository.

The following two commands can be used to re-ingest and re-parse the
original source XML files found on the Sourch Carolina Secretary of
State’s [webpages](https://www.scvotes.gov/election-results).

``` r
source("_targets.R")
tar_make()
```

## Variables and unit of analysis

The variables contained in the data are as follows:

    ## Rows: 1,252,574
    ## Columns: 18
    ## $ county                             <chr> "Abbeville", "Abbeville", "Abbevill…
    ## $ election                           <chr> "2020 - Statewide Primaries - RECOU…
    ## $ date                               <chr> "6/12/2020", "6/12/2020", "6/12/202…
    ## $ timestamp                          <dttm> 2020-06-12 10:57:50, 2020-06-12 10…
    ## $ contest                            <chr> "BALLOTS CAST - Democratic", "BALLO…
    ## $ is_question                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, …
    ## $ candidate                          <chr> "BALLOTS CAST - Democratic", "BALLO…
    ## $ precinct                           <chr> "Abbeville No. 1", "Abbeville No. 2…
    ## $ vote_type                          <chr> "Election Day", "Election Day", "El…
    ## $ votes                              <int> 68, 142, 65, 34, 32, 24, 163, 34, 1…
    ## $ countywide_cand_vote_total_by_mode <int> 775, 775, 775, 775, 775, 775, 775, …
    ## $ countywide_cand_vote_total         <int> 1095, 1095, 1095, 1095, 1095, 1095,…
    ## $ VTR_regVotersCounty_all_ways       <int> 1596, 1521, 1307, 836, 1144, 493, 1…
    ## $ VTOR_ballots_cast_all_ways         <int> 413, 312, 260, 196, 226, 98, 338, 2…
    ## $ VTOR_total_voters                  <int> 1596, 1521, 1307, 836, 1144, 493, 1…
    ## $ VTOR_precent_reporting             <int> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
    ## $ VTR_overVotes_all_ways             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ VTR_underVotes_all_ways            <int> NA, NA, NA, NA, NA, NA, NA, NA, NA,…

Each row shows the number votes cast in the given manner (election day,
absenteee, etc) in the given precinct in the given contest for the given
candidate. In total, the data contain 1,252,574 records across 10
elections, 998 contests, and 3,540 precincts.

Note that the variable with names that start with `VTR_` are drawn from
the “voter type” data included in the source XML files and the variables
with names that start with `VTOR_` are drawn from the “voter turnout”
data included in the source XML files. Those variables are *not* broken
down by mode of voting. For example, the variable
`VTOR_ballots_cast_all_ways` includes the total of *all* ballots cast by
any method in the given precinct in the given election and not just
those ballots cast by the method indicated by the `vote_type` variable.

The variable `VTOR_total_voters` displays the total number of registered
voters the given precinct at the time of given election. The `timestamp`
variable indicates the time at which reported tally of votes was
recorded by the vote tabulation system. The `is_question` indicates
whether the given contest was a ballot question (as opposed to the
candidate election).

## Elections Covered

The elections included in the dataset are the following:

| Date       | Election                                    | Records |
|:-----------|:--------------------------------------------|--------:|
| 2020-11-07 | 2020 Statewide General Election Recount     |   13218 |
| 2020-11-03 | 2020 Statewide General Election             |  696360 |
| 2020-06-26 | 2020 Statewide Primaries - RUNOFF - RECOUNT |     576 |
| 2020-06-23 | 2020 Statewide Primaries - RUNOFF           |   16662 |
| 2020-06-12 | 2020 - Statewide Primaries - RECOUNT        |  265446 |
| 2020-06-12 | 2020 Statewide Primaries - RECOUNT          |   10380 |
| 2018-11-06 | 2018 Statewide General Elections            |  155327 |
| 2018-06-26 | 2018 Statewide Primaries - RECOUNT          |    3473 |
| 2018-06-19 | 2018 Statewide Primaries - RUNOFF           |   12778 |
| 2018-06-12 | 2018 Statewide Primaries                    |   78354 |
