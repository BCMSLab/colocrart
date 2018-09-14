# load required libraries
library(imager)
library(colocr)

library(tidyverse)
library(xtable)

# make dirtree
fig_dir <- 'manuscript/figures'
tab_dir <- 'manuscript/tables'
add_files <- 'manuscript/add_files'

if(!dir.exists(fig_dir)) {
  dir.create(fig_dir)
}

if(!dir.exists(tab_dir)) {
  dir.create(tab_dir)
}

if(!dir.exists(add_files)) {
  dir.create(add_files)
}
# download image
if(!file.exists('data/image.jpg')) {
  download.file('https://gist.githubusercontent.com/MahShaaban/9ea55387fec4543326e9c2067a804fe8/raw/a8679cd764a3c80e934eddca852bbda7c73792f3/Image0004_.jpg',
                destfile = 'data/image.jpg')
}

# load images and channels
img <- image_load('data/image.jpg')
img1 <- channel(img, 1)
img2 <- channel(img, 2)

# generate figure of images and channels
png(filename = paste(fig_dir, 'images.png', sep = '/'),
    width = 18, height = 6, units = 'cm', res = 300)
par(mfrow = c(1,3), mar = c(1, 1, 3, 1))
plot(img, axes = FALSE, main = 'Merge')
plot(img1, axes = FALSE, main = 'Channel One')
plot(img2, axes = FALSE, main = 'Channel Two')
dev.off()

# select regions of interest
png(filename = paste(fig_dir, 'roi.png', sep = '/'),
    width = 18, height = 18, units = 'cm', res = 200)
par(mfrow = c(2,2), mar = c(1, 1, 3, 1))
img %>%
  roi_select(threshold = 90,
             shrink = 10,
             fill = 10,
             clean = 10,
             n = 3) %>%
  roi_show()
dev.off()

# check pixel intensities
png(filename = paste(fig_dir, 'pixels.png', sep = '/'),
    width = 18, height = 9, units = 'cm', res = 200)
par(mfrow = c(1,2), mar = c(4, 4, 1, 1))
img %>%
  roi_select(threshold = 90,
             shrink = 10,
             fill = 10,
             clean = 10,
             n = 3) %>%
  roi_check()
dev.off()

# calculate co-localization stats
img %>%
  roi_select(threshold = 90,
             shrink = 10,
             fill = 10,
             clean = 10,
             n = 3) %>%
  roi_test(type = 'both')

# generate table for co-colocalization stats
img %>%
  roi_select(threshold = 90,
             shrink = 10,
             fill = 10,
             clean = 10,
             n = 3) %>%
  roi_test(type = 'both') %>%
  mutate_all(round, digits = 2) %>%
  mutate(roi = row_number()) %>%
  rbind(c(mean(.$pcc), mean(.$moc), 'Average')) %>%
  select(roi, everything()) %>%
  setNames(c('ROI', 'PCC', 'MOC')) %>%
  xtable(caption = 'Co-localization statistics.',
         align = 'cccc',
         label = 'tab:stat') %>%
  print(include.rownames = FALSE,
        booktabs = TRUE,
        add.to.row = list(pos = list(3),
                          command = '\\midrule '),
        caption.placement = 'top',
        table.placement = 'ht',
        sanitize.text.function = identity,
        comment = FALSE,
        file = paste(tab_dir, 'stat.tex', sep = '/'))

# copy source code to manuscript dir
file.copy('script.R', 
          to = paste(add_files, 'script.R', sep = '/'))
