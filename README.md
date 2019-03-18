# colocrart
A manuscript about the color R package 

# cregart

A manuscript about the [colocr](http://github.com/ropensci/colocr) R package which is part of the [rOpenSci](https://ropensci.org) now.

## Setting up the docker environment

The analysis was run on a [docker](https://hub.docker.com/r/bcmslab/cregart/) image based on the the latest **rocker/verse**. Other R packages were added to the image and were made available as an image that can be obtained and launched on any local machine running [docker](https://hub.docker.com/r/bcmslab/cregart/).

```bash
$ docker pull bcmslab/colocr:latest
$ docker run -it bcmslab/colocr:latest bash
```

## Obtaining the source code

The source code is hosted publicly on this repository in a form of research compendium. This includes the scripts to reproduce the figures and tables in this manuscript. From within the container, [git](https://git-scm.com) can be used to clone the source code.

The following code clones the repository containing the source code.

```bash
$ git clone http://github.com/BCMSLab/colocrart
```

## Generating figures and tables

The script to generate the figures and tables in the manuscirpt can be run through `Rscript`

```bash
$ cd colocrart
$ Rscript script.R
```

## Details of the R environment
The version of **R** that was used to perform this analysis is the 3.5.0 (2018-04-23) on `x86\_64-pc-linux-gnu`.

## More
