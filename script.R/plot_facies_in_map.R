library(ggplot2)
library(ggmap)
library(grid)

library(mixpack)
load(file='data/data_clean.RData')



ggmap(map) + geom_point(data=data, aes(x = x, y = y, color=substr(Facies, 1, 2)), size=4,  alpha = .75) +
  xlab(NULL) + ylab(NULL)


d = data[apply(ilr_coordinates(data[,1:7]), 1, function(v) prod(is.finite(v))) == 1, ]

km = kmeans(ilr_coordinates(d[,1:7]), centers = 3)
d$gr.km = km$cluster

ggmap(map) + geom_point(data=d, aes(x = x, y = y, color=as.factor(gr.km)), size=4,  alpha = .75) +
  xlab(NULL) + ylab(NULL)

library(mclust)

mc = Mclust(d)

d$gr.mc = mc$classification
  
ggmap(map) + geom_point(data=d, aes(x = x, y = y, color=as.factor(gr.mc)), size=4,  alpha = .75) +
  xlab(NULL) + ylab(NULL)

gp = get_hierarchical_partition(mc$z, omega = function(tau, a) tau[a], lambda = function(tau, a, b) log(tau[b]/tau[a]) )
d$lev3 = mixpack::cluster_partition(mc$z, gp[[3]])

ggmap(map) + geom_point(data=d, aes(x = x, y = y, color=lev3), size=4,  alpha = .75) +
  xlab(NULL) + ylab(NULL)
