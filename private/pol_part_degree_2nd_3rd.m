function [] = pol_part_degree_2nd_3rd(params_vector, output)

    
    for p = 1:length(params_vector)
        params = params_vector(p);

        %read in plant lifespan data for this simulation
        pol_data = readtable(sprintf('%s/lifespans/pollinators.csv', params.OutputDirectoryPath));
        [num_pols, num_cols] = size(pol_data);

        %create empty rows to add to lifespan data
        index = zeros([1, num_pols]);
        spc = zeros([1, num_pols]);
        gen = zeros([1, num_pols]);
        spc_part = zeros([1, num_pols]);
        gen_part = zeros([1, num_pols]);
        spc_part_part = zeros([1, num_pols]);
        gen_part_part = zeros([1, num_pols]);
        index_2000 = zeros([1, num_pols]);
        spc_2000 = zeros([1, num_pols]);
        gen_2000 = zeros([1, num_pols]);
        spc_part_2000 = zeros([1, num_pols]);
        gen_part_2000 = zeros([1, num_pols]);
        spc_part_part_2000 = zeros([1, num_pols]);
        gen_part_part_2000 = zeros([1, num_pols]);
        index_4000 = zeros([1, num_pols]);
        spc_4000 = zeros([1, num_pols]);
        gen_4000 = zeros([1, num_pols]);
        spc_part_4000 = zeros([1, num_pols]);
        gen_part_4000 = zeros([1, num_pols]);
        spc_part_part_4000 = zeros([1, num_pols]);
        gen_part_part_4000 = zeros([1, num_pols]);

        %skip initial 3 plants in the network
        for pol_id = 4:(num_pols-3)

            %find network in which plant was recorded (2000 timesteps after added) and plant index
            snap = pol_data.added(pol_id)+2000;
            snapshot = load(sprintf('%s/modelled/snapshots/snapshot-%d.mat', params.OutputDirectoryPath, snap));
            pol_ids = snapshot.VA.PollinatorId;
            index(pol_id) = find(pol_ids == pol_id);
            network = full(snapshot.A) > 0; 
            [spc(pol_id), gen(pol_id), spc_part(pol_id), gen_part(pol_id), spc_part_part(pol_id), gen_part_part(pol_id)] = pol_motif_find(index(pol_id), network);

            %only calculate for plants that establish
            if (snap + 2000) < pol_data.removed(pol_id)

                %find motifs at the end of 2000 timesteps when some species
                %have become extinct
                pol_ids_2000 = pol_ids;
                pol_ids_2000(find(snapshot.VA.Extinct == 1)) = [];
                index_2000(pol_id) = find(pol_ids_2000 == pol_id);
                network_2000 = network;
                network_2000(:,find(snapshot.VA.Extinct == 1)) = [];
                network_2000(find(snapshot.VP.Extinct == 1),:) = [];
                [spc_2000(pol_id), gen_2000(pol_id), spc_part_2000(pol_id), gen_part_2000(pol_id), spc_part_part_2000(pol_id), gen_part_part_2000(pol_id)] = pol_motif_find(index_2000(pol_id), network_2000);
                
    
                %find motifs at the end of 2000 timesteps when some species
                %have become extinct
                snap = pol_data.added(pol_id)+4000;
                snapshot = load(sprintf('%s/modelled/snapshots/snapshot-%d.mat', params.OutputDirectoryPath, snap));
                pol_ids_4000 = snapshot.VA.PollinatorId;
                pol_ids_4000(find(snapshot.VA.Extinct == 1)) = [];
                index_4000(pol_id) = find(pol_ids_4000 == pol_id);
                network_4000 = full(snapshot.A) > 0;
                network_4000(:,find(snapshot.VA.Extinct == 1)) = [];
                network_4000(find(snapshot.VP.Extinct == 1),:) = [];
                [spc_4000(pol_id), gen_4000(pol_id), spc_part_4000(pol_id), gen_part_4000(pol_id), spc_part_part_4000(pol_id), gen_part_part_4000(pol_id)] = pol_motif_find(index_4000(pol_id), network_4000);
            end
        end

        %add rows to lifespan data
        pol_data.Index = index';
        pol_data.Spc = spc';
        pol_data.Gen = gen';
        pol_data.SpcPart = spc_part';
        pol_data.GenPart = gen_part';
        pol_data.SpcPartPart = spc_part_part';
        pol_data.GenPartPart = gen_part_part';
        pol_data.Index2000 = index_2000';
        pol_data.Spc2000 = spc_2000';
        pol_data.Gen2000 = gen_2000';
        pol_data.SpcPart2000 = spc_part_2000';
        pol_data.GenPart2000 = gen_part_2000';
        pol_data.SpcPartPart2000 = spc_part_part_2000';
        pol_data.GenPartPart2000 = gen_part_part_2000';
        pol_data.Index4000 = index_4000';
        pol_data.Spc4000 = spc_4000';
        pol_data.Gen4000 = gen_4000';
        pol_data.SpcPart4000 = spc_part_4000';
        pol_data.GenPart4000 = gen_part_4000';
        pol_data.SpcPartPart4000 = spc_part_part_4000';
        pol_data.GenPartPart4000 = gen_part_part_4000';
        writetable(pol_data, sprintf('%s/motifs/pollinators_p%.1f_a%.1f.csv', output, params.SpcPlantProb, params.SpcPolProb));
    end 
end
