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

### LESSON 2: GGPLOT2

library(ggplot2)
qplot(displ, hwy, data = mpg) # "hello, world!" ggplot data (basic one)

# modifying aesthetics

qplot(displ, hwy, data = mpg, color=drv) 

# adding a geom

qplot(displ, hwy, data = mpg, geom=c("point","smooth")) 

# histograms

qplot(hwy, data = mpg, fill=drv)

# facets (an alternative way to separate the data, instead of using colors, getting separated graphs)

qplot(displ, hwy, data=mpg, facets=.~drv) # el facets especifica nro_filas~nro_columnas (si se pone punto, se omite esta info, una sola por defecto)

qplot(hwy, data=mpg, facets=drv~., binwidth =2)

# notes on axis limits

# if we use de ylim(), the outlier gets "cut" from the graph
# instead, we might use coord_cartesian(ylim=c()) that zooms in the
# specified limits, but still includes de outlier in the background
# data.

# notes on variable transformation

# we can use the cut() function to make a continuous variable into 
# a categorical one for analysis purposes, because if we condition
# into a continuous variable we might get infinite plots.

# although the data shown in the excercises is private, here is a copy of
# the code Mr. Peng uses:

# Calculate the deciles of the data
cutpoints <- quantile(maacs$logno2_new, seq(0,1,lenght=4), na.rm=TRUE)
# Cut the data at the deciles and create a new factor variable
maacs$no2dec <- cut(maacs$logno2_new, cutpoints)
# See the levels of the newly created factor variable 
levels(maacs$no2dec)
