
library(dplyr)
library(ggplot2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Models/exploration'))

res <- as.tbl(read.csv('2016_12_03_02_34_10_lhs.csv'))
res$id = as.character(res$id)

indics = c("wealthGain","indivMigrations")

# histograms

for(indic in indics){
  g = ggplot(res[res$id=""|res$id="",])
  
}


# summarise

sres = res %>% group_by(distribSd,gravityDecay,overlapThreshold,transportationCost)%>% summarise(
  finalTime = mean(finalTime),nwClustCoef=mean(nwClustCoef),nwComponents=mean(nwComponents),
  nwInDegree=mean(nwInDegree),nwMeanFlow=mean(nwMeanFlow),nwOutDegree=mean(nwOutDegree),
  totalCost=mean(as.numeric(totalCost)),totalWaste=mean(totalWaste)#,
  #transportationCost=mean(transportationCost),gravityDecay=mean(gravityDecay),
  #distribSd=mean(distribSd),overlapThreshold=mean(overlapThreshold)
)


