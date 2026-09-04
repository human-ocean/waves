################################################################################
# get sar data
################################################################################
#
# Juan Carlos Villaseñor-Derbexz
# jxv893@miami.edu
# September 3, 2026
#
# Collects vessel detections from Sentinel 2 (Optical imagery) from GFW and
# exports them as an rds file
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
pacman::p_load(
  here,
  sf,
  tidyverse,
  bigrquery
)

## Load data -------------------------------------------------------------------
# Authenticate to BigQuery
# I need to still use my UCSB credentials because we haven't finalized the access
# with UM emails...
bq_auth("juancarlos@ucsb.edu")

# Establish a connection to BigQuery
# This makes all the tables in the sentinel2 pipeline available in R
con_sent <- dbConnect(drv = bigquery(),
                      billing = "emlab-gcp", 
                      project = "global-fishing-watch",
                      dataset = "pipe_sentinel2_v1_published")

# PROCESSING ###################################################################

# Get SENTINEL-2 detections ----------------------------------------------------
sent_raw <- tbl(con_sent, "detect_scene_match_pipe_v4") |> 
  filter(sql("EXTRACT(YEAR FROM detect_timestamp) = 2025"),
         !likely_infrastructure) |>
  mutate(matched = sql("ssvid IS NOT NULL")) |> 
  select(lon = detect_lon,
         lat = detect_lat,
         matched,
         date) |> 
  # Define longitudinal and latitudinal ranges for the data. This is probaly too big
  # for now, but that's ok.
  filter(between(lon, -80.5, -80),
         between(lat, 25, 26),
         sql("EXTRACT(YEAR FROM date) =2025")) |> 
  select(lon, lat, date) |> 
  collect()

# EXPORT #######################################################################

## The final step --------------------------------------------------------------  
write_rds(x = sent_raw,
          file = here("data/processed/miami_dade_vessel_detections.rds"))


























