function [] = run_assembly_AF0(date, dir_name)

    import plantpollinator.distributions.PollinatorDistributions;
    import plantpollinator.distributions.PlantDistributions;
    import plantpollinator.strategy.redistribution.RedistributeUniformly;
    import plantpollinator.Parameters;
    import plantpollinator.run;

    % Create a directory for storing this simulation in.
    output = sprintf('results/%s/%s', date, dir_name);
    mkdir(output);
    params_vector = [];

    for spc_plant_prob = 0:0.1:1
        for spc_pol_prob = 0:0.1:1

            % Define parameters for the simulation
            output_dir = sprintf('%s/output_p%.1f_a%.1f', output, spc_plant_prob, spc_pol_prob);
            inv_pol_dist = PollinatorDistributions('Mean_a', 0.001, 'Variance_tau', 0.5, 'Mean_G', 0);
            inv_plant_dist = PlantDistributions('Mean_p', 0.02, 'Mean_u', 0.02, 'Mean_w', 0.04, 'Mean_beta', 0.8, 'Mean_epsilon', 4, 'Variance_u', 1, 'Variance_w', 0, 'Variance_beta', 1, 'Variance_epsilon', 1);

            params = Parameters(output_dir, ...
                        'TimeStep', 2000, ...
                        'EndTime', 100000, ...
                        'SpcPlantProb', spc_plant_prob, ...
                        'SpcPolProb', spc_pol_prob, ...
                        'InvPlantProb', 1, ...
                        'InvPolProb', 1, ...
                        'InvPolDists', inv_pol_dist, ...
                        'InvPlantDists', inv_plant_dist, ...
                        'NumPlantsPerTimeStep', 3, ...
                        'NumPolsPerTimeStep',  3, ...
                        'RedistStrat', RedistributeUniformly);

            params_vector = [params_vector, params];
        end
    end

    % run simulation
    run(params_vector);

    % Get data from simulation
    plant_part_degree_2nd_3rd(params_vector, output);
    pol_part_degree_2nd_3rd(params_vector, output);
    complete_network_data(params_vector, output);
    
end
