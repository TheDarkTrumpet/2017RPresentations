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
x[2]
xl <- as.list(x)
xm <- matrix(x, ncol=2)
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