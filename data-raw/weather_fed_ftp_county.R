library(tidyr)
library(readr)
library(dplyr)
library(RCurl)

# wrangle data from fed ftp site if needed (maybe broken ...)
# url <-  "ftp://ftp.ncdc.noaa.gov/pub/data/cirs/climdiv/"
# 
# # get the current set of filenames
# filenames <- getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
# filenames <- strsplit(filenames, "\n")
# filenames <- unlist(filenames)
# 
# # grep the ones we want
# filenames <- filenames[grepl("(v-tmpccy|v-pcpncy)", filenames)]
# 
# # download 'em
# for (file in filenames){
#   download.file(paste0(url, file), paste0("~/", file))
# }
filenames <- list.files(path = here::here("data-raw/"))
# grep the ones we want
filenames <- filenames[grepl("(v-tmpccy|v-pcpncy)", filenames)]
feddat <- list()
for (i in seq_along(filenames)){
  tempdf <- read_table(paste0(here::here("data-raw/"), filenames[i]),
                            col_names = c("st_co_year", month.abb),
                            col_type = paste0(c("c",rep("d",12)), collapse = ""))
  tempdf <- separate(tempdf, st_co_year, into = c("state","cofips","element","year"),
                     sep = c(2,5,7))
  feddat[[i]] <- tempdf
}
names(feddat) <- c("precip", "mean_temp")
conus_weather <- bind_rows(feddat, .id = "var")

#dplyr::filter(conus_weather, state =="25", year == "1995", cofips == "001")


conus_weather <- pivot_longer(conus_weather, 6:17, names_to = "month") %>%
  pivot_wider(id_cols = c("state","cofips","year","month"), names_from = "var", values_from = "value")

state_code_translations <- read_csv("data-raw/USA_state_abb.csv") %>%
  filter(status == "State") %>%
  mutate(state_noaa = case_when(is.na(NOAA) ~ NA_character_,
                           TRUE ~ sprintf("%02.0f", NOAA)),
         state_fips = sprintf("%02.0f", FIPS)) %>%
  select(name, state_noaa, state_fips)
# process missing values and fix doubled counties
conus_weather <- conus_weather %>%
  left_join(state_code_translations, by = c("state" = "state_noaa")) %>%
  mutate(
    fips = paste0(state_fips, cofips),
    mean_temp = case_when(mean_temp < -50.0 ~ NA_real_,
                          TRUE ~ mean_temp),
    precip = case_when(precip < 0.0 ~ NA_real_,
                       TRUE ~ precip),
    fips = case_when(fips %in% c("46102","46113") ~ "46102/46113",
                     fips %in% c("51019","51515") ~ "51019/51515",
                     fips == "24511" ~ "11001",
                     TRUE ~ fips),
  ) %>%
  filter(state_fips != "02") %>% # remove alaska, hawaii and PR already gone
  select(name, fips, state_fips, cofips, state_noaa = state,
         year, month, mean_temp, precip)

# Virginia has "independent cities" some of which NOAA lists separately
# and some it doesn't ... Lexington City is inside Rockbridge county.
fakeLexingtonCity <- conus_weather %>%
  filter(fips == "51163") %>%
  mutate(fips = "51678",
         state_fips = "51",
         cofips = "678",
         state_noaa = NA_character_)
conus_weather <- bind_rows(conus_weather, fakeLexingtonCity)
usethis::use_data(conus_weather, overwrite = TRUE)


