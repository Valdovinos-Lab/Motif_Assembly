function [] = complete_network_data(params_vector, output)   
    
    % Generate statistics for every run of the simulation
    num_timesteps = params_vector(1).EndTime / params_vector(1).TimeStep - 2;
    num_simulations = length(params_vector);
    data_table = zeros(num_timesteps * num_simulations, 29);
    for i = 1 : num_simulations
        [table] = network_data(params_vector(i));
        data_table((i - 1) * num_timesteps + 1:(i - 1) * num_timesteps + num_timesteps, :) = table;
    end

    % Add column headers to the csv
    data_table = array2table(data_table, 'VariableNames', { ...
        'ColonizationFrequency', ...
        'EndTime', ...
        'InvasivePlantProbability', ...
        'InvasivePollinatorProbability', ...
        'SpecialistPlantProbability', ...
        'SpecialistPollinatorProbability', ...
        'NPlantsPerTimeStep', ...
        'NPollinatorsPerTimeStep', ...
        'PlantExtenctionThreshold', ...
        'PollinatorExtinctionThreshold', ...
        'TimeStep', ...
        'NumPlants', ...
        'NumPols', ...
        'NetworkSize', ...
        'Connectence', ...
        'TotalPlantDensity', ...
        'TotalPolDensity' ...
      });


    % write data table
    writetable(data_table, sprintf('%s/data_table.csv', output));

    % clear all produced figures
    close all;
end