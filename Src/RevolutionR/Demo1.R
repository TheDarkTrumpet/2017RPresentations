install.packages("RODBC")

library(RODBC) 

# Connection strings
# odbcDriverConnect('driver={SQL Server};server=localhost;Initial Catalog=AdventureWorks2016;UID=rUser;Pwd=test')

# Method 1 - Connect with a specific user/pass
dbhandle <- odbcDriverConnect('driver={SQL Server};server=localhost;Database=AdventureWorks2016;UID=rUser;Pwd=test')
res <- sqlQuery(dbhandle, 'select * from Sales.vSalesPerson')
close(dbhandle)


# Method 2 - Connect with a trusted connection
dbhandle <- odbcDriverConnect('driver={SQL Server};server=localhost;Database=AdventureWorks2016;trusted_connection=true')
res2 <- sqlQuery(dbhandle, 'select * from Sales.vSalesPerson')
allData <- sqlFetch(dbhandle, "Sales.VSalesPerson")
close(dbhandle)

dbhandle
summary(res2)

library(ggplot2)
ggplot(res2, aes(x = BusinessEntityID, y = SalesYTD)) + geom_line()
plot(x = res2$BusinessEntityID, y=res2$SalesYTD)



# K-Means Clustering

# Load Data
dbhandle <- odbcDriverConnect('driver={SQL Server};server=localhost;Database=AdventureWorks2016;trusted_connection=true')
res2 <- sqlQuery(dbhandle, 'select * from Sales.vSalesPerson')
allData <- sqlFetch(dbhandle, "Sales.VSalesPerson")
close(dbhandle)

# install.packages("hsaur")
library(cluster)
library(HSAUR)
clusterData <- data.frame(BusinessEntityId = allData$BusinessEntityID, YTDAmt = allData$SalesYTD)

km    <- kmeans(clusterData,3)
dissE <- daisy(clusterData)
dE2   <- dissE^2
sk2   <- silhouette(km$cl, dE2)
plot(sk2)

# install.packages("fpc")
library(fpc)
plotcluster(clusterData, km$cluster)