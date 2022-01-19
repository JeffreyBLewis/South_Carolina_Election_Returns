Georgia Precinct-level election returns
================
Jeff Lewis
14 January 2022

## Overview

This repository contains code to download and parse precinct-level
election returns from the state of Georgia. The code is written in
[`R`](https://www.r-project.org/) and uses the
[`targets`](https://books.ropensci.org/targets/) pipeline toolkit to
manage the production of the data.

The all of parsed and de-normalized are contained in the file
`csv/GA_precinct_level_election_returns.csv.gz` in this repository.

The following two commands can be used to re-ingest and re-parse the
original source XML files found on the Georgia Secretary of State’s
[webpages](https://results.enr.clarityelections.com/GA/).

``` r
source("_targets.R")
tar_make()
```

## Variables and unit of analysis

The variables contained in the data are as follows:

    ## Rows: 1,976,680
    ## Columns: 19
    ## $ county                                       <chr> "Colquitt", "Colquitt", "…
    ## $ election                                     <chr> "January 28, 2020 HD 171 …
    ## $ date                                         <chr> "1/28/2020", "1/28/2020",…
    ## $ timestamp                                    <dttm> 2020-02-05 11:54:31, 202…
    ## $ contest                                      <chr> "State House District 171…
    ## $ is_question                                  <lgl> FALSE, FALSE, FALSE, FALS…
    ## $ candidate                                    <chr> "Tommy Akridge", "Tommy A…
    ## $ precinct                                     <chr> "Bridgecreek", "Doerun", …
    ## $ vote_type                                    <chr> "Election Day Votes", "El…
    ## $ votes                                        <int> 23, 13, 19, 7, 8, 11, 27,…
    ## $ countywide_cand_vote_total_by_mode           <int> 112, 112, 112, 112, 112, …
    ## $ countywide_cand_vote_total                   <int> 125, 125, 125, 125, 125, …
    ## $ VTR_Undervotes_all_ways                      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ VTR_Overvotes_all_ways                       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ VTOR_ballots_cast_all_ways                   <int> NA, NA, NA, NA, NA, NA, N…
    ## $ VTOR_total_voters                            <int> NA, NA, NA, NA, NA, NA, N…
    ## $ VTOR_precent_reporting                       <int> 4, 4, 4, 4, 4, 4, 4, 4, 4…
    ## $ `VTR_Number of Precincts for Race_all_ways`  <int> NA, NA, NA, NA, NA, NA, N…
    ## $ `VTR_Number of Precincts Reporting_all_ways` <int> NA, NA, NA, NA, NA, NA, N…

Each row shows the number votes cast in the given manner (election day,
absenteee, etc) in the given precinct in the given contest for the given
candidate. In total, the data contain 1,976,680 records across 28
elections, 1,770 contests, and 13,183 precincts.

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

| Date       | Election                                                                                            | Records |
|:-----------|:----------------------------------------------------------------------------------------------------|--------:|
| 2021-11-02 | November 2, 2021 - General Election                                                                 |    1484 |
| 2021-07-13 | July 13, 2021 - Special Election Runoff                                                             |     344 |
| 2021-06-15 | June 15, 2021- Special Election                                                                     |     592 |
| 2021-03-09 | March 9, 2021 - Special Primary Runoff                                                              |     120 |
| 2021-02-09 | February 9, 2021- Special Election                                                                  |     888 |
| 2021-01-05 | January 5, 2021 Federal Runoff                                                                      |   62768 |
| 2020-12-01 | December 1, 2020 Special Election Runoff                                                            |    2152 |
| 2020-11-16 | November 3rd General Election Recount                                                               |      12 |
| 2020-11-03 | November 3,2020-General Election                                                                    |  586628 |
| 2020-06-09 | Presidential Preference Primary – General Primary – Nonpartisan General Election – Special Election | 1003056 |
| 2020-03-24 | March 24, 2020 Presidential Preference Primary                                                      |  149932 |
| 2020-03-03 | March 3, 2020 SD 13 Special Election Runoff                                                         |     608 |
| 2020-02-04 | February 4, 2020 SD 13 Special Election                                                             |     912 |
| 2020-01-28 | January 28, 2020 HD 171 Special Election                                                            |     288 |
| 2019-12-03 | December 3, 2019 HD 152 Special Election Runoff                                                     |     232 |
| 2019-11-05 | November 5, 2019 HD 152 Special Election                                                            |     740 |
| 2019-10-01 | October 1, 2019 HD 71 Special Election Runoff                                                       |     104 |
| 2019-09-03 | September 3, 2019 HD 71 Special Election                                                            |     208 |
| 2019-04-09 | April 9, 2019 HD 28 Special Primary                                                                 |     136 |
| 2019-03-12 | March 12, 2019 Special Election Runoff                                                              |     136 |
| 2019-02-12 | February 12, 2019 Special Election                                                                  |     272 |
| 2019-02-05 | February 5, 2019 Special Election Runoff                                                            |      88 |
| 2019-01-08 | January 8, 2019 Special Election                                                                    |     264 |
| 2018-12-18 | December 18, 2018 HD 14 Special Republican Primary                                                  |     208 |
| 2018-12-04 | December 4, 2018 General Election Runoff                                                            |   47728 |
| 2018-12-04 | December 4, 2018 HD 28 Special Republican Primary                                                   |     136 |
| 2018-07-24 | July 24, 2018 General Primary Runoff Election                                                       |  115876 |
| 2018-01-09 | January 9, 2018 - Special Election                                                                  |     768 |
