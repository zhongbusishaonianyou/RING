function [BEV, GTposes] = Load_NCLT_Data(Sequence_date,dim,range)
%%
global data_path;
data_save_path = fullfile('./data/'); 
%%
if ~exist(data_save_path,'dir')
    % make 
    [BEV, GTposes] = Gen_NCLT_Data(data_path,Sequence_date,dim,range);    
    mkdir(data_save_path);

    BEV_file = strcat(data_save_path, 'BEV', '.mat');
    save(BEV_file, 'BEV');

    GTpose_file = strcat(data_save_path, 'GTposes', '.mat');
    save(GTpose_file, 'GTposes');

else
    BEV_file = strcat(data_save_path, 'BEV',  '.mat');
    load(BEV_file);
    
    GTpose_file = strcat(data_save_path, 'GTposes', '.mat');
    load(GTpose_file);
    
    disp('- successfully loaded.');
end
end

