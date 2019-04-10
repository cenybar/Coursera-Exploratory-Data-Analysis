### HIERARCHICAL CLUSTERING

# Example

set.seed(1234)
par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each =4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each =4), sd = 0.2)
plot(x,y,col="blue",pch=19,cex=2)
text(x+0.05, y+0.05, labels = as.character(1:12))

# the first thing you need to do is to calculate the distance between all
# the points

dataFrame <- data.frame(x=x, y=y)
dist(dataFrame) # euclidean distance by default (can be changed)

distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
plot(hClustering)

# prettier dendograms

myplclust <- function( hclust, lab=hclust$labels, lab.col=rep(1,length(hclust$labels)),
                       hang=0.1,...){
        ## modifiction of plclust for plotting hclust objects *in colour*!
        ## Copyright Eva KF Chan 2009
        ## Arguments:
        ##    hclust:    hclust object
        ##    lab:        a character vector of labels of the leaves of the tree
        ##    lab.col:    colour for the labels; NA=default device foreground colour
        ##    hang:     as in hclust & plclust
        ## Side effect:
        ##    A display of hierarchical cluster with coloured leaf labels.
        y <- rep(hclust$height,2)
        x <- as.numeric(hclust$merge)
        y <- y[which(x<0)]
        x <- x[which(x<0)]
        x <- abs(x)
        y <- y[order(x)]
        x <- x[order(x)]
        plot( hclust, labels=FALSE, hang=hang, ... )
        text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=lab[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )}

myplclust(hClustering, lab = rep(1:3, each=4), lab.col = rep(1:3, each = 4))

# merging points

 # when merging two points, where to put the new one? several approaches.
 # complete linkage takes the fardest points, where the average takes the
 # distance between the averages
 # this approaches take you to different results, and it might be interesting
 # to try them both, to see what you get.

# heatmap

dataFrame <- data.frame(x=x,y=y)
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
heatmap(dataMatrix)

# Notes and further resources

# * Gives an idea of the relationships between variables/observations
# * The picture may be unstable
# * Change a few points
# * Have different missing values
# * Pick a different distance
# * Change the merging strategy
# * Change the scale of points for one variable
# * But it is deterministic
# * Choosing where to cut isn't always obvious
# * Should be primarily used for exploration 
# * [Rafa's Distances and Clustering Video](http://www.youtube.com/watch?v=wQhVWUcXM0A)
# * [Elements of statistical learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/)

