#library(ringbp)
setwd("/Users/jpetrie/Desktop/Covid/adoptionAnalysis/impact-sim")
source("R/scenario_sim.R")

library(data.table)
library(plyr)

cap_cases = 50000


n.sim = 200

fracApp = c(0.01,0.1, 0.2,0.3, 0.4,0.5, 0.6,0.7, 0.8, 0.9, 0.99) # fraction of the population using the app
mixing = seq(0.0,1.0, length.out = 5) # how well mixed the app group is with the non-app group (0 = separate, 1 = homegenous)


appAcc = 0.9 # contact tracing accuracy if both people have app
genAcc = 0.5 # contact tracing accuracy if at least one doesn't have app

params = data.table(expand.grid(fracApp = fracApp, mixing = mixing))

sweepRes = mdply(params, function(fracApp, mixing){
  res <- scenario_sim(n.sim = n.sim,
num.initial.cases = 10,
cap_max_days = 45,
cap_cases = cap_cases,
r0isolated = 0.0,
r0community = 2.5,
disp.iso = 1,
disp.com = 0.16,
k = 0.7,
delay_shape = 1.651524,
delay_scale = 4.287786,
prop.asym = 0,
prop.ascertain = 0.8,
quarantine = TRUE,
fracApp = fracApp,
mixing = mixing,
appAcc = appAcc,
genAcc = genAcc)
  res[,fracApp := fracApp]
  res[, mixing:=mixing]
})

sweepRes[,cases_per_gen := NULL]

if(file.exists("simResults.csv")){
  
  write.table(sweepRes, "simResults.csv", append = TRUE, sep = ",", row.names = FALSE, col.names = FALSE)
}else{
  
  write.table(sweepRes, "simResults.csv", sep = ",", row.names = FALSE)
}
