library(R.matlab)
library(maxnodf)

data = '' #add date here
af0_dir = '' #add directory name here for assembly w/ AF
af1_dir = '' #add directory name here for assembly w/o AF
spc_prob <- c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)
snapshots <- seq(6000, 100000, 2000) 
af0_nodfc <- rep(0, length(spc_prob) * length(spc_prob) * length(snapshots))
af1_nodfc <- rep(0, length(spc_prob) * length(spc_prob) * length(snapshots))
it = 1
for (p in spc_prob)  {
  for (a in spc_prob) {
    for (snap in snapshots) {

      af0_net <- as.matrix(readMat(sprintf('results/%s/%s/output_p%.1f_a%.1f/modelled/snapshots/snapshot-%d.mat', date, af0_dir, p, a, snap))$A)
      af0_net[af0_net != 0] <- 1
      af0_nodfc[it] <- NODFc(af0_net)
      
      af1_net <- as.matrix(readMat(sprintf('results/%s/%s/output_p%.1f_a%.1f/modelled/snapshots/snapshot-%d.mat', date, af1_dir, p, a, snap))$A)
      af1_net[af1_net != 0] <- 1
      af1_nodfc[it] <- NODFc(af1_net)
      
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
