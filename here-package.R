#' ----
#' 'here' package experimentation
#' April 10, 2024
#' April 10, 2024
#' ----

#' 'here' enables easy file referencing by using the top-level directory of a file 
#' project to easily build file paths. This is in contrast to using setwd(), 
#' which is fragile and dependent on the way you order your files on your computer

# Install/load 'here' package
#install.packages("here")
library(here)

# 'here()' figures out the top-level of your current project (top-level directory).
here()

# here::i_am() displays the top-level directory of the current project.
here::i_am("here-package.R")

# both here() and i_am() remain stable even if the working directory is changed.

# 'here()' can be used to build relative paths
# how would I set a separate data path?
here::set_here()
