function [BEV, GTposes] = Gen_MulRan_Data(BaseDir,SequenceName,dim,range)
%  directory structure 
% - riverside02
%   - global_pose.csv (gtpose)
%   - sensor_data
%      - outster
%        - <1564718056109702329.bin>
%        - <1564718056809740958.bin>
%      - other files 
ScanBaseDir=strcat(BaseDir,SequenceName);
ScanDir = strcat(ScanBaseDir,  'sensor_data', '/Ouster/');
Scans = dir(ScanDir); Scans(1:2, :) = []; Scans = {Scans(:).name};
ScanTimes = get_scan_Information(Scans);
%%  load GT poses 
GroundTruthPosePath = strcat(ScanBaseDir, '/global_pose', '.csv');
GroundTruthPoseData = csvread(GroundTruthPosePath);
%% Start position turns to zero
GroundTruthPoseTime = GroundTruthPoseData(:, 1);
GroundTruthPoseXYZ = [GroundTruthPoseData(:, 5)-GroundTruthPoseData(1,5),GroundTruthPoseData(:,9)-GroundTruthPoseData(1,9),GroundTruthPoseData(:,13)-GroundTruthPoseData(1,13)];
%% Look for the latest timestamp with the current frame
nScanTimes = length(ScanTimes);
poses=zeros(nScanTimes,3);
for index =1:nScanTimes 
     curScanTime = ScanTimes(index, 1);
    [~, ArgminIdx] = min(abs(GroundTruthPoseTime-curScanTime));
      curgtpose = GroundTruthPoseXYZ(ArgminIdx,:);
      poses(index,:)=curgtpose;
end
GroundTruthPoseXYZ=poses(1:end,:);
%% Sampling
voxel_size=[2*range(1)/dim(1),2*range(2)/dim(2)];
MoveCounter = 0; 
curSamplingCounter=0;
SamplingGap=1;
GTposes=[];
for index = 2:nScanTimes 

    prePose = GroundTruthPoseXYZ(index-1, :);
    curPose = GroundTruthPoseXYZ(index, :);
    
    curMove = norm(curPose - prePose);
    MoveCounter = MoveCounter + curMove;
    
    if(MoveCounter >= SamplingGap)
        curSamplingCounter = curSamplingCounter + 1; 
        % load current point cloud 
         BinName = Scans{index}; BinPath = strcat(ScanDir,BinName);
         curPtcloud = Bin2Ptcloud(BinPath);
        %% Save data
        curr_bev= ptcloud2cartcontext(curPtcloud,voxel_size,range);
        BEV{curSamplingCounter}=curr_bev;
        GTposes=[GTposes;curPose];
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





