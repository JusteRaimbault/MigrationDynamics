
library(dplyr)
library(ggplot2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Models/exploration'))

res <- as.tbl(read.csv('2016_12_03_14_46_02_grid.csv'))
res$id = as.character(cumsum(c(1,diff(res$accDecay)>0)))


indics = c("wealthGain","indivMigrations")




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


indic="wealthGain"
g = ggplot(sres,aes_string(x="wealthSigma",y="costAccessRatio",fill=indic))
g+geom_raster(hjust=0,vjust=0)+facet_grid(moveAversion~accDecay,scales = "free")+scale_fill_gradient(low='yellow',high='red')





