# test for WBM installation:
# Compare wbm_SHORT_standard output to wbm_SHORT output 
# written 2017-06-13 by Danielle S Grogan, University of New Hampshire

if("ncdf4" %in% rownames(installed.packages()) == FALSE) {install.packages("ncdf4",repos = "http://cran.us.r-project.org", dependencies=T)}
if("raster" %in% rownames(installed.packages()) == FALSE) {install.packages("raster",repos = "http://cran.us.r-project.org", dependencies=T)}
library(raster)

st.path<-"/wbm/wbm_output/wbm_short_standard/"
cp.path<-"/wbm/wbm_output/wbm_short/"

vars<-c("discharge", "evapotrans", "grdWater", "runoff", "snowPack", "soilMoist")

# daily
for(year in 2000:2001){
  for(v in 1:length(vars)){
    st<-brick(paste(st.path, "daily/wbm_", year, ".nc", sep=""), varname=vars[v])
    cp<-brick(paste(cp.path, "daily/wbm_", year, ".nc", sep=""), varname=vars[v])
    
    test.match<-(st==cp)
    sum.test.match<-calc(test.match, fun=sum, na.rm=T)
    
    n.cells<-(!is.na(st))
    sum.n.cells<-calc(n.cells, fun=sum, na.rm=T)
    
    if(min(as.matrix(sum.test.match == sum.n.cells)) == 0){
      error_massage<-paste("Mismatch found in ", cp.path, "daily/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(error_massage)
    }else{
      good_massage<-paste("Good match: ", cp.path, "daily/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(good_massage)
    }
  }
}

# monthly
for(year in 2000:2001){
  for(v in 1:length(vars)){
    st<-brick(paste(st.path, "monthly/", vars[v], "/wbm_", year, ".nc", sep=""), varname=vars[v])
    cp<-brick(paste(cp.path, "monthly/", vars[v], "/wbm_", year, ".nc", sep=""), varname=vars[v])
    
    test.match<-(st==cp)
    sum.test.match<-calc(test.match, fun=sum, na.rm=T)
    
    n.cells<-(!is.na(st))
    sum.n.cells<-calc(n.cells, fun=sum, na.rm=T)
    
    if(min(as.matrix(sum.test.match == sum.n.cells)) == 0){
      error_massage<-paste("Mismatch found in ", cp.path, "monthly/", vars[v], "/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(error_massage)
    }else{
      good_massage<-paste("Good match: ", cp.path, "monthly/", vars[v], "/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(good_massage)
    }
  }
}

# yearly
for(year in 2000:2001){
  for(v in 1:length(vars)){
    st<-raster(paste(st.path, "yearly/", vars[v], "/wbm_", year, ".nc", sep=""), varname=vars[v])
    cp<-raster(paste(cp.path, "yearly/", vars[v], "/wbm_", year, ".nc", sep=""), varname=vars[v])
    
    test.match<-(st==cp)

    if(min(as.matrix(test.match), na.rm=T) == 0){
      error_massage<-paste("Mismatch found in ", cp.path, "yearly/", vars[v], "/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(error_massage)
    }else{
      good_massage<-paste("Good match: ", cp.path, "yearly/", vars[v], "/wbm_", year, ".nc, variable: ", vars[v], sep="")
      print(good_massage)
    }
  }
}

# climatology
st.clim<-dir(paste(st.path, "climatology", sep=""), pattern=".nc")
cp.clim<-dir(paste(cp.path, "climatology", sep=""), pattern=".nc")

if(length(st.clim) != length(cp.clim)){
  error_message<-paste("Climatology files do not match: there are ", length(st.clim), " standard files and ",
                       length(cp.clim), " test files.", sep="")
  print(error_message)
}else{
  for(i in 1:length(st.clim)){
    st<-raster(paste(st.path, "climatology/", st.clim[i], sep=""))
    cp<-raster(paste(st.path, "climatology/", cp.clim[i], sep=""))
    
    test.match<-(st==cp)
    
    if(min(as.matrix(test.match), na.rm=T) == 0){
      error_massage<-paste("Mismatch found in ", cp.path, "climatology/", cp.clim[i], sep="")
      print(error_massage)
    }else{
      good_massage<-paste("Good match: ", cp.path, "climatology/", cp.clim[i], sep="")
      print(good_massage)
    }
    
  }
}


