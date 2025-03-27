clear; clc;
addpath(genpath('src'));
addpath(genpath('NCLT'));
global data_path; 
%  directory structure 
% - 2012-05-26
%   - groundtruth_2012-05-26.csv 
%   - velodyne_sync
%      - <1338074715117444.bin>
%      - <1338074715117444.bin>
%% data path setting
data_path = 'E:\dataset/NCLT/';
SequenceDate = '2012-08-20'; 
%% loading ground-truth poses and creating RING
resolution = [120,120];Range=[70,70]; 
[BEV, GT_poses] = Load_NCLT_Data(SequenceDate,resolution,Range);

%% loop parameter setting
 revisit_thres = 10; % 
 num_node_enough_apart = 50;
%% parameter setting
num_queries = length(GT_poses);
TI_RING_FFT=cell(1,num_queries);
results=zeros(num_queries-num_node_enough_apart,2);
is_revisit=zeros(num_queries-num_node_enough_apart,1);

 for index=1:num_queries
      curr_bev = BEV{index};
      curr_ring=custom_radon(curr_bev);
      curr_TI_RING=abs(fft(curr_ring))/sqrt(120);
      TI_RING_FFT{index}=FFT(curr_TI_RING);
 end
 %% search the best similar frame by our method
 disp('-----------------------------------------------------');
 disp('Place recognition task begins');
 for query_idx = 1:num_queries     
    query_pose = GT_poses(query_idx,:);
    query_TI_RING=TI_RING_FFT{query_idx};
    min_dis=1;

    if( query_idx <= num_node_enough_apart )
       continue;
    end
        % judging revisitness by using ground-truth poses
       revisitness= Loop_truth(query_pose, GT_poses(1:query_idx-num_node_enough_apart, :), revisit_thres);
       is_revisit(query_idx-num_node_enough_apart,1)=revisitness;
           
    for ith_candidate = 1:query_idx-num_node_enough_apart
       [dis,angle_matched]=fast_corr_2d(query_TI_RING,TI_RING_FFT{ith_candidate});
        if dis<min_dis
           min_dis=dis;
           near_idx=ith_candidate;
        end
    end  
      results(query_idx-num_node_enough_apart,:)=[near_idx,min_dis]; 
      
      if( rem(query_idx, 100) == 0)
        disp( strcat(num2str(query_idx/num_queries * 100), ' % processed') );
      end
end
%% Entropy thresholds 
min_thres=min(results(:,2))+0.01;
max_thres=max(results(:,2))+0.01;
thresholds = linspace(min_thres, max_thres,100); 
num_thresholds = length(thresholds);

% Main variables to store the result for drawing PR curve 
num_hits=zeros(1, num_thresholds);
Precisions = zeros(1, num_thresholds); 
Recalls = zeros(1, num_thresholds); 
true_positive=sum(is_revisit);
%% prcurve analysis 
for thres_idx = 1:num_thresholds
  threshold = thresholds(thres_idx);
  predict_postive=0;num_hits=0;
    for frame_idx=1:length(is_revisit)
        min_dist=results(frame_idx,2);
        matching_idx=results(frame_idx,1);
        revisit=is_revisit(frame_idx,1); 
            if( min_dist <threshold)
                predict_postive=predict_postive+1;
                if(dist_btn_pose(GT_poses(frame_idx+num_node_enough_apart,:), GT_poses(matching_idx, :)) < revisit_thres)
                    %TP
                    num_hits= num_hits + 1;
                end     
            end
    end
  
    Precisions(1, thres_idx) = num_hits/predict_postive;
    Recalls(1, thres_idx)=num_hits/true_positive;
    
end
%% save the log 
savePath = strcat("pr_result/within ", num2str(revisit_thres), "m/");
if((~7==exist(savePath,'dir')))
    mkdir(savePath);
end
save(strcat(savePath, 'nPrecisions.mat'), 'Precisions');
save(strcat(savePath, 'nRecalls.mat'), 'Recalls');
%% visiualize GT path
figure(1);hold on;
plot(GT_poses(:,1), GT_poses(:,2),'LineWidth',2);
axis equal; grid on;
legend('Groud-Truth');

%%  save the loop information
data_save_path = fullfile('./data/'); 
filename = strcat(data_save_path, 'results', '.mat');
save(filename, 'results');


