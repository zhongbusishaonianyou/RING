function [BEV, GTposes] = Load_KITTI_Data(GTpose_dir,dim,range)
%%
global data_path;
data_save_path = fullfile('./data/'); 
%%
if ~exist(data_save_path,'dir')
    % make 
    [BEV, GTposes] = Gen_KITTI_Data(data_path,GTpose_dir,dim,range);    
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

