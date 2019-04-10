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

### K-MEANS CLUSTERING

dataFrame <- data.frame(x,y)
kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
kmeansObj$cluster

par(mar = rep(0.2, 4))
plot(x,y,col=kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd =3)
 # heatmaps
set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1,2), mar = c(2,4,0.1,0.1))
image(t(dataMatrix)[,nrow(dataMatrix):1], yaxt="n")
image(t(dataMatrix)[,order(kmeansObj$cluster)], yaxt = "n")

### DIMENSION REDUCTION 

## Principal components analysis and singular value decomposition

# Matrix data

set.seed(12345)
par(mar = rep(0.2, 4))
dataMatrix <- matrix(rnorm(400), nrow= 40)
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])

# cluster the data

par(mar = rep(0.2,4))
heatmap(dataMatrix) #nothing interesting emerges, as the data is random.

# what if we add a pattern?

set.seed(678910)
for (i in 1:40) {
        # flip a coin
        coinFlip <- rbinom(1, size = 1, prob = 0.5)
        # if coin is heads add a common pattern to that row
        if (coinFlip) {
                dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0,3), each = 5)
        }
}
# the data (with pattern)
par(mar= rep(0.2, 4))
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])
# the clustered data (with pattern)
par(mar=rep(0.2, 4))
heatmap(dataMatrix)
# patterns in rows and columns
hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1, xlab="Row Mean", ylab="Row", pch=19)
plot(colMeans(dataMatrixOrdered), xlab="Column", ylab="Column Mean", pch=19)

## Related problems

#having multivariate variables, 1) find a new set of variables that are uncorrelated and explain as much variance
#as possible. Also, 2) if you put all the variables in one matrix, find the best matrix created with fewer
#variables (lower rank) that explains the original data.
#the first goal is statistical, the second one is data compression.

#SVD - Single value decomposition
#PCA - Principal components analysis

# components of the SVD - u and v
svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd1$u[, 1], 40:1,  xlab = "Row", ylab = "First left singular vector",
     pch = 19)
plot(svd1$v[,1], xlab = "Column", ylab = "First right singular vector",
     pch = 19)
# components of the SVD - variance explained
par(mfrow=c(1,2))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained",
     pch = 19)
# relationship to proncipal components
svd1 <- svd(scale(dataMatrixOrdered))
pca1 <- prcomp(dataMatrixOrdered, scale=TRUE)
plot(pca1$rotation[, 1], svd1$v[,1],pch=19, xlab = "Principal Component 1",
     ylab = "Right Singular Vector 1")
abline(c(0,1))
 # la relación es muy buena, como demuestra la recta, entre los dos métodos de análisis

# Components of the SVD - variance explained

constantMatrix <- dataMatrixOrdered*0
for(i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <- rep(c(0,1),each=5)}
svd1 <- svd(constantMatrix)
par(mfrow=c(1,3))
image(t(constantMatrix)[,nrow(constantMatrix):1])
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)
 #pese a que hay muchas variables, solo hay una variable que explica el 100% de la varianza 
 # de la muestra según donde caiga el parámetro de las filas.

# What if we add a second pattern?

set.seed(678910)
for(i in 1:40){
        # flip a coin
        coinFlip1 <- rbinom(1,size=1,prob=0.5)
        coinFlip2 <- rbinom(1,size=1,prob=0.5)
        # if coin is heads add a common pattern to that row
        if(coinFlip1){
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),each=5)
        }
        if(coinFlip2){
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5),5)
        }
}
hh <- hclust(dist(dataMatrix)); dataMatrixOrdered <- dataMatrix[hh$order,]

# true patterns

svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rep(c(0,1),each=5),pch=19,xlab="Column",ylab="Pattern 1")
plot(rep(c(0,1),5),pch=19,xlab="Column",ylab="Pattern 2")
 #this is the true, but we never know the true, we have to find it out,
 # that's what svd does.

#  $v$ and patterns of variance in rows

svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd2$v[,1],pch=19,xlab="Column",ylab="First right singular vector")
plot(svd2$v[,2],pch=19,xlab="Column",ylab="Second right singular vector")

#  $d$ and variance explained

svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,2))
plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Percent of variance explained",pch=19)

# Missing values

dataMatrix2 <- dataMatrixOrdered
## Randomly insert some missing data
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
svd1 <- svd(scale(dataMatrix2))  ## Doesn't work!

# Imputing {impute}
library(impute)  ## Available from http://bioconductor.org
dataMatrix2 <- dataMatrixOrdered
dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
dataMatrix2 <- impute.knn(dataMatrix2)$data
svd1 <- svd(scale(dataMatrixOrdered)); svd2 <- svd(scale(dataMatrix2))
par(mfrow=c(1,2)); plot(svd1$v[,1],pch=19); plot(svd2$v[,1],pch=19)

## Face example

## source("http://dl.dropbox.com/u/7710864/courseraPublic/myplclust.R") -->
        
## hay que descargar los datos de arriba para procesar lo de abajo
load("data/face.rda")
image(t(faceData)[,nrow(faceData):1])



---
        
        ## Face example - variance explained
        
   
svd1 <- svd(scale(faceData))
plot(svd1$d^2/sum(svd1$d^2),pch=19,xlab="Singular vector",ylab="Variance explained")



        
        ## Face example - create approximations
        
  
svd1 <- svd(scale(faceData))
## Note that %*% is matrix multiplication
# Here svd1$d[1] is a constant
approx1 <- svd1$u[,1] %*% t(svd1$v[,1]) * svd1$d[1]
# In these examples we need to make the diagonal matrix out of d
approx5 <- svd1$u[,1:5] %*% diag(svd1$d[1:5])%*% t(svd1$v[,1:5]) 
approx10 <- svd1$u[,1:10] %*% diag(svd1$d[1:10])%*% t(svd1$v[,1:10]) 



        
        ## Face example - plot approximations

par(mfrow=c(1,4))
image(t(approx1)[,nrow(approx1):1], main = "(a)")
image(t(approx5)[,nrow(approx5):1], main = "(b)")
image(t(approx10)[,nrow(approx10):1], main = "(c)")
image(t(faceData)[,nrow(faceData):1], main = "(d)")  ## Original data



---
        
        ## Notes and further resources
        
#        * Scale matters
#* PC's/SV's may mix real patterns
#* Can be computationally intensive
#* [Advanced data analysis from an elementary point of view](http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/ADAfaEPoV.pdf)
#* [Elements of statistical learning](http://www-stat.stanford.edu/~tibs/ElemStatLearn/)
#* Alternatives
#* [Factor analysis](http://en.wikipedia.org/wiki/Factor_analysis)
#* [Independent components analysis](http://en.wikipedia.org/wiki/Independent_component_analysis)
#* [Latent semantic analysis](http://en.wikipedia.org/wiki/Latent_semantic_analysis)
