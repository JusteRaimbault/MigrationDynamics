
library(dplyr)
library(ggplot2)
library(reshape2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Models/Mingong'))

#res <- as.tbl(read.csv('2016_12_03_14_46_02_grid.csv'))
res <- as.tbl(read.csv('exploration/2017_04_14_22_12_17_grid_baseline_local.csv',stringsAsFactors = FALSE,header=F,skip = 1))

names(res)<-c(
  "accDecay","betaDC","costAccessRatio","deltaU0","deltaU1","distEco0","distEco1",
  "distPop","entropyEco0","entropyEco1","entropyPop","gibratRate","incomeGrowth",
  "indivMigrations","jobDistance0","jobDistance1","lifeCostMode","migration0","migration1",
  "migrationShare",paste0("migrationTS_",1:10),
  "moranEco0","moranEco1","moranPop","moveAversion","numCategories","segregCatShare",
  "slopeEco0","slopeEco1","slopePop","slopeRsqEco0","slopeRsqEco1","slopeRsqPop",
  paste0("utilitiesDecOrigin0_",1:9),paste0("utilitiesDecOrigin1_",1:9),"wealth","wealthGain","wealthSigma")

params=c("betaDC","costAccessRatio","moveAversion")#,"wealthSigma","accDecay")
#indics = c("indivMigrations","deltaU0","migration0","migration1","deltaU1","jobDistance1",
#           "jobDistance0","utilitiesDecOrigin0_5","utilitiesDecOrigin0_1","utilitiesDecOrigin0_9")

res$id=rep("",nrow(res))
i=1
for(row in which(!duplicated(res[,params]))){
  show(i);currentrow=res[row,params]
  res$id[res$costAccessRatio==currentrow$costAccessRatio&res$moveAversion==currentrow$moveAversion&res$betaDC==currentrow$betaDC]=as.character(i)
  i=i+1
}

res2 = as.tbl(read.csv('exploration/2017_04_18_10_32_48_grid_baselineext_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
names(res2)<-c(
  "accDecay","betaDC","costAccessRatio","deltaU0","deltaU1","distEco0","distEco1",
  "distPop","entropyEco0","entropyEco1","entropyPop","gibratRate","id","incomeGrowth",
  "indivMigrations","jobDistance0","jobDistance1","lifeCostMode","migration0","migration1",
  "migrationShare",paste0("migrationTS_",1:10),
  "moranEco0","moranEco1","moranPop","moveAversion","numCategories","segregCatShare",
  "slopeEco0","slopeEco1","slopePop","slopeRsqEco0","slopeRsqEco1","slopeRsqPop",
  paste0("utilitiesDecOrigin0_",1:9),paste0("utilitiesDecOrigin1_",1:9),"wealth","wealthGain","wealthSigma")
res2$id=as.character(as.numeric(res2$id)+max(as.numeric(res$id))+1)

res=rbind(res,res2[,colnames(res)])

resdir = paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Results/Exploration/20170418_baselineext/')
dir.create(resdir)

# histograms

g = ggplot(res)
for(indic in indics){
  for(param in params){
    g+geom_density(aes_string(x=indic,group="id",colour=param))
    ggsave(paste0(resdir,'baseline_hist_',indic,'_color',param,'.pdf'),width=15,height=10,units='cm')
  }
}


# summarise

sres = res %>% group_by(id)%>% summarise(
  deltaU0 = mean(deltaU0),deltaU1=mean(deltaU1),indivMigrations=mean(indivMigrations),
  jobDistance0=mean(jobDistance0),jobDistance1=mean(jobDistance1),migration0=mean(migration0),
  migration1=mean(migration1),wealth=mean(wealth),wealthGain=mean(wealthGain),
  utilitiesDecOrigin0_1=mean(utilitiesDecOrigin0_1),utilitiesDecOrigin0_2=mean(utilitiesDecOrigin0_2),utilitiesDecOrigin0_3=mean(utilitiesDecOrigin0_3),utilitiesDecOrigin0_4=mean(utilitiesDecOrigin0_4),utilitiesDecOrigin0_5=mean(utilitiesDecOrigin0_5),utilitiesDecOrigin0_6=mean(utilitiesDecOrigin0_6),utilitiesDecOrigin0_7=mean(utilitiesDecOrigin0_7),utilitiesDecOrigin0_8=mean(utilitiesDecOrigin0_8),utilitiesDecOrigin0_9=mean(utilitiesDecOrigin0_9),
  accDecay=mean(accDecay),costAccessRatio=mean(costAccessRatio),
  betaDC=mean(betaDC),wealthSigma=mean(wealthSigma),moveAversion=mean(moveAversion)
)


####

### line plots as function of beta_DC

for(indic in indics){
  g=ggplot(sres,aes_string(x="betaDC",y=indic,color="moveAversion",group="moveAversion"))
  g+geom_line()+facet_wrap(~costAccessRatio,scales="free")
  ggsave(paste0(resdir,'baseline_indic',indic,'.pdf'),width=30,height = 20,units='cm')
}




### distrib of origin utilities

#melt(sres[,c(paste0("utilitiesDecOrigin0_",1:9),"betaDC","costAccessRatio","moveAversion")],
#     measure.vars = 
#     )

quantiles = c();vals=c();cbetaDC=c();ccostAccessRatio=c();cmoveAversion=c()
for(i in 1:nrow(sres)){
  for(k in 1:9){
    vals=append(vals,sres[[paste0("utilitiesDecOrigin0_",k)]][i]);quantiles=append(quantiles,k/10)
  }
  cbetaDC=append(cbetaDC,rep(sres$betaDC[i],9)); ccostAccessRatio=append(ccostAccessRatio,rep(sres$costAccessRatio[i],9)); cmoveAversion=append(cmoveAversion,rep(sres$moveAversion[i],9))
}

g=ggplot(data.frame(quantiles,vals,cbetaDC,ccostAccessRatio,cmoveAversion),aes(x=vals,y=quantiles,color=cbetaDC,group=cbetaDC))
g+geom_line()+facet_grid(cmoveAversion~ccostAccessRatio,scales="free")


### Temporal trajectories

trajs = data.frame()
for(t in 1:10){
  tmp = res[,c(paste0("migrationTS_",t),params)];names(tmp)[1]="migr"
  stmp <- tmp %>% group_by(betaDC,costAccessRatio,moveAversion) %>% summarise(migr=mean(migr))
  trajs=rbind(trajs,cbind(stmp,t=rep(t,nrow(stmp))))
}

g=ggplot(trajs,aes(x=t,y=migr,color=betaDC,group=betaDC))
g+geom_point()+geom_line()+facet_grid(moveAversion~costAccessRatio,scales="free")

##
sres = res %>% group_by(betaDC,costAccessRatio,moveAversion) %>% summarise(diff = mean(migrationTS_10+migrationTS_9-migrationTS_1-migrationTS_2))
g=ggplot(sres,aes(x=betaDC,y=diff,color=moveAversion,group=moveAversion))
g+geom_line()+facet_wrap(~costAccessRatio)+ylab("Final Migrations - Initial Migrations")
ggsave(paste0(resdir,'migr-diff.pdf'),width=15,height=10,units='cm')





