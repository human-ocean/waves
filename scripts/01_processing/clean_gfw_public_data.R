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
# Raw data are too big to include gere (829 MB). They can be downloaded from: 
# https://globalfishingwatch.org/data-download/datasets/public-sentinel2-vessel-detections%3Av1.0
# login with a google account is required

# Load July 2026 detections
data <- read_csv(file = here("data/raw/vessel_detections/sentinel2_vessel_detections_pipev4_202607.csv"))

# PROCESSING ###################################################################

## Filter to a smaller boudning box --------------------------------------------
lon_range <- c(-81, -79)
lat_range <- c(25.13743, 28.79214)

# Filter the data form some quick QA/QC
FL_data <- data |> 
  filter(!likely_infrastructure,
         nonvessel_score < 0.5) |> 
  select(lon, lat, detect_timestamp, length_m_inferred, presence_score, nonvessel_score, cloud_score, matching_score) |> 
  filter(between(lon, lon_range[1], lon_range[2]),
         between(lat, lat_range[1], lat_range[2]))
         
# VISUALIZE ####################################################################

## Another step ----------------------------------------------------------------
ggplot(FL_data, aes(x = lon, y = lat)) + geom_point(pch = ".") +
  coord_equal()

# EXPORT #######################################################################

## The final step --------------------------------------------------------------
write_rds(x = FL_data,
          file = here("data/processed/miami_dade_vessel_detections.rds"))
