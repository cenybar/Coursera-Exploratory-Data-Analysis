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

### LESSON 2: PLOTTING

# base plot

library(datasets)
data(cars)
with(cars, plot(speed,dist))

# the lattice system

library(lattice)

# ggplot2

library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)
        
# Simple Base Graphics: Histogram

library(datasets)
hist(airquality$Ozone) # Draw a new plot

# Scatterplot

with(airquality, plot(Wind,Ozone))


# Boxplot

airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab ="Ozone")

# some important base graphic parameters

 # pch: the plotting sympbol (default is open circle)
 # lty: the line type (default is solid line), can be dashed, dotted, etc.
 # lwd: the line width, specified as an interger multiple
 # col: the plotting color, specified as a number, string, or hex code; 
     # the colors() function gives you a vector of colors by name
 # xlab: character string for the x-axis label
 # ylab: character string for the y-axis label

# the par() function used to specify global graphics parameters

 # las: the orientation of the axis label on the plot
 # bg: the background color
 # mar: the margin size
 # oma: the outer margin size (default is 0)
 # mfrow: number of plots per row, column (plots are filled row-wise)
 # mfcol: number of plots per row, column (plots are filled column-wise)

par("lty") # para ver los valores default de cada parámetro

# base plotting functions

 # plot: make a scatterplot, or other type of plot depending on the class of the object being plotted
 # lines: add lines to a plot, given a vector x values and a corresponding vector of y values
 # points: add points to a plot
 # text: add text labels to a plot using specified x, y coordinates
 # title: add annotations to x, y axis labels, title, subtitle, outer margin
 # mtext: add arbitrary text to the margins (inner or outer) of the plot
 # axis: adding axis ticks/labels

library(datasets)
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in NYC")

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in NYC")) # metodo alternativo para titular
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue")) # destaco en azul los valores de mayo

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in NYC",
                      type = "n")) # pone el canvas en blanco el "n"
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other months"))

# base plot with regression line

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in NYC",
                      pch = 20)) # el valor de pch determina el tamaño del círculo
model <- lm(Ozone ~ Wind, airquality)
abline(model, lwd = 2)

# multiple base plots

par(mfrow = c(1,2))
with(airquality, {
        plot(Wind, Ozone, main = "Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar")
})

par(mfrow = c(1,3), mar = c(4,4,2,1), oma = c(0,0,2,0)) # mar y oma manejan los margenes, el margen y el outermargen
with(airquality, {
        plot(Wind, Ozone, main = "Ozone and Wind")
        plot(Solar.R, Ozone, main = "Ozone and Solar")
        plot(Temp, Ozone, main = "Ozone and Temperature")
        mtext("Ozone and Weather in NYC", outer = TRUE) # para poner un título fuera del gráfico con outer
})

## useful tips

example(points) # está bueno para repasar las posibilidades gráficas que tiene R
