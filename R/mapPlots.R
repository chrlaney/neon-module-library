library(httr)
library(jsonlite)
library(magrittr)
library(leaflet)

# gets full catalog
pr <- fromJSON("http://data.neonscience.org/api/v0/products")
pr1 <- pr[['data']]

realm <- fromJSON("http://data.neonscience.org/api/v0/locations/REALM")
extLabs <- fromJSON("http://data.neonscience.org/api/v0/locations/External%20Labs")
domains <- realm$data$locationChildren[1:20]
sitelist <- data.frame(domain = NA, site = NA)
for(d in domains){
  l <- fromJSON(paste0("http://data.neonscience.org/api/v0/locations/", d))
  if(length(l$data$locationChildren) > 0)
    for(i in 1:length(l$data$locationChildren)){
      sitelist <- rbind(sitelist, c(d, l$data$locationChildren[i]))
    }
}
sitelist <- sitelist[-1,]
d01 <- fromJSON("http://data.neonscience.org/api/v0/locations/D01")
sterloc <- fromJSON("http://data.neonscience.org/api/v0/locations/STER")
sterchild <- fromJSON("http://data.neonscience.org/api/v0/locations/STER_007.basePlot.sme")


d <- data.frame(popup = NA, lng = NA, lat = NA)
for(i in 1:length(sterloc$data$locationChildren)){
  t <- fromJSON(paste0("http://data.neonscience.org/api/v0/locations/", sterloc$data$locationChildren[i]))
  d <- rbind(d, c(t$data$locationName, t$data$locationDecimalLongitude, t$data$locationDecimalLatitude))
}


d <- d[-1,]
d$lat <- as.numeric(d$lat)
d$lng <- as.numeric(d$lng)
d <- d[-which(is.na(d$lat)),  ]
d$color <- character(nrow(d))
d$color[grep(pattern = "TOWER", x = d$popup)] <- "grey"
d$color[grep(pattern = "MEGAPT", x = d$popup)] <- "burlywood"
d$color[grep(pattern = "soil", x = d$popup)] <- "brown"
d$color[grep(pattern = "mam", x = d$popup)] <- "#AA3939"
d$color[grep(pattern = "bgc", x = d$popup)] <- "#AA6C39"
d$color[grep(pattern = "bet", x = d$popup)] <- "black"
d$color[grep(pattern = "hbp", x = d$popup)] <- "#2D882D"
d$color[grep(pattern = "div", x = d$popup)] <- "#88CC88"
d$color[grep(pattern = "mos", x = d$popup)] <- "#D49A6A"
d$color[grep(pattern = "brd", x = d$popup)] <- "#FFAAAA"
d$color[grep(pattern = "vst", x = d$popup)] <- "springgreen"
d$color[grep(pattern = "dhp", x = d$popup)] <- "#FFD1AA"
d$color[grep(pattern = "mfb", x = d$popup)] <- "#226666"
d$color[grep(pattern = "cfc", x = d$popup)] <- "#669999"
d$color[grep(pattern = "cdw", x = d$popup)] <- "#11661"
d$color[grep(pattern = "ltr", x = d$popup)] <- "#004400"
d$color[grep(pattern = "bbc", x = d$popup)] <- "darkmagenta"
d$color[grep(pattern = "mpt", x = d$popup)] <- "#804515"
d$color[grep(pattern = "tck", x = d$popup)] <- "#552700"
d$color[grep(pattern = "sme", x = d$popup)] <- "#550000"
d$color[grep(pattern = "phe", x = d$popup)] <- "#55AA55"

d$type <- character(nrow(d))
d$type[grep(pattern = "TOWER", x = d$popup)] <- "Tower"
d$type[grep(pattern = "MEGAPT", x = d$popup)] <- "Megapit"
d$type[grep(pattern = "soil", x = d$popup)] <- "Soil"
d$type[grep(pattern = "mam", x = d$popup)] <- "Small Mammal"
d$type[grep(pattern = "bgc", x = d$popup)] <- "Biogeochemistry"
d$type[grep(pattern = "bet", x = d$popup)] <- "Beetle"
d$type[grep(pattern = "hbp", x = d$popup)] <- "Herbaceous Biomass"
d$type[grep(pattern = "div", x = d$popup)] <- "Plant Diversity"
d$type[grep(pattern = "mos", x = d$popup)] <- "Mosquito"
d$type[grep(pattern = "brd", x = d$popup)] <- "Bird"
d$type[grep(pattern = "vst", x = d$popup)] <- "Vegetation Structure"
d$type[grep(pattern = "dhp", x = d$popup)] <- "Digital Hemisphere Photos"
d$type[grep(pattern = "mfb", x = d$popup)] <- "MFB"
d$type[grep(pattern = "cfc", x = d$popup)] <- "CFC"
d$type[grep(pattern = "cdw", x = d$popup)] <- "Coarse Downed Wood"
d$type[grep(pattern = "ltr", x = d$popup)] <- "Litter"
d$type[grep(pattern = "bbc", x = d$popup)] <- "Belowground Biomass Core"
d$type[grep(pattern = "mpt", x = d$popup)] <- "Mosquito Pathogens"
d$type[grep(pattern = "tck", x = d$popup)] <- "Tick"
d$type[grep(pattern = "sme", x = d$popup)] <- "Soil Microbes"
d$type[grep(pattern = "phe", x = d$popup)] <- "Plant Phenology"

#With clustering
leaflet(d) %>% setView(lng = sterloc$data$locationDecimalLongitude, lat = sterloc$data$locationDecimalLatitude, zoom = 4) %>%
  addTiles() %>%
  addCircleMarkers(~lng, ~lat, popup=d$popup, weight = 3, radius=40, 
                   color=d$color, stroke = TRUE, fillOpacity = 1, clusterOptions = markerClusterOptions()) %>% 
  addLegend("bottomright", colors= unique(d$color), opacity = 1,labels=unique(d$type), title="Sterling Plots")

#Without clustering
leaflet(d) %>% setView(lng = sterloc$data$locationDecimalLongitude, lat = sterloc$data$locationDecimalLatitude, zoom = 13) %>%
  addTiles() %>%
  addCircles(~lng, ~lat, popup=d$popup, weight = 3, 
             color=d$color, stroke = TRUE, fillOpacity = 1) %>% 
  addLegend("bottomright", colors= unique(d$color), opacity = 1,labels=unique(d$type), title="Sterling Plots")


fromJSON("http://data.neonscience.org/api/v0/locations/SOILAR100094")

