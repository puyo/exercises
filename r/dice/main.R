sr.prob.n <- function(n) {
  1 - ((1 - (1 / 3)) ** n)
}

sr.av.successes <- function(n) {
  n / 3
}

sr.opposed <- function(n, t) {
  sr.av.successes(n) - sr.av.successes(t)
}

sr.prob.n(6)
sr.opposed(6, 6)

result <- data.frame()
for(n in 0:10) {
  for(t in 0:10) {
    row <- list(x = n, y = t, z = sr.opposed(n, t))
    result <- rbind(result, row)
  }
}

# ox <- function(t) { as.data.frame(list(mapply(sr.opposed, 0:10, t)), col.names = sprintf("t%d", t)) }
# o <- mapply(ox, 0:10)
# anames <- mapply(as.character, 0:10)
# data <- as.data.frame(o,  make.names = FALSE)
# axis <- list(range = c(0,10))
# zaxis <- list(range = c(-10, 10))

fig <- plot_ly(result, x = ~x, y = ~y, z = ~z, type = 'mesh3d') %>%
  group_by(z)
fig

mydata = read.csv("density_plot.txt")
df = as.data.frame(mydata)
plot_ly(df, x = ~Y, y = ~X, z = ~Z, type = "scatter3d", mode = "lines") %>% group_by(X)
