library(readr)

cities <- readr::read_csv("https://raw.githubusercontent.com/TheDarkTrumpet/2017RPresentations/master/Data/citylocs.csv",
                          col_names = c('rownames', 'city_name', 'city_pop', 'state_code', 'state_name', 'state_pop'),
                          skip = 1)

library(dplyr)
library(ggplot2)

filt <- cities %>% filter(state_code %in% c('IL', 'MN', 'WI'))
grpby <-  filt %>% group_by(state_code)
topnall <- filt %>% top_n(n = 5, city_pop)
topn <- grpby %>% top_n(n = 5, city_pop)
sel <- topn %>% select(state_code, city_name, city_pop, everything())
arr <- sel %>% arrange(state_code, -city_pop)
arr2 <- topn %>% arrange(state_code, -city_pop)
mut <- arr %>% mutate(top = TRUE)

ggplot(mut, aes(x = city_name, y = city_pop)) + 
   geom_bar(stat = 'identity') + 
   facet_grid(state_name ~ .) + 
   coord_flip() + 
   theme_bw() + 
   xlab("City Name") + 
   ylab("Population")


ggplot(arr2, aes(x = city_name, y = city_pop)) + 
  geom_bar(stat = 'identity') + 
  facet_grid(state_name ~ .) + 
  coord_flip() + 
  theme_bw() + 
  xlab("City Name") + 
  ylab("Population")
