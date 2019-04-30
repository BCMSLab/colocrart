# loading required libraries
library(colocr)
library(tidyverse)

# download original images
if(!file.exists('data/colocalization_images.tar.gz')) {
  download.file('https://ndownloader.figshare.com/files/15017165',
                destfile = 'data/colocalization_images.tar.gz')
  untar('colocalization_images.tar.gz')
}

# download image tile
if(!file.exists('data/cs_image.png')) {
  download.file('https://ndownloader.figshare.com/files/15017168',
                destfile = 'data/cs_image.png')
}

# download imagej data
if(!file.exists('data/imagej.csv')) {
  download.file('https://ndownloader.figshare.com/files/12293747',
                destfile = 'data/imagej.csv')
}

# loading images
ptns <- list.files('data/colocalization_images/')

# run colocr
if(!file.exists('data/cs_coloc.csv')) {
  coloc <- map(ptns, function(x) {
    fls <- list.files(paste0('data/colocalization_images/', x),
                      pattern = 'Image00[0-9]+_.jpg',
                      full.names = TRUE)
    image_load(fls) %>%
      roi_select(threshold = 90,
                 shrink = 10,
                 fill = 5,
                 clean = 10,
                 n = 3) %>%
      roi_test(type = 'both')
  }) %>%
    set_names(ptns) %>%
    map(bind_rows) %>%
    bind_rows(.id = 'ptn') %>%
    setNames(c('ptn', 'PCC', 'MOC')) %>%
    write_csv('data/cs_coloc.csv')
}

colocr <- read_csv('data/cs_coloc.csv')

imagej <- read_csv('data/imagej.csv') %>%
  select(c(1,2,4)) %>%
  setNames(c('ptn', 'PCC', 'MOC')) %>%
  filter(ptn %in% unique(colocr$ptn))

df <- bind_rows(list(colocr = colocr,
               imagej = imagej),
          .id = 'source') %>%
  gather(type, value, -ptn, -source) %>%
  group_by(source, type, ptn) %>%
  mutate(ave = mean(value), sd = sd(value))

(df %>%
  ggplot(aes(x = ptn, y = value)) +
  geom_jitter(width = .3, alpha = .5) +
  geom_point(aes(y = ave), color = 'red') +
  geom_errorbar(aes(ymin = ave - sd, ymax = ave+sd),
                color = 'red',
                width = .2) +
  geom_text(data = select(df, source, type, ptn, ave) %>% unique(),
            aes(y = .5, label = round(ave, 2))) +
  facet_grid(source~type) +
  lims(y = c(0, 1.05)) +
  labs(x = '', y = 'Coefficient Value\n') +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) ) %>%
  ggsave(plot = .,
         filename = 'data/colocalization.png',
         height = 11, width = 13, units = 'cm')

