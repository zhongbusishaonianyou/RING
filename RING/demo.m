clear; clc;
addpath(genpath('src'));
%% param setting
range=[70,70];
num_rings=120;
num_sectors=120;
%% Read
data_name1='./kitti_08/03870.bin';
data_name2='./kitti_08/02526.bin';
ptcloud1=Read_Bin(data_name1);
ptcloud2=Read_Bin(data_name2);
%% TI_RING
query_bev=ptcloud2cartcontext(ptcloud1,[2*range(1)/num_rings,2*range(2)/num_sectors],range);
RING_Q=custom_radon(query_bev);
TI_RING_Q=abs(fft(RING_Q))/sqrt(num_rings);

map_bev=ptcloud2cartcontext(ptcloud2,[2*range(1)/num_rings,2*range(2)/num_sectors],range);
map_RING=custom_radon(map_bev);
TI_RING_M=abs(fft(map_RING))/sqrt(num_rings);
%% translation and rotation
[dis,angle_matched]=corr_2d(TI_RING_Q,TI_RING_M);
ang_res = 2 * pi /num_rings;
angle_matched_extra = angle_matched - num_rings / 2;
              
angle_matched_rad = angle_matched * ang_res ;
angle_matched_extra_rad = angle_matched_extra * ang_res ;
 
[bev_rotated,bev_rotated_extra] = rotate_bev(query_bev, angle_matched);
[ x, y, error] = solve_translation(bev_rotated,map_bev);
[ x_extra, y_extra, error_extra] =solve_translation(bev_rotated_extra,map_bev);
  
if (error < error_extra)
       trans_x = x / num_sectors *2*range(1);
       trans_y = y / num_rings * 2*range(1);
        rot_yaw = angle_matched_rad ; 
    else
        trans_x = x_extra / num_sectors *2*range(1) ;
        trans_y = y_extra / num_rings * 2*range(1); 
        rot_yaw = angle_matched_extra_rad  ;
 end
   
%% visualize RING
theta=linspace(0,360,120);  
[RING,xp]=radon(query_bev,theta,120);
imshow(RING',[],'Xdata',xp,'Ydata',theta,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x')
colormap(gca,jet), colorbar



