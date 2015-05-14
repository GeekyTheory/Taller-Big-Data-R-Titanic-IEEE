setwd("~/Dropbox/Documents/COM/Taller-Big-Data-IEEE-ETSIT-UPM/Ejercicios/Titanic")
load("titanic.raw.rdata")

library(Matrix)
# Si el paquete utilizado para reglas de asociación no está instalado, hay que ejecutar esta instrucción para instalarlo.
# install.packages("arules")
library(arules)

# Ya que el dataset titanic.raw es relativamente grande, es conveniene utilizar la función 'head()' 
# para mostrar las 6 primeras filas.
# head(titanic.raw)
# rules = apriori(titanic.raw)

# Para saber más acerca de la función 'apriori()', introducir en consola:
# ?apriori

rules <- apriori(titanic.raw, 
         parameter = list(minlen=2, supp=0.005, conf=0.8), 
         appearance = list(rhs=c("Survived=No", "Survived=Yes"), 
         default="lhs"), 
         control = list(verbose=F))
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)

#Pruning Redundant Rules
#In the above result, rule 2 provides no extra knowledge in addition to rule 1, since rules 1 tells us that all 2nd-class children survived. 
#Generally speaking, when a rule (such as rule 2) is a super rule of another rule (such as rule 1) and the former has the same or a lower lift, 
#the former rule (rule 2) is considered to be redundant. Below we prune redundant rules. 

# find redundant rules
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)

# remove redundant rules
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)
require(ggplot2)
#Visualizing Association Rules
#Package arulesViz supports visualization of association rules with scatter plot, balloon plot, graph, parallel coordinates plot, etc.
#install.packages( arules , scatterplot3d, vcd, seriation, igraph,"grid","cluster","TSP","gclus", "colorspace")
#install.packages("arulesViz")

library(arulesViz)
plot(rules.pruned)
#plot(rules.pruned, method="graph", control=list(type="items"))
#plot(rules.pruned, measure=c("support", "lift"), shading="confidence", interactive=TRUE)

transactions <- as(titanic.raw["Survived"], "transactions")
itemFrequencyPlot(transactions,type="relative")
