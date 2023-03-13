library(R.matlab)
library(maxnodf)

date = '03_13_2023' #add date here
af0_dir = 'AF0' #add directory name here for assembly w/ AF
af1_dir = 'AF1' #add directory name here for assembly w/o AF
#spc_prob <- c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)
spc_prob <- 0.5
snapshots <- seq(8000, 100000, 2000) 
af0_nodfc <- rep(NA, length(spc_prob) * length(spc_prob) * length(snapshots))
af1_nodfc <- rep(NA, length(spc_prob) * length(spc_prob) * length(snapshots))
it = 1
for (p in spc_prob)  {
  for (a in spc_prob) {
    for (snap in snapshots) {

      af0_net <- as.matrix(readMat(sprintf('results/%s/%s/output_p%.1f_a%.1f/modelled/snapshots/snapshot-%d.mat', date, af0_dir, p, a, snap))$A)
      af0_net[af0_net != 0] <- 1
      if (sum(af0_net) > nrow(af0_net) + ncol(af0_net)) {
        af0_nodfc[it] <- NODFc(af0_net)
      }

      af1_net <- as.matrix(readMat(sprintf('results/%s/%s/output_p%.1f_a%.1f/modelled/snapshots/snapshot-%d.mat', date, af1_dir, p, a, snap))$A)
      af1_net[af1_net != 0] <- 1
      if (sum(af1_net) > nrow(af1_net) + ncol(af1_net)) {
        af1_nodfc[it] <- NODFc(af1_net)
      }
      
      it = it + 1
    }
  }
}

af0_data <- read.csv(sprintf('./results/%s/%s/data_table.csv', date, af0_dir))
af0_data$NODFc <- af0_nodfc
write.csv(af0_data, sprintf('./results/%s/%s/data_table.csv', date, af0_dir))

af1_data <- read.csv(sprintf('./results/%s/%s/data_table.csv', date, af1_dir))
af1_data$NODFc <- af1_nodfc
write.csv(af1_data, sprintf('./results/%s/%s/data_table.csv', date, af1_dir))
