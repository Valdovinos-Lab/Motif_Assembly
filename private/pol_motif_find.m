function [spc, gen, spc_part, gen_part, spc_part_part, gen_part_part] = pol_motif_find(pol_index, network)
    
    spc = 0;
    gen = 0;
    spc_part = 0;
    gen_part = 0; 
    spc_part_part = 0;
    gen_part_part = 0;

    %find original plant partners of the pol
    plant_partner_indices = find(network(:, pol_index));

    %are they generalist or specialist?
    if length(plant_partner_indices) == 1
        spc = 1;
    else
        gen = 1;
    end

    %iterate through plant partners
    for plant_part = 1:length(plant_partner_indices)
        plant_part_index = plant_partner_indices(plant_part);

        %find pol partners of each plant partner
        pol_partner_indices = find(network(plant_part_index, :));

        %are they generalist or specialist?
        if length(pol_partner_indices) == 1
            spc_part = 1;
        else
            gen_part = 1;
        end

        %exclude the focal pol
        pol_partner_indices = pol_partner_indices(pol_partner_indices ~= pol_index);

        %iterate through indirect pol partners
        for pol_part = 1:length(pol_partner_indices)
            pol_part_index = pol_partner_indices(pol_part);

            %find plant partners of each indirect pol partner
            part_plant_partner_indices = find(network(:, pol_part_index));

            %are they generalist or specialist?
            if length(part_plant_partner_indices) == 1
                spc_part_part = 1;
            else
                gen_part_part = 1;
            end
        end       
    end
end
