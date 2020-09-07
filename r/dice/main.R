# What if, in Shadowrun, we simplified the game by replacing GM dice rolls with abbreviated estimates
# of the number of successes, based on probability?

library(plotly)
library(dplyr)

# -----------------
# slow version where we compute every possibility and filter to the ones we want

list.nsuccesses <- function(l) {
  Reduce(function(a, v){ a + as.numeric(v == 3) }, l, 0)  
}

sr.prob.contest <- function(n, t) {
  ng <- expand.grid(rep(list(1:3), n))
  nw <- list.nsuccesses(ng)
  tg <- expand.grid(rep(list(1:3), t))
  tw <- list.nsuccesses(tg)
  all <- expand.grid(n = nw, t = tw)
  nwins <- subset(all, n >= t)
  nrow(nwins) / nrow(all)
}

sr.prob.fixed <- function(n, t) {
  t <- floor(t / 3)
  ng <- expand.grid(rep(list(1:3), n))
  nw <- list.nsuccesses(ng)
  all <- expand.grid(n = nw, t = t)
  nwins <- subset(all, n >= t)
  nrow(nwins) / nrow(all)
}

# -----------------
# fast version that uses the binomial coefficient

# probability of exactly i successes when rolling n dice
sr.prob <- function(ndice, successes) {
  choose(ndice, successes) * ((1/3)**successes) * ((2/3)**(ndice - successes))
}

sr.prob.fixed2 <- function(ndice, target) {
  target <- floor(target / 3)
  p <- 0
  successes <- target
  while (successes <= ndice) {
    p <- p + sr.prob(ndice, successes)
    successes <- successes + 1
  }
  p
}

sr.prob.contest2 <- function(ndice, tdice) {
  p <- 0
  for (nsuccesses in 0:ndice) {
    for (tsuccesses in 0:tdice) {
      if (nsuccesses >= tsuccesses) {
        pt <- sr.prob(tdice, tsuccesses)
        pn <- sr.prob(ndice, nsuccesses)
        p <- p + (pt * pn)
      }
    }
  }
  p
}

# -----------------
# comparison

sr.prob.fixed(3, 2)
sr.prob.fixed2(3, 2)

sr.prob.fixed(3, 20)
sr.prob.fixed2(3, 20)

sr.prob.contest(3, 2)
sr.prob.contest2(3, 2)

# -----------------
# plot all the possibilities

# every combination of number of dice and target number
sr.data <- function(f, fname, ns = 0:20, ts = 0:20) {
  result <- data.frame()
  for (n in ns) {
    for (t in ts) {
      row <- list(fname = fname, x = n, y = t, p = f(n, t))
      result <- rbind(result, row)
    }
  }
  result
}

# create a plot
sr.fig <- function(sr.data) {
  fig <- sr.data %>%
    group_by(fname, y) %>%
    plot_ly(
      x = ~x, y = ~y, z = ~p,
      type = 'scatter3d',
      mode = "lines",
      color = ~fname,
      colors = c('#4444aa', '#aa4444')
    ) %>%
    layout(title = 'Chance of x winning against y')
  fig
}

d1 = sr.prob.contest2 %>% sr.data("contest")
d2 = sr.prob.fixed2 %>% sr.data("fixed")
d = rbind(d1, d2)
d %>% sr.fig()
