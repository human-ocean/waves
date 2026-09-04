################################################################################
# title
################################################################################
#
# Juan Carlos Villaseñor-Derbez
# jc_villasenor@miami.edu
# date
#
# Description
#
################################################################################
  
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
pacman::p_load(
  here,
  tidyverse
)

## Load data -------------------------------------------------------------------
sent <- read_rds(file = here("data/processed/miami_dade_vessel_detections.rds"))

# PROCESSING ###################################################################

## Now build a gridded version --------------------------------------------------
res <- 0.01 # In degrees

sent_grid <- sent |> 
  mutate(lon = (floor(lon / res) * res) + (res / 2),
         lat = (floor(lat / res) * res) + (res / 2)) |> 
  count(lon, lat) |> 
  collect()

# VISUALIZE ####################################################################

## Points ----------------------------------------------------------------------
ggplot(sent, aes(x = lon, y = lat)) + 
  geom_sf(data = a, inherit.aes = F) +
  geom_point(pch = ".") +
  coord_equal() +
  theme_bw()

## Raster ----------------------------------------------------------------------
ggplot(sent_grid, aes(x = lon, y = lat, fill = n)) + 
  geom_tile() + 
  coord_equal() +
  theme_bw()

