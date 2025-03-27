function [BEV,gtpose_xy] = Gen_KITTI_Data(data_dir,pose_dir,dim ,range)
%%
lidar_data_dir = strcat(data_dir, 'velodyne/');
data_names = osdir(lidar_data_dir);
%% gps to xyz
gtpose = csvread(strcat(data_dir,pose_dir));
gtpose_xy = gtpose(:, [4,12]);
%%
num_data = length(data_names);
BEV = cell(1, num_data);
index=1;
voxel_size=[2*range(1)/dim(1),2*range(2)/dim(2)];
for data_idx = 1:num_data
      
    file_name = data_names{data_idx};
    data_path = strcat(lidar_data_dir, file_name);
    
    ptcloud = Read_Bin(data_path);
    current_bev= ptcloud2cartcontext(ptcloud,voxel_size,range); 
    
    % save 
    BEV{index} = current_bev;   
    index=index+1;
    % display processing
    if(rem(data_idx, 100) == 0)
        message = strcat(num2str(data_idx), " / ", num2str(num_data));
        disp(message); 
    end
end
end
