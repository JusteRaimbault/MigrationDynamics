
library(dplyr)
library(ggplot2)
library(reshape2)

setwd(paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Results/Exploration'))

#res <- as.tbl(read.csv('20170418_gridbaseline/data/2017_04_18_13_48_52_grid_baseline_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
#res <- as.tbl(read.csv('20170419_gridbaselinetwocat/data/2017_04_19_10_33_53_grid_baselinetwocat_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
#res <- as.tbl(read.csv('20170420_gridincgrowth/data/2017_04_20_17_49_41_grid_incgrowth_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
#res <- as.tbl(read.csv('20170428_gridwealthsigma/data/2017_04_28_09_44_57_grid_wealthsigma_grid.csv',stringsAsFactors = FALSE,header=F,skip = 1))
res <- as.tbl(read.csv('20170504_gridpolicies/data/extract.csv',sep=";",stringsAsFactors = FALSE,header=F,skip = 1))
baseline <- as.tbl(read.csv('20170506_gridbaselinewithinc/data/extract.csv',sep=";",stringsAsFactors = FALSE,header=F,skip = 1))


#finalTime = as.numeric(res[1,12])
finalTime = as.numeric(res[1,6])
names(res)<-c(
  "accDecay","betaDC","costAccessRatio","deltaU0","deltaU1",
  #"distEco0","distEco1","distPop","entropyEco0","entropyEco1",
  #"entropyPop",
  "finalTime","gibratRate","id","incomeGrowth",
  "indivMigrations","jobDistance0","jobDistance1",
  #"lifeCostMode",
  "migration0","migration1",
  #"migrationShare",paste0("migrationTS_",1:finalTime),
  #"moranEco0","moranEco1","moranPop",#46
  "moveAversion","numCategories","policyCityNum","policyType","policyValue","segregCatShare"#,
  #"slopeEco0","slopeEco1","slopePop","slopeRsqEco0","slopeRsqEco1","slopeRsqPop",
  #paste0("utilitiesDecOrigin0_",1:9),paste0("utilitiesDecOrigin1_",1:9),"wealth","wealthGain","wealthSigma"
  )

names(baseline)<-paste0("baseline_",names(res))

params=c("betaDC","costAccessRatio","moveAversion","wealthSigma")#,"incomeGrowth","accDecay")
#indics = c("indivMigrations","deltaU0","migration0","migration1","deltaU1","jobDistance1",
#           "jobDistance0","utilitiesDecOrigin0_5","utilitiesDecOrigin0_1","utilitiesDecOrigin0_9")
#indics = c("indivMigrations","deltaU0","migration0","jobDistance0","utilitiesDecOrigin0_5",
#           "utilitiesDecOrigin0_1","utilitiesDecOrigin0_9")
indics = c("indivMigrations","deltaU0","migration0","migration1","deltaU1","jobDistance1",
           "jobDistance0",
           #"utilitiesDecOrigin0_5","utilitiesDecOrigin0_1","utilitiesDecOrigin0_9",
           #"wealthGain","wealth",
           "segregCatShare")


resdir = paste0(Sys.getenv('CS_HOME'),'/MigrationDynamics/Results/Exploration/20170504_gridpolicies/')
dir.create(resdir)


# histograms

g = ggplot(res)
for(indic in indics){
  for(param in params){
    g+geom_density(aes_string(x=indic,group="id",colour=param))
    ggsave(paste0(resdir,'varyingincgrowth_hist_',indic,'_color',param,'.pdf'),width=22.5,height=15,units='cm')
  }
}


# summarise

sres = res[res$policyType==2,] %>% group_by(id)%>% summarise(
  deltaU0 = mean(deltaU0),deltaU1=mean(deltaU1),indivMigrations=mean(indivMigrations),
  jobDistance0=mean(jobDistance0),migration0=mean(migration0),
  jobDistance1=mean(jobDistance1), migration1=mean(migration1),
  #wealth=mean(wealth),wealthGain=mean(wealthGain),
  #utilitiesDecOrigin0_1=mean(utilitiesDecOrigin0_1),utilitiesDecOrigin0_2=mean(utilitiesDecOrigin0_2),utilitiesDecOrigin0_3=mean(utilitiesDecOrigin0_3),utilitiesDecOrigin0_4=mean(utilitiesDecOrigin0_4),utilitiesDecOrigin0_5=mean(utilitiesDecOrigin0_5),utilitiesDecOrigin0_6=mean(utilitiesDecOrigin0_6),utilitiesDecOrigin0_7=mean(utilitiesDecOrigin0_7),utilitiesDecOrigin0_8=mean(utilitiesDecOrigin0_8),utilitiesDecOrigin0_9=mean(utilitiesDecOrigin0_9),
  accDecay=mean(accDecay),costAccessRatio=mean(costAccessRatio),
  betaDC=mean(betaDC),
  #wealthSigma=mean(wealthSigma),
  moveAversion=mean(moveAversion),
  incomeGrowth=mean(incomeGrowth),segregCatShare=mean(segregCatShare),
  policyValue=mean(policyValue),policyCityNum=mean(policyCityNum)
)

sres1 = res[res$policyType==1,] %>% group_by(id)%>% summarise(
  deltaU0 = mean(deltaU0),deltaU1=mean(deltaU1),indivMigrations=mean(indivMigrations),
  jobDistance0=mean(jobDistance0),migration0=mean(migration0),
  jobDistance1=mean(jobDistance1), migration1=mean(migration1),
  #wealth=mean(wealth),wealthGain=mean(wealthGain),
  #utilitiesDecOrigin0_1=mean(utilitiesDecOrigin0_1),utilitiesDecOrigin0_2=mean(utilitiesDecOrigin0_2),utilitiesDecOrigin0_3=mean(utilitiesDecOrigin0_3),utilitiesDecOrigin0_4=mean(utilitiesDecOrigin0_4),utilitiesDecOrigin0_5=mean(utilitiesDecOrigin0_5),utilitiesDecOrigin0_6=mean(utilitiesDecOrigin0_6),utilitiesDecOrigin0_7=mean(utilitiesDecOrigin0_7),utilitiesDecOrigin0_8=mean(utilitiesDecOrigin0_8),utilitiesDecOrigin0_9=mean(utilitiesDecOrigin0_9),
  accDecay=mean(accDecay),costAccessRatio=mean(costAccessRatio),
  betaDC=mean(betaDC),
  #wealthSigma=mean(wealthSigma),
  moveAversion=mean(moveAversion),
  incomeGrowth=mean(incomeGrowth),segregCatShare=mean(segregCatShare),
  policyValue=mean(policyValue),policyCityNum=mean(policyCityNum)
)

sresbasline = baseline %>% group_by(baseline_moveAversion,baseline_accDecay,baseline_costAccessRatio,baseline_betaDC)%>% summarise(
  deltaU0 = mean(baseline_deltaU0),deltaU1=mean(baseline_deltaU1),indivMigrations=mean(baseline_indivMigrations),
  jobDistance0=mean(baseline_jobDistance0),migration0=mean(baseline_migration0),
  jobDistance1=mean(baseline_jobDistance1), migration1=mean(baseline_migration1),
  #wealth=mean(wealth),wealthGain=mean(wealthGain),
  #utilitiesDecOrigin0_1=mean(utilitiesDecOrigin0_1),utilitiesDecOrigin0_2=mean(utilitiesDecOrigin0_2),utilitiesDecOrigin0_3=mean(utilitiesDecOrigin0_3),utilitiesDecOrigin0_4=mean(utilitiesDecOrigin0_4),utilitiesDecOrigin0_5=mean(utilitiesDecOrigin0_5),utilitiesDecOrigin0_6=mean(utilitiesDecOrigin0_6),utilitiesDecOrigin0_7=mean(utilitiesDecOrigin0_7),utilitiesDecOrigin0_8=mean(utilitiesDecOrigin0_8),utilitiesDecOrigin0_9=mean(utilitiesDecOrigin0_9),
  accDecay=mean(baseline_accDecay),costAccessRatio=mean(baseline_costAccessRatio),
  betaDC=mean(baseline_betaDC),
  #wealthSigma=mean(wealthSigma),
  moveAversion=mean(baseline_moveAversion),
  incomeGrowth=mean(baseline_incomeGrowth),segregCatShare=mean(baseline_segregCatShare),
  policyValue=mean(baseline_policyValue),policyCityNum=mean(baseline_policyCityNum)
)


subsres=sres[sres$policyValue==1&sres$policyCityNum==2&sres$moveAversion%in%sresbasline$moveAversion&sres$betaDC%in%sresbasline$betaDC&sres$costAccessRatio%in%sresbasline$costAccessRatio,]
all = left_join(subsres,
                #sres1[sres$policyValue==1&sres$policyCityNum==3,],
                sresbasline,
                by=c("moveAversion"="moveAversion",
                     "costAccessRatio"="costAccessRatio",
                     "betaDC"="betaDC"
                     )
)


####

### line plots as function of beta_DC

for(indic in indics){
  g=ggplot(all,aes_string(x="betaDC",y=paste0(indic,".x-",indic,".y"),color="moveAversion",group="moveAversion"))
  #g+geom_line()+facet_wrap(~costAccessRatio,scales="free")
  #g+geom_line()+facet_grid(costAccessRatio~wealthSigma,scales="free")
  g+geom_line()+stat_smooth(span = 0.5)+facet_wrap(~costAccessRatio,scales="free")#+facet_grid(policyValue~policyCityNum,scales="free")
  ggsave(paste0(resdir,'diff_policy2-city2-value1_indic',indic,'.pdf'),width=30,height = 20,units='cm')
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

# final - initial
sres = res %>% group_by(betaDC,moveAversion,costAccessRatio,wealthSigma) %>% summarise(diff = mean(migrationTS_20+migrationTS_19+migrationTS_18-migrationTS_3-migrationTS_2-migrationTS_1))
g=ggplot(sres,aes(x=betaDC,y=diff,color=moveAversion,group=moveAversion))
#g+geom_line()+facet_wrap(~costAccessRatio)+ylab("Migrations (t=20) - Migrations (t=1)")
g+geom_line()+facet_grid(costAccessRatio~wealthSigma)+ylab("Migrations (t=20) - Migrations (t=1)")
ggsave(paste0(resdir,'migr-diff-final.pdf'),width=30,height=20,units='cm')


# final - middle
sres = res %>% group_by(betaDC,moveAversion,costAccessRatio,wealthSigma) %>% summarise(diff = mean(migrationTS_20+migrationTS_19+migrationTS_18-migrationTS_11-migrationTS_10-migrationTS_9))
g=ggplot(sres,aes(x=betaDC,y=diff,color=moveAversion,group=moveAversion))
#g+geom_line()+facet_wrap(~costAccessRatio)+ylab("Migrations (t=20) - Migrations (t=10)")
g+geom_line()+facet_grid(costAccessRatio~wealthSigma)+ylab("Migrations (t=20) - Migrations (t=10)")
ggsave(paste0(resdir,'migr-diff-final-middle.pdf'),width=30,height=20,units='cm')





