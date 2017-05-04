
library(dplyr)
library(ggplot2)
library(reshape2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Results/Exploration'))

res <- as.tbl(read.csv('20170502_gridbaselinereal/data/2017_05_02_12_51_44_grid_baseline_real_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))

finalTime = as.numeric(res[1,12])
names(res)<-c(
  "accDecay","betaDC","costAccessRatio","deltaU0","deltaU1","distEco0","distEco1",
  "distPop","entropyEco0","entropyEco1","entropyPop","finalTime","gibratRate","id","incomeGrowth",
  "indivMigrations","jobDistance0","jobDistance1","lifeCostMode","migration0","migration1",
  "migrationShare",paste0("migrationTS_",1:finalTime),
  "moranEco0","moranEco1","moranPop","moveAversion","numCategories","segregCatShare","setupMode",
  "slopeEco0","slopeEco1","slopePop","slopeRsqEco0","slopeRsqEco1","slopeRsqPop",
  paste0("utilitiesDecOrigin0_",1:9),paste0("utilitiesDecOrigin1_",1:9),"wealth","wealthGain","wealthSigma")

res$type = rep("real",nrow(res))

ressynth <- as.tbl(read.csv('20170418_gridbaseline/data/2017_04_18_13_48_52_grid_baseline_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
finalTime = as.numeric(ressynth[1,12])
names(ressynth)<-c(
  "accDecay","betaDC","costAccessRatio","deltaU0","deltaU1","distEco0","distEco1",
  "distPop","entropyEco0","entropyEco1","entropyPop","finalTime","gibratRate","id","incomeGrowth",
  "indivMigrations","jobDistance0","jobDistance1","lifeCostMode","migration0","migration1",
  "migrationShare",paste0("migrationTS_",1:finalTime),
  "moranEco0","moranEco1","moranPop","moveAversion","numCategories","segregCatShare",
  "slopeEco0","slopeEco1","slopePop","slopeRsqEco0","slopeRsqEco1","slopeRsqPop",
  paste0("utilitiesDecOrigin0_",1:9),paste0("utilitiesDecOrigin1_",1:9),"wealth","wealthGain","wealthSigma")
ressynth$type = rep("synthetic",nrow(ressynth))
ressynth$setupMode = rep(0,nrow(ressynth))

res = rbind(res,ressynth)

rm(ressynth);gc()

params=c("betaDC","costAccessRatio","moveAversion")#,"wealthSigma","incomeGrowth","accDecay")
#indics = c("indivMigrations","deltaU0","migration0","migration1","deltaU1","jobDistance1",
#           "jobDistance0","utilitiesDecOrigin0_5","utilitiesDecOrigin0_1","utilitiesDecOrigin0_9")
#indics = c("indivMigrations","deltaU0","migration0","jobDistance0","utilitiesDecOrigin0_5",
#           "utilitiesDecOrigin0_1","utilitiesDecOrigin0_9")
indics = c("indivMigrations","deltaU0","migration0","migration1","deltaU1","jobDistance1",
           "jobDistance0","utilitiesDecOrigin0_5","utilitiesDecOrigin0_1","utilitiesDecOrigin0_9",
           "wealthGain","wealth","segregCatShare")


resdir = paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Results/Exploration/20170502_gridbaselinereal/')
dir.create(resdir)

# histograms

#g = ggplot(res)
#for(indic in indics){
#  for(param in params){
#    g+geom_density(aes_string(x=indic,group="id",colour=param))
#    ggsave(paste0(resdir,'varyingincgrowth_hist_',indic,'_color',param,'.pdf'),width=22.5,height=15,units='cm')
#  }
#}


# summarise

sres = res %>% group_by(id,type)%>% summarise(
  deltaU0 = mean(deltaU0),deltaU1=mean(deltaU1),indivMigrations=mean(indivMigrations),
  jobDistance0=mean(jobDistance0),migration0=mean(migration0),
  jobDistance1=mean(jobDistance1), migration1=mean(migration1),
  wealth=mean(wealth),wealthGain=mean(wealthGain),
  utilitiesDecOrigin0_1=mean(utilitiesDecOrigin0_1),utilitiesDecOrigin0_2=mean(utilitiesDecOrigin0_2),utilitiesDecOrigin0_3=mean(utilitiesDecOrigin0_3),utilitiesDecOrigin0_4=mean(utilitiesDecOrigin0_4),utilitiesDecOrigin0_5=mean(utilitiesDecOrigin0_5),utilitiesDecOrigin0_6=mean(utilitiesDecOrigin0_6),utilitiesDecOrigin0_7=mean(utilitiesDecOrigin0_7),utilitiesDecOrigin0_8=mean(utilitiesDecOrigin0_8),utilitiesDecOrigin0_9=mean(utilitiesDecOrigin0_9),
  accDecay=mean(accDecay),costAccessRatio=mean(costAccessRatio),
  betaDC=mean(betaDC),wealthSigma=mean(wealthSigma),moveAversion=mean(moveAversion),
  incomeGrowth=mean(incomeGrowth),segregCatShare=mean(segregCatShare)
)


####

### line plots as function of beta_DC

for(indic in indics){
  g=ggplot(sres[sres$type=="real",],aes_string(x="betaDC",y=indic,color="moveAversion",group="moveAversion"))
  g+geom_line()+facet_wrap(~costAccessRatio,scales="free")
  ggsave(paste0(resdir,'real_indic',indic,'.pdf'),width=30,height = 20,units='cm')
}


# smoothed job distance
for(indic in c("jobDistance0","jobDistance1")){
  g=ggplot(sres[sres$type=="real",],aes_string(x="betaDC",y=indic,color="moveAversion",group="moveAversion"))
  g+geom_line()+facet_wrap(~costAccessRatio,scales="free")+geom_smooth()
  ggsave(paste0(resdir,'real_indic',indic,'_smoothed.pdf'),width=30,height = 20,units='cm')
}

### distrib of origin utilities

#melt(sres[,c(paste0("utilitiesDecOrigin0_",1:9),"betaDC","costAccessRatio","moveAversion")],
#     measure.vars = 
#     )

#quantiles = c();vals=c();cbetaDC=c();ccostAccessRatio=c();cmoveAversion=c()
#for(i in 1:nrow(sres)){
#  for(k in 1:9){
#    vals=append(vals,sres[[paste0("utilitiesDecOrigin0_",k)]][i]);quantiles=append(quantiles,k/10)
#  }
#  cbetaDC=append(cbetaDC,rep(sres$betaDC[i],9)); ccostAccessRatio=append(ccostAccessRatio,rep(sres$costAccessRatio[i],9)); cmoveAversion=append(cmoveAversion,rep(sres$moveAversion[i],9))
#}

#g=ggplot(data.frame(quantiles,vals,cbetaDC,ccostAccessRatio,cmoveAversion),aes(x=vals,y=quantiles,color=cbetaDC,group=cbetaDC))
#g+geom_line()+facet_grid(cmoveAversion~ccostAccessRatio,scales="free")


### Temporal trajectories

trajs = data.frame()
for(t in 1:20){
  tmp = res[res$type=="real",c(paste0("migrationTS_",t),params)];names(tmp)[1]="migr"
  stmp <- tmp %>% group_by(betaDC,costAccessRatio,moveAversion) %>% summarise(migr=mean(migr))
  trajs=rbind(trajs,cbind(stmp,t=rep(t,nrow(stmp))))
}

g=ggplot(trajs,aes(x=t,y=migr,color=betaDC,group=betaDC))
g+geom_point()+geom_line()+facet_grid(moveAversion~costAccessRatio,scales="free")
ggsave(paste0(resdir,'real_temporaltrajs.pdf'),width=30,height = 20,units='cm')


##

# final - initial
sres = res %>% group_by(betaDC,moveAversion,costAccessRatio,wealthSigma,type) %>% summarise(diff = mean(migrationTS_20+migrationTS_19+migrationTS_18-migrationTS_3-migrationTS_2-migrationTS_1))
g=ggplot(sres[sres$type=="real",],aes(x=betaDC,y=diff,color=moveAversion,group=moveAversion))
#g+geom_line()+facet_wrap(~costAccessRatio)+ylab("Migrations (t=20) - Migrations (t=1)")
g+geom_line()+facet_grid(costAccessRatio~wealthSigma)+ylab("Migrations (t=20) - Migrations (t=1)")
ggsave(paste0(resdir,'migr-diff-final.pdf'),width=30,height=20,units='cm')


# final - middle
sres = res %>% group_by(betaDC,moveAversion,costAccessRatio,wealthSigma,type) %>% summarise(diff = mean(migrationTS_20+migrationTS_19+migrationTS_18-migrationTS_11-migrationTS_10-migrationTS_9))
g=ggplot(sres[sres$type=="real",],aes(x=betaDC,y=diff,color=moveAversion,group=moveAversion))
#g+geom_line()+facet_wrap(~costAccessRatio)+ylab("Migrations (t=20) - Migrations (t=10)")
g+geom_line()+facet_grid(costAccessRatio~wealthSigma)+ylab("Migrations (t=20) - Migrations (t=10)")
ggsave(paste0(resdir,'migr-diff-final-middle.pdf'),width=30,height=20,units='cm')





