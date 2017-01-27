##############################################################
## Loads the Environment on a per script basis
## requires a valide package object from package_dependencies.R
##############################################################

loadEnv <- function(script_packages) {
  loadDependencies()
  setwd(env_wd)
  packagez <- eval(parse(text=script_packages))
  loadRequiredPackages(packagez)
}

################################################
## Loads all Dependencies files from subdirectory
################################################
loadDependencies <- function() {
  dep_files <- list.files(path="./dependencies")
  for (file in dep_files) {
    file_path <- paste0("./dependencies/",file)
    source(file_path,local=FALSE)
  }
}

############################################################
## Installs any missing packages -- to be run on new systems
############################################################
installMissingPackages <- function(package_name) {
  if (! (package_name %in% rownames(installed.packages())) ) {
    install.packages(package_name, repos="http://cran.rstudio.com/")
  }
}

##################################################################################
## Loads all required packages in a package list (store in package_dependencies.R)
##################################################################################
loadRequiredPackages <- function(list) {
  for (package in list) {
    installMissingPackages(package)
    library(package, character.only=TRUE)
  }
}

###########################
## Cleans the R environment
###########################
cleanEnv <- function(){
  print("Detaching Packages")
  detachAllPackages()
  print("clearWorkSpace")
  clearWorkSpace()
}

##################################
# Detaches all non-base packages
##################################
detachAllPackages <- function() {
  basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
  package.list <- setdiff(package.list,basic.packages)
  if (length(package.list)>0) for (package in package.list) detach(package, character.only=TRUE)
}

############################################
# Clears out all R objects currently in ENV
############################################
clearWorkSpace <- function() {
  rm(list= ls(all=TRUE, envir = .GlobalEnv), envir = .GlobalEnv)
}