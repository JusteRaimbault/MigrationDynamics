
library(dplyr)
library(ggplot2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Models/Mingong'))

#res <- as.tbl(read.csv('2016_12_03_14_46_02_grid.csv'))
res <- as.tbl(read.csv('exploration/2017_04_07_13_58_56_grid_uniform_grid.csv',stringsAsFactors = FALSE))

params=c("accDecay","costAccessRatio","moveAversion","wealthSigma")
indics = c("wealthGain","indivMigrations")

res$id=rep("",nrow(res))
i=1
for(row in which(!duplicated(res[,params]))){
  show(i);currentrow=res[row,params]
  res$id[res$accDecay==currentrow$accDecay&res$costAccessRatio==currentrow$costAccessRatio&res$moveAversion==currentrow$moveAversion&res$wealthSigma==currentrow$wealthSigma]=as.character(i)
  i=i+1
}



# histograms

for(indic in indics){
  g = ggplot(res)
  g+geom_density(aes_string(x=indic,group="id",colour="id"))
}


g = ggplot(res[res$id=="1"|res$id=="20"|res$id=="28",])
g+geom_density(aes(x=wealthGain,fill=id),alpha=0.3)
g+geom_density(aes(x=indivMigrations,fill=id),alpha=0.3)


# summarise

sres = res %>% group_by(accDecay,costAccessRatio,wealthSigma,moveAversion)%>% summarise(
  deltaU0 = mean(deltaU0),deltaU1=mean(deltaU1),indivMigrations=mean(indivMigrations),
  jobDistance0=mean(jobDistance0),jobDistance1=mean(jobDistance1),migration0=mean(migration0),
  migration1=mean(migration1),wealth=mean(wealth),wealthGain=mean(wealthGain)#,
  #accDecay=mean(accDecay),costAccessRatio=mean(costAccessRatio),
  #wealthSigma=mean(wealthSigma),moveAversion=mean(moveAversion)
)


indic="indivMigrations"
g = ggplot(sres,aes_string(x="wealthSigma",y="costAccessRatio",fill=indic))
g+geom_raster(hjust=0,vjust=0)+facet_grid(moveAversion~accDecay,scales = "free")+scale_fill_gradient(low='yellow',high='red')


###
for(indic in indics){
g=ggplot(sres,aes_string(x="wealthSigma",y=indic,color="moveAversion",group="moveAversion"))
g+geom_line()+facet_grid(costAccessRatio~accDecay,scales="free")
}
###











