function [] = plant_part_degree_2nd_3rd(params_vector, output)
    
    mkdir(sprintf('%s/motifs/', output));
    
    for p = 1:length(params_vector)
        params = params_vector(p);

        %read in plant lifespan data for this simulation
        plant_data = readtable(sprintf('%s/lifespans/plants.csv', params.OutputDirectoryPath));
        [num_plants, num_cols] = size(plant_data);

        %create empty rows to add to lifespan data
        index = zeros([1, num_plants]);
        spc = zeros([1, num_plants]);
        gen = zeros([1, num_plants]);
        spc_part = zeros([1, num_plants]);
        gen_part = zeros([1, num_plants]);
        spc_part_part = zeros([1, num_plants]);
        gen_part_part = zeros([1, num_plants]);
        index_2000 = zeros([1, num_plants]);
        spc_2000 = zeros([1, num_plants]);
        gen_2000 = zeros([1, num_plants]);
        spc_part_2000 = zeros([1, num_plants]);
        gen_part_2000 = zeros([1, num_plants]);
        spc_part_part_2000 = zeros([1, num_plants]);
        gen_part_part_2000 = zeros([1, num_plants]);
        index_4000 = zeros([1, num_plants]);
        spc_4000 = zeros([1, num_plants]);
        gen_4000 = zeros([1, num_plants]);
        spc_part_4000 = zeros([1, num_plants]);
        gen_part_4000 = zeros([1, num_plants]);
        spc_part_part_4000 = zeros([1, num_plants]);
        gen_part_part_4000 = zeros([1, num_plants]);

        %skip initial 3 plants in the network
        for plant_id = 4:(num_plants-3)

            %find network in which plant was recorded (2000 timesteps after added) and plant index
            snap = plant_data.added(plant_id)+2000;
            snapshot = load(sprintf('%s/modelled/snapshots/snapshot-%d.mat', params.OutputDirectoryPath, snap));
            plant_ids = snapshot.VP.PlantId;
            index(plant_id) = find(plant_ids == plant_id);
            network = full(snapshot.A) > 0; 
            [spc(plant_id), gen(plant_id), spc_part(plant_id), gen_part(plant_id), spc_part_part(plant_id), gen_part_part(plant_id)] = plant_motif_find(index(plant_id), network);

            %only calculate for plants that establish
            if (snap + 2000) < plant_data.removed(plant_id)

                %find motifs at the end of 2000 timesteps when some species
                %have become extinct
                plant_ids_2000 = plant_ids;
                plant_ids_2000(find(snapshot.VP.Extinct == 1)) = [];
                index_2000(plant_id) = find(plant_ids_2000 == plant_id);
                network_2000 = network;
                network_2000(:,find(snapshot.VA.Extinct == 1)) = [];
                network_2000(find(snapshot.VP.Extinct == 1),:) = [];
                [spc_2000(plant_id), gen_2000(plant_id), spc_part_2000(plant_id), gen_part_2000(plant_id), spc_part_part_2000(plant_id), gen_part_part_2000(plant_id)] = plant_motif_find(index_2000(plant_id), network_2000);
                
    
                %find motifs at the end of 2000 timesteps when some species
                %have become extinct
                snap = plant_data.added(plant_id)+4000;
                snapshot = load(sprintf('%s/modelled/snapshots/snapshot-%d.mat', params.OutputDirectoryPath, snap));
                plant_ids_4000 = snapshot.VP.PlantId;
                plant_ids_4000(find(snapshot.VP.Extinct == 1)) = [];
                index_4000(plant_id) = find(plant_ids_4000 == plant_id);
                network_4000 = full(snapshot.A) > 0;
                network_4000(:,find(snapshot.VA.Extinct == 1)) = [];
                network_4000(find(snapshot.VP.Extinct == 1),:) = [];
                [spc_4000(plant_id), gen_4000(plant_id), spc_part_4000(plant_id), gen_part_4000(plant_id), spc_part_part_4000(plant_id), gen_part_part_4000(plant_id)] = plant_motif_find(index_4000(plant_id), network_4000);
            end
        end

        %add rows to lifespan data
        plant_data.Index = index';
        plant_data.Spc = spc';
        plant_data.Gen = gen';
        plant_data.SpcPart = spc_part';
        plant_data.GenPart = gen_part';
        plant_data.SpcPartPart = spc_part_part';
        plant_data.GenPartPart = gen_part_part';
        plant_data.Index2000 = index_2000';
        plant_data.Spc2000 = spc_2000';
        plant_data.Gen2000 = gen_2000';
        plant_data.SpcPart2000 = spc_part_2000';
        plant_data.GenPart2000 = gen_part_2000';
        plant_data.SpcPartPart2000 = spc_part_part_2000';
        plant_data.GenPartPart2000 = gen_part_part_2000';
        plant_data.Index4000 = index_4000';
        plant_data.Spc4000 = spc_4000';
        plant_data.Gen4000 = gen_4000';
        plant_data.SpcPart4000 = spc_part_4000';
        plant_data.GenPart4000 = gen_part_4000';
        plant_data.SpcPartPart4000 = spc_part_part_4000';
        plant_data.GenPartPart4000 = gen_part_part_4000';
        writetable(plant_data, sprintf('%s/motifs/plants_p%.1f_a%.1f.csv', output, params.SpcPlantProb, params.SpcPolProb));
    end 
end
