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

# Writing a function
function(x) { x + 5 }

xPlus5 <- function(x) { x + 5 }

xPlus5(5)

# Create a data structure
x <- c("Foo", "Bar", 1, 2, 3, 4, 5, 6)
x[2]
xl <- as.list(x)
xm <- matrix(x, ncol=2)
xm2 <- matrix(x, ncol=2, byrow = TRUE)

# Get Headers
xm2[1,]

# Get Body
length(xm2)
xm2Length <- length(xm2)
xm2[-1,]

d <- as.data.frame(xm2[-1,])
names(d) <- xm2[1,]
rownames(d) <- c("v1", "v2", "v3")

d$Foo[c(1,2)]
d[-2,]