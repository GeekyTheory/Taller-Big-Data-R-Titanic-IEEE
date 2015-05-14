# INTRODUCCIÓN A R

set.seed(42)
x <- rnorm(50)
y <- rnorm(x)
class(x)
summary(x)
plot(x, y)
library(ggplot2)
qplot(x,y)
z<-as.factor(rbinom(50,1,0.5))
ggplot()+geom_point(aes(x=x,y=y,color=z))+geom_smooth(aes(x=x,y=y))
rm(x,y,z)
x <- 1:20
w <- 1 + sqrt(x)/2
dummy <- data.frame(x=x, y= x + rnorm(x)*w)
fm <- lm(y ~ x, data=dummy)
summary(fm)
plot(fm,which=1)