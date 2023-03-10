function [spc, gen, spc_part, gen_part, spc_part_part, gen_part_part] = plant_motif_find(plant_index, network)

    spc = 0;
    gen = 0;
    spc_part = 0;
    gen_part = 0; 
    spc_part_part = 0;
    gen_part_part = 0;
    
    %find original pol partners of plant
    pol_partner_indices = find(network(plant_index,:));

    %are they generalist or specialist?
    if length(pol_partner_indices) == 1
        spc = 1;
    else
        gen = 1;
    end

    %iterate through pol partners
    for pol_part = 1:length(pol_partner_indices)
        pol_part_index = pol_partner_indices(pol_part);

        %find plant partners of each pol partner
        plant_partner_indices = find(network(:, pol_part_index));

        %are they generalist or specialist?
        if length(plant_partner_indices) == 1
            spc_part = 1;
        else
            gen_part = 1;
        end

        %exclude the focal plant
        plant_partner_indices = plant_partner_indices(plant_partner_indices ~= plant_index);

        %iterate through indirect plant partners
        for plant_part = 1:length(plant_partner_indices)
            plant_part_index = plant_partner_indices(plant_part);

            %find pol partners of each indirect plant partner
            part_pol_partner_indices = find(network(plant_part_index,:));

            %are they generalist or specialist?
            if length(part_pol_partner_indices) == 1
                spc_part_part = 1;
            else
                gen_part_part = 1;
            end
        end
    end
end