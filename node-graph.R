library(RGoogleAnalytics)
library(httpuv)
library(RColorBrewer)

library(reshape)
library(data.table)

## General Comments on data:

## Setting up the working directory for the script.
## this will need to be altered to suit.
setwd("C://data//work-material//data//ga-query")
## Get working directory path
work_dir <- getwd()

## Function for exporting tables to CSVs. 
##Directory path other than work directory and extension needs to be defined 'x', 'y' is the table to be exported.
file_output <- function (x, y){
  path <- paste(work_dir, x, sep ="")
  write.table(y, file = path, sep = ",", row.names = FALSE)
}

# Generate the oauth_token object
oauth_token <- Auth(client.id = "###",
                    client.secret = "###")
# Authenticate the token via browser.

# Save the token object for future sessions
save(oauth_token, file="oauth_token")
# Load the token object

## Retrieve a list of the profiles associated with the above token.
GetProfiles(oauth_token)

## To revalidate the token.
ValidateToken(oauth_token)

## Not run:
## Create the query required to import the data as appropriate.
# This example assumes that a token object is already created
# Create a list of Query Parameters
query.list <- Init(start.date = "2014-12-16",
                   end.date = "2014-12-30",
                   dimensions = "ga:previousContentGroup1,ga:nextContentGroup1",
                   metrics = "ga:pageviews",
                   max.results = 1000,
                   table.id = "####")
# Create the query object
ga.query <- QueryBuilder(query.list)
# Fire the query to the Google Analytics API
ga.df <- GetReportData(ga.query, oauth_token)
#ga.df <- GetReportData(ga.query, oauth_token, split_daywise=True)
#ga.df <- GetReportData(ga.query, oauth_token, paginate_query=True)
## End(Not run)

# Working table.
wip <- ga.df

wip$pageviews <- log(wip$pageviews)

wip_dt <- data.table(wip)

wip_dt$value <- wip_dt$value * 2

# Trivial example of manually specifying edge color and widths:
edge <- as.matrix(data.frame(wip_dt))
qgraph(edge, mode="direct",edge.color=brewer.pal(8, "Dark2"))