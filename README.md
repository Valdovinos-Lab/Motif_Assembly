# Code for "The role of intra-guild indirect interactions in assembling plant-pollinator networks"

## System Requirements

* Plant-Pollinator_Network_Builder.mltbx included in this repository. 
* The function ```nodfc.R``` used to calculate the nestedness of each assembled network requires the use of R packages R.matlab (version 3.7.0) and maxnodf (version 1.0.0)
* This code was run using MATLAB_R2021b

## Installation Guide 

* Plant-Pollinator_Network_Builder.mltbx can be installed using the Add-On Explorer in MATLAB

## Demo

The files run_assembly_AF1.m and run_assembly_AF0.m run a suite of simulations to assemble plant-pollinator networks with and without adaptive foraging dynamics, respectively. To run these functions you will specify a date and directory name used to label the output folder.

```matlab
run_assembly_AF1('03_10_2023', 'AF1')
run_assembly_AF0('03_10_2023', 'AF0')
```

The expected runtime is ~45 minutes for each group (90 minutes total). To demo the assembly model without running the whole thing try only running the case where the probability for coloning plants and pollinators to be specialist is 0.5 by making the following changes to run_assembly_AF1.m and run_assembly_AF0.m.

```matlab
for spc_plant_prob = 0.5 % changed from 0:0.1:1
        for spc_pol_prob = 0.5 % changed from 0:0.1:1
```

The output folders ```03_10_2023/AF1``` and ```03_10_2023/AF0``` will include:

* ```data_table.csv``` a table containing network summary statistics for each assembly simulation. To add nestedness values to this table run ```nodfc.R``` which calculates nestedness with the maxnodf R package.
* ```motifs``` folder containing information to categorize each colonizer from each assembly simulation into their motif groups. 
* ```output_p*_a*``` folders containing detailed simulation output, the values following "p" and "a" correspond with the probability that colonizers are specialists for plants and pollinators, respectively.

## Instructions for Use

To reproduce data from the paper, just run the simulation as is. If you would like to edit the assembly parameters (ex. time span, colonization frequency, number of colonizers per colonization event) you can do so by editing the "params" variable in run_assembly_AF1.m and run_assembly_AF0.m. For instance, if you wanted to experiment with colonizers entering the network every 500 timesteps you would make the following changes:

```matlab
params = Parameters(output_dir, ...
                        'TimeStep', 500, ... %changed from 2000 
                        'EndTime', 100000, ...
                        'SpcPlantProb', spc_plant_prob, ...
                        'SpcPolProb', spc_pol_prob, ...
                        'InvPlantProb', 1, ...
                        'InvPolProb', 1, ...
                        'InvPolDists', inv_pol_dist, ...
                        'InvPlantDists', inv_plant_dist, ...
                        'NumPlantsPerTimeStep', 3, ...
                        'NumPolsPerTimeStep',  3, ...
                        'RedistStrat', RedistributeDefault);
```
