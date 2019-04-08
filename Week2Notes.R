### LESSON 1: LATTICE PLOTTING SYSTEM

# Basic functions

xyplot
bwplot
histogram
strippplot
dotplot
splom
levelplot 
countourplot

# Simple lattice plot

library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data = airquality)

# other example
        # convert "Month" to a factor variable
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5,1))

# lattice behavior

p <- xyplot(Ozone ~ Wind, data = airquality) ## nothing happens
print(p) ## plot appears

xyplot(Ozone ~ Wind, data = airquality) ## auto-printing

# lattice panel functions

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd=0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1)) # plot with 2 panels            

# custom panel function

xyplot(y ~ x | f, panel = function(x, y, ...){
        panel.xyplot(x, y, ...) # first call the default panel function for xyplot
        panel.abline(h=median(y), lty=2) # add a horizontal line at the median
})

# regression line function

xyplot(y ~ x | f, panel = function(x, y, ...){
        panel.xyplot(x, y, ...) # first call default panel function
        panel.lmline(x, y, col=2) # overlay a simple regression line
})
