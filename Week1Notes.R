### LESSON 1: GRAPHS

## Principles of Analytic Graphics

 # 1 Show comparisons
 # 2 Show casuality, mechanism, explanation
 # 3 Show multivariate data
 # 4 Integrate multiple models of evidence
 # 5 Describe and document the evidence
 # 6 Content is king

 # These principles are mainly based on the book Beautiful Evidence
 # by Edward Tuffey.

## Exploratory Graphs

 # Getting the data to work along video

if (!file.exists("data")) {
        dir.create("data")
}

fileUrl <- "https://raw.githubusercontent.com/jtleek/modules/master/04_ExploratoryAnalysis/exploratoryGraphs/data/avgpm25.csv"
download.file(fileUrl, destfile = "./data/avgpm25.csv", method = "curl")
list.files("./data")
# Nota: Cuando se descargan csv de páginas de github hay que asegurarse que se
# esté descargando la versión raw (en este caso, conseguí el url raw., tal vez haya
# un método más directo (algún paquete que ande con el link original)

dateDownloaded <- date() # To keep a record of when the data was downloaded (best practices)
dateDownloaded

pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric","character","factor","numeric","numeric"))
head(pollution)

# simple summaries of data
        # one dimension
                #- Five-number summary
                #- Boxplots
                #- Histograms
                #- Density plot
                #- Barplot

summary(pollution$pm25)

boxplot(pollution$pm25, col = "blue")

hist(pollution$pm25, col = "green")
rug(pollution$pm25) # lo interesante del rug es que muestra la distribución de puntos debajo del histograma
hist(pollution$pm25, col = "green", breaks = 100) # con breaks altero el número de barras del hist.

# overlaying features

boxplot(pollution$pm25, col = "blue")
abline(h = 12) # sirve para poner una referencia (en este caso 12 era el máx de contaminación permitido)

 # lo mismo para el hist

hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2) # en este caso la línea es vertical, de ahí la v. lwed mide el gureso 
abline(v = median(pollution$pm25), col = "magenta", lwd = 4) # se puede tb establecer la línea en un valor concrecto, en este caso la mediana 

# barplot

barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region") 
 # util para mostrar patrones de una variable categórica.

# simple summaries of data
        # two dimensions
                #- Multiple/overlayed 1-D plots (lattice/ggplot2)
                #- Scatterplots
                #- Smooth scatterplots
        #- > 2 dimensions

# multiple boxplots

boxplot(pm25 ~ region, data = pollution, col = "red")
 # de arriba se ve que, en promedio, el oeste tiene valores más bajos de polución
 # pero que los valores más extremos se encuentran allí. eso es interesante de ver.

par(mfrow = c(2,1), mar = c(4,4,2,1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")
 # es una forma similar de observar lo que dijimos arriba

# scatterplot

with(pollution, plot(latitude, pm25))
abline(h =12, lwd = 2, lty = 2)        
 # util para ver si hay alguna tendencia norte-sur en cuanto a la polución (no parecería ser el caso)
 
 # también se puede usar color

with(pollution, plot(latitude, pm25, col = region ))
abline(h =12, lwd = 2, lty = 2)  

 # o hacer un panel con dos plots

par(mfrow = c(1,2), mar = c(5,4,2,1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))
 # acá es interesante que tanto en este y oeste, los condados con más polución son los centrales
 # no tanto los que se ubican más al norte o al sur.

 # further resources

 # R Graph Gallery
 # R bloggers

