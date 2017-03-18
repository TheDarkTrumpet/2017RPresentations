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

# Order it by State (not in reverse order) ### WORKING ON###
StateGraph <- qplot(data = order_by(State, Population, StateCounts), State, y=Population, fill=Population, geom="blank"
) + coord_flip() + geom_bar(stat = "identity")
plot(StateGraph)

# Graph sorted by Population
StateGraph <- qplot(data = SortedStateCounts, x=reorder(State, -Population), y=Population, fill=Population, geom="blank"
) + coord_flip() + geom_bar(stat = "identity")
plot(StateGraph)