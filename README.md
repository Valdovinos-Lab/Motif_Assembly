# Motif_Assembly

Code for "The role of intra-guild indirect interactions in assembling plant-pollinator networks"

In order to run these simulations you must first download the MATLAB toolbox, "Plant-Pollinator_Network_Builder.mltbx", included in this repository.

The files ```run_assembly_AF1.m``` and ```run_assembly_AF0.m``` run a suite of simulations to assemble plant-pollinator networks with and without adaptive foraging dynamics, respectively. To run these functions you will specify a date and directory name used to label the output folder.

The output folder ```date/directory_name``` will include:

*```output_p*_a*``` folders containing detailed simulation output, the values following "p" and "a" in the simulation output folders correspond with the probability that colonizers are specialists for plants and pollinators, respectively. 
*```data_table.csv``` a table containing network summary statistics. To add nestedness values to ```"data_table.csv"``` run ```nodfc.R``` which calculates nestedness with the maxnodf R package.
