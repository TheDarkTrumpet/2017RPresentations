install.packages("plyr")
install.packages("ggplot2")
install.packages("RODBC")

library("plyr")
library("ggplot2")
library("RODBC")

connectionString <- "driver=freetds;DSN=SqlServer;Database=WorldWideImporters;UID=sa;Pwd=pAssw04d"
dbhandle <- odbcDriverConnect(connectionString)
allData <- sqlQuery(dbhandle, 'select c.CityName, c.Location AS CityLocation, c.LatestRecordedPopulation as CityPopulation,
  s.StateProvinceCode, s.StateProvinceName, s.Border as StateBorder, s.LatestRecordedPopulation as StatePopulation
  from Application.Cities c left join Application.StateProvinces s ON c.StateProvinceId = s.StateProvinceID')
close(dbhandle)