install.packages("plyr")
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("dtplyr")
install.packages("dplyr")
install.packages("RODBC")

library(plyr)
library(ggplot2)
library(RODBC)
library(gridExtra)
library(data.table)
library(dtplyr)
library(dplyr)

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
SortedStateCounts <- StateCounts[order(Population),]
detach(StateCounts)

# Graph sorted by Population
StateGraph <- qplot(data = SortedStateCounts, x=reorder(State, -Population), y=Population, fill=Population, geom="blank"
) + coord_flip() + geom_bar(stat = "identity")
plot(StateGraph)

# Subset of state population
stateGraphSubset <- SortedStateCounts %>%
  filter(State %in% c('Wyoming', 'Vermont', 'District of Columbia'))

stateSubsetGraph <- qplot(data = stateGraphSubset, x=reorder(State, -Population), y=Population, fill=Population, geom="blank"
) + coord_flip() + geom_bar(stat = "identity")
plot(stateSubsetGraph)

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
IAMN <- data.table(AllStateCities[AllStateCities$StateProvinceCode == "IA" | AllStateCities$StateProvinceCode == "MN" | AllStateCities$StateProvinceCode == "CA"
                       | AllStateCities$StateProvinceCode=="TX", interestedCols, with = FALSE])
IAMN[is.na(IAMN)] <- 0
IAMNOrder <- IAMN[order(-StateProvinceCode,-CityPopulation)]
IAMNTop10 <- rbind(head(IAMNOrder[IAMNOrder$StateProvinceCode == "IA"],10), head(IAMNOrder[IAMNOrder$StateProvinceCode == "MN"], 10),
                   head(IAMNOrder[IAMNOrder$StateProvinceCode == "CA"],10), head(IAMNOrder[IAMNOrder$StateProvinceCode == "TX"],10))

# top_n -- attach weight function at the end may make all this simpler
# dtplyr
# dplyr - newer than plyr (Keeps everything in dataframe, less conversion)
IAMNTop10$StateProvinceCode <- as.character(IAMNTop10$StateProvinceCode)
IAMNTop10$CityName <- as.character(IAMNTop10$CityName)
IAMNTop10$CityPopulation <- as.numeric(IAMNTop10$CityPopulation)

Top10GraphIA <- ggplot(data = IAMNTop10[IAMNTop10$StateProvinceCode == "IA",], 
                    aes(x=CityName, y=CityPopulation)) + 
  geom_bar(stat = "identity") + xlab("City") + ylab("City Population") + coord_flip() +
  ggtitle("Iowa")
Top10GraphMN <- ggplot(data = IAMNTop10[IAMNTop10$StateProvinceCode == "MN",], 
         aes(x=CityName, y=CityPopulation)) +
  geom_bar(stat = "identity") + xlab("City") + ylab("City Population") + coord_flip() +
  ggtitle("Minneapolis")
# Fix later
Top10GraphCA <- ggplot(data = IAMNTop10[IAMNTop10$StateProvinceCode == "CA",], 
                       aes(x=CityName, y=CityPopulation)) +
  geom_bar(stat = "identity") + xlab("City") + ylab("City Population") + coord_flip() +
  ggtitle("California")
Top10GraphTX <- ggplot(data = IAMNTop10[IAMNTop10$StateProvinceCode == "TX",], 
                       aes(x=CityName, y=CityPopulation)) +
  geom_bar(stat = "identity") + xlab("City") + ylab("City Population") + coord_flip() +
  ggtitle("Texas")


grid.arrange(Top10GraphIA, Top10GraphMN, Top10GraphCA, Top10GraphTX, padding=unit(1,"line"))

# Alternate way of graphing
il_mn_wi_top <- allData %>%
  filter(StateProvinceCode %in% c('IL', 'MN', 'WI')) %>%
  group_by(StateProvinceCode) %>%
  top_n(n = 5, CityPopulation) %>%
  select(StateProvinceCode, CityName, CityPopulation, everything()) %>%
  arrange(StateProvinceCode, -CityPopulation) %>%
  mutate(top = TRUE)

ggplot(il_mn_wi_top, aes(x = CityName, y = CityPopulation)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(StateProvinceName ~ .) + 
  coord_flip() + 
  theme_bw() + 
  xlab("City Name") + 
  ylab("Population")