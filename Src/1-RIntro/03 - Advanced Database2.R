connectionStr <- "Server=localhost;Initial Catalog=AdventureWorks2016;UID=rUser;Pwd=test"

# Read from SQL Server tables
dataContext <- RxSqlServerData(table="Sales.vSalesPerson", connectionString = connectionStr, rowsPerRead = 20000)

# Debug: rxGetVarInfo(data=dataContext)

# Open the source, read into data.
rxOpen(dataContext)
dataOut <- rxReadNext(dataContext)
rxClose(dataContext)

# Show some data
summary(dataOut)
require(plyr)
names <- adply(dataOut, 1, function(x) { paste(x$FirstName, x$LastName, sep=' ') })$V1
namesDataTable <- data.frame(People = names)


# Save it back. (not complete) -- note: check before ICC
writer <- RxSqlServerData(connectionString = connectionStr, table="SimpleUserList", rowsPerRead=20000)
rxDataStep(inData=namesDataTable, writer, overwrite=TRUE)


##########################################################################################
# Use trusted connections instead

instance_name <- ".";
database_name <- "AdventureWorks2016";
myConnString <- paste("Server=",instance_name, ";Database=",database_name,";Trusted_Connection=true;",sep="");

# Set other variables used to define the compute context
sqlWait = TRUE;
sqlConsoleOutput = TRUE;

# Read from a table
dataContext2 <- RxSqlServerData(table="Sales.vSalesPerson", connectionString = myConnString, rowsPerRead = 20000)

rxOpen(dataContext2)
data <- rxReadNext(dataContext2)
rxClose(dataContext2)

##########################################################################################
# Run stuff within SQL Server
sqlCompute <- RxInSqlServer(connectionString = connectionStr, wait = TRUE , consoleOutput = TRUE,
                            traceEnabled = TRUE, traceLevel = 7)
rxSetComputeContext(sqlCompute)
summaryOfVSales <- rxSummary(formula=~.,data = dataContext)

# Sets it back locally
rxSetComputeContext("local")
summaryOfVSalesLocal <- rxSummary(formula=~., data=dataOut)