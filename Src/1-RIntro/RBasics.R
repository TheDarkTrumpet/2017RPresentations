install.packages("plyr")
install.packages("ggplot2")
install.packages("RODBC")

library("plyr")
library("ggplot2")
library("RODBC")

# Read from a SQL Database
connectionString <- "driver=freetds;DSN=SqlServer;Database=WorldWideImporters;UID=sa;Pwd=pAssw04d"
dbhandle <- odbcDriverConnect(connectionString)
allData <- sqlQuery(dbhandle, 'select c.CityName, c.LatestRecordedPopulation as CityPopulation,
  s.StateProvinceCode, s.StateProvinceName, s.LatestRecordedPopulation as StatePopulation
  from Application.Cities c left join Application.StateProvinces s ON c.StateProvinceId = s.StateProvinceID')
close(dbhandle)

# Write to a file
write.table(allData, file="/home/rstudio/src/Data/citylocs.csv", sep=",",qmethod="double")

# Read from a file
csvData <- read.table("/home/rstudio/src/Data/citylocs.csv", header=TRUE, sep=",", row.names=1)

# Summary Information
summary(csvData)

# Basic Graph
StateCounts <- unique(data.frame(State=csvData$StateProvinceName, Population=csvData$StatePopulation))
StateGraph <- qplot(data = StateCounts, x=State, y=Population, fill=Population, geom="blank"
  ) + coord_flip() + geom_bar(stat = "identity")
plot(StateGraph)

# Remove Scientific Notation
options(scipen=999)

# Sort the data set - two ways
SortedStateCounts <- StateCounts[order(StateCounts$Population),]

attach(StateCounts)
SortedStateCounts <- StateCounts[order(Population)]
detach(StateCounts)

# Graph sorted by Population
StateGraph <- qplot(data = SortedStateCounts, x=reorder(State, -Population), y=Population, fill=Population, geom="blank"
) + coord_flip() + geom_bar(stat = "identity")
plot(StateGraph)

# Small introduction to DataTable
library(data.table)
StateCountsTable <- data.table(StateCounts)
StateCountsTable <- StateCountsTable[order(-rank(State))]

### Fill in more examples here ###

# Order it by State (not in reverse order)
StateGraph <- qplot(data = StateCountsTable, x=State, y=Population, fill=Population, geom="blank"
) + coord_flip() + scale_x_discrete(limits = rev(levels(StateCountsTable$State))) + geom_bar(stat = "identity")
plot(StateGraph)

# A few States
AllStateCities <- data.table(allData)
interestedCols <- c("StateProvinceCode", "CityPopulation", "CityName")
IAMN <- AllStateCities[AllStateCities$StateProvinceCode == "IA" | AllStateCities$StateProvinceCode == "MN", interestedCols, with=FALSE]
IAMNOrder <- IAMN[order(-StateProvinceCode,-CityPopulation)]
IAMNTop10 <- rbind(head(IAMNOrder[IAMNOrder$StateProvinceCode == "IA"],10), head(IAMNOrder[IAMNOrder$StateProvinceCode == "MN"], 10))

# top_n -- attach weight function at the end may make all this simpler
# dtplyr
# dplyr - newer than plyr (Keeps everything in dataframe, less conversion)
IAMNTop10$StateProvinceCode <- factor(IAMNTop10$StateProvinceCode)
IAMNTop10$CityName <- factor(IAMNTop10$CityName)

Top10Graph <- ggplot(data = IAMNTop10, 
                    aes(x=CityName, y=CityPopulation, group=StateProvinceCode, fill=CityPopulation), 
                    geom="blank") + 
  scale_x_discrete(limits = rev(levels(IAMNTop10$CityName))) + 
  geom_bar(stat = "identity")
Top10Graph + facet_grid(StateProvinceCode ~ ., scales="free", space="free", drop=TRUE) + coord_flip()
# plot(Top10Graph)