library(rgdal)
library(ggplot2)

data <- rgdal::readOGR(
  dsn = "./", 
  layer = "ne_10m_admin_0_countries"
)

ggplot(data, aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "black", size = 0.1, fill = "lightgrey") +
  coord_equal() +
  theme_minimal()
