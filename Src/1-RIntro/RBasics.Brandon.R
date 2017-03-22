library(readr)

cities <- readr::read_csv("https://raw.githubusercontent.com/TheDarkTrumpet/2017RPresentations/master/Data/citylocs.csv",
                          col_names = c('rownames', 'city_name', 'city_pop', 'state_code', 'state_name', 'state_pop'),
                          skip = 1)

library(dplyr)
library(ggplot2)

# table(cities$StateProvinceName)


# select IL, MN, and WI
il_mn_wi_top <- cities %>%
  filter(state_code %in% c('IL', 'MN', 'WI')) %>%
  group_by(state_code) %>%
  top_n(n = 5, city_pop) %>%
  select(state_code, city_name, city_pop, everything()) %>%
  arrange(state_code, -city_pop) %>%
  mutate(top = TRUE)

il_mn_wi_bottom <- cities %>%
  filter(state_code %in% c('IL', 'MN', 'WI')) %>%
  group_by(state_code) %>%
  top_n(n = -5, city_pop) %>%
  select(state_code, city_name, city_pop, everything()) %>%
  arrange(state_code, -city_pop) %>%
  mutate(top = FALSE)

all_data <- bind_rows(il_mn_wi_top, il_mn_wi_bottom)

# ggplot(all_data, aes(x = city_name, y = city_pop)) + 
#   geom_bar(stat = 'identity') + 
#   facet_grid(state_name ~ top) + 
#   coord_flip() + 
#   theme_bw() + 
#   xlab("City Name") + 
#   ylab("Population")
# 
# ggplot(all_data, aes(x = city_name, y = city_pop)) + 
#   geom_bar(stat = 'identity') + 
#   facet_grid(state_name ~ top, scales = 'free', space = 'free') + 
#   coord_flip() + 
#   theme_bw() + 
#   xlab("City Name") + 
#   ylab("Population")

ggplot(il_mn_wi_top, aes(x = city_name, y = city_pop)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(state_name ~ .) + 
  coord_flip() + 
  theme_bw() + 
  xlab("City Name") + 
  ylab("Population")

ggplot(il_mn_wi_top, aes(x = city_name, y = city_pop)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(state_name ~ ., scales = 'free', space = 'free') + 
  coord_flip() + 
  theme_bw() + 
  xlab("City Name") + 
  scale_y_continuous("Population", breaks = seq(0, 3000000, 500000))
