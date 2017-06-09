# Basic Operators
1 + 1
5 * 5
20 / 5

# Comparison Operators
1 == 1
1 > 1
1 >= 1

# Coerce Example
"1" == 1
typeof("1")
typeof(1)

# Equality and Coercion
typeof(NULL)
"" == TRUE    # FALSE
"0" == TRUE   # FALSE
0 == NULL     # Logical(0)
0 == FALSE    # TRUE
1 == TRUE     # TRUE
"1" == TRUE   # FALSE
"1" == FALSE  # FALSE
"0" == TRUE   # FALSE

# Assigning and Math Operations
myVar <- 5
myVar
myVar <- myVar * myVar
myVar
myVar <- myVar - 10
myVar
myVar <- myVar + 7
myVar
myVar %% 20

# Find help on topic
help("+")
help("plot")
?help


# Writing a function
function(x) { x + 5 }

xPlus5 <- function(x) { x + 5 }

xPlus5(5)

# Create a data structure
x <- c("Foo", "Bar", 1, 2, 3, 4, 5, 6, 1, 2)
class(x)
x[2]
xl <- as.list(x)
class(xl)
xm <- matrix(x, ncol=2)
class(xm)
xm


xm2 <- matrix(x, ncol=2, byrow = TRUE)

# Get Headers
xm2[1,]

# Get Body
length(xm2)
xm2[-1,]

d <- as.data.frame(xm2[-1,], stringsAsFactors = FALSE)
names(d) <- xm2[1,]
rownames(d) <- c("v1", "v2", "v3", "v4")

d$Foo[c(1,2)]
d[-2,]

# Note the 1, 2 and the numbers beside them.
summary(d)
class(d)

d$Foo
d$Foo >= 3
d$Foo[d$Foo >= 3]
d[d$Foo >= 3,]

# Sampling information (Random)
sample(1:10, 10)
sample(1:10, 10, replace=TRUE)

# Library - Data.Tables
library("data.table")
cities <- c("Iowa City", "Coralville", "North Liberty", "Cedar Rapids", "Bettendorf", "Davenport")
dt <- data.table(Index = 1:20,
                 Value = sample(1:10, 20, replace=TRUE),
                 City = sample(cities, 20, replace=TRUE))

df <- as.data.frame(dt)

class(dt)
class(df)

dt[dt$City == "North Liberty"]
df[df$City == "North Liberty"]  # Throws Error
df[df$City == "North Liberty",]

dt[dt$City == "North Liberty" | dt$City == "Cedar Rapids"]
df[df$City == "North Liberty" | df$City == "Cedar Rapids",]

dt[,City]
dt$City
dt[,{print(City) 
     NULL}]
dt[,NULL]
dt[startsWith(City, "C"), {print(City)
    NULL}]
dt[startsWith(City, "C")]
dt[,startsWith(City, "C")]

dt[,.(Sum = sum(Value)), by=City]
dt[startsWith(City, "C"),.(Sum = sum(Value)), by=City]


# Library - DPlyr
library(dplyr)
library(dtplyr)

dt[City %in% c("North Liberty", "Cedar Rapids")]
dt[City %in% c("North Liberty", "Cedar Rapids") & Value > 5]

top1 <- df %>%
  filter(City %in% c("North Liberty", "Cedar Rapids", "Bettendorf")) %>%
  group_by(City) %>%
  select(City, Value) %>%
  top_n(n=1, Value)

# Graphing
library(ggplot2)
myPlot <- ggplot(data = dt, aes(x=City, y=Value)) +
  geom_bar(stat = "identity") + xlab("City") + ylab("Value") + coord_flip()
plot(myPlot)

myPlotTop <- ggplot(data = top1, aes(x=City, y=Value)) +
  geom_bar(stat = "identity") + xlab("City") + ylab("Value") + coord_flip()
plot(myPlotTop)