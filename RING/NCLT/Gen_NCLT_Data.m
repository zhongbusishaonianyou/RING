function   [BEV,GT_poses]=Gen_NCLT_Data(ScanBaseDir,SequenceDate,dim,range)

% sampling gap 
SamplingGap = 2; % in meter 

ScanDir = strcat(ScanBaseDir, SequenceDate, '/velodyne_sync/');
Scans = dir(ScanDir); Scans(1:2, :) = []; Scans = {Scans(:).name};
ScanTimes = getNCLTscanInformation(Scans);

%% Preparation 3: load GT pose (for calc moving diff and location)
GroundTruthPosePath = strcat(ScanBaseDir, SequenceDate, '/groundtruth_', SequenceDate, '.csv');
GroundTruthPoseData = csvread(GroundTruthPosePath);

GroundTruthPoseTime = GroundTruthPoseData(:, 1);
GroundTruthPoseXYZ = GroundTruthPoseData(:, 2:4);

nGroundTruthPoses = length(GroundTruthPoseData);

%% Main: Sampling 
GT_poses=[];
voxel_size=[2*range(1)/dim(1),2*range(2)/dim(2)];
MoveCounter = 0; 
curSamplingCounter=0;
for ii = 1000:nGroundTruthPoses % just quite large number 1000 for avoiding first several NaNs 
    curTime = GroundTruthPoseTime(ii, 1);

    prvPose = GroundTruthPoseXYZ(ii-1, :);
    curPose = GroundTruthPoseXYZ(ii, :);
    
    curMove = norm(curPose - prvPose);
    MoveCounter = MoveCounter + curMove;
    
    if(MoveCounter >= SamplingGap)
        curSamplingCounter = curSamplingCounter + 1; 
        % load current point cloud 
        curPtcloud = getNearestPtcloud( ScanTimes, curTime, Scans, ScanDir);
  
        %% Save data
        curr_bev= ptcloud2cartcontext(curPtcloud,voxel_size,range);
        BEV{curSamplingCounter}=curr_bev;
        GT_poses=[GT_poses;curPose];
        % End: Reset counter 
        MoveCounter = 0;
                
        % Tracking progress message  
        if(rem(curSamplingCounter, 100) == 0)
           message = strcat(num2str(curSamplingCounter), "th sample is saved." );
           disp(message)
        end     
    end 
end

end





