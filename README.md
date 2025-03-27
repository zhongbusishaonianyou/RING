# Paper: One RING to Rule Them All: Radon Sinogram forPlace Recognition, Orientation and Translation Estimation (IEEE IROS 2022).
- Version plus:RING++: Roto-Translation-Invariant Gram for Global Localization on a Sparse Scan Map](https://ieeexplore.ieee.org/document/10224330) (IEEE T-RO 2023).
- Description: we implemented matlab version of RING according to python version of RING.Due to the differences in calling library functions and implementation methods, the experimental results are slightly different from those in the paper.There may be some errors in our implementation.
- Python version: https://github.com/lus6-Jenny/RING.
 ![image](https://github.com/user-attachments/assets/cecda81d-770a-435c-a493-84d88d729888)

- # Usage
 ```
- change file path
- run main_kitti/mulran/nclt.m
- run prcurve_drawer.m to draw pr curve
 ```
- Note:The Python version of RING uses GPU acceleration, and MATLAB runs this method slowly.The RING pose estimation method is implemented in demo.m.
# PR curve evaluation
## - KITTI dataset results
|                           |                                      |
|---------------------------|--------------------------------------|
|![02_path](https://github.com/user-attachments/assets/023d48f8-eb10-4a6c-bd0c-f6713f9bbe0d) |![KITTI_02 (2)](https://github.com/user-attachments/assets/71a75ae5-47b1-4bc0-b30a-90d711d169e7)|
|![05_path](https://github.com/user-attachments/assets/3da527ea-51b3-4d2f-992a-aa0e598cd29b)|![KITTI_05](https://github.com/user-attachments/assets/95ab0651-720b-43b8-be7f-e0350244d1f9)|
|![KITTI_08 (2)](https://github.com/user-attachments/assets/2b507dd9-f8e8-4b82-a176-7995197649cf)|![KITTI_08](https://github.com/user-attachments/assets/2843f6d7-0718-46bd-8cd2-4491295cd1c6)|
## - NCLT dataset results
 - place density 2m
   
|                           |                                      |
|---------------------------|--------------------------------------|
|![nclt](https://github.com/user-attachments/assets/9ab45ceb-e6bc-44cd-85a2-22960266ab4a)|![777](https://github.com/user-attachments/assets/a4363b91-192c-4987-9ab6-f8a6470bbb11)|
|![nclt_02](https://github.com/user-attachments/assets/6006d148-960f-40d7-957f-c2bf8ca05f94)|![nclftrr](https://github.com/user-attachments/assets/ccbcec7b-12af-4e94-82f0-e91926e99f89)|
## - MULRAN dataset results
 - place density 1m

|                           |                                      |
|---------------------------|--------------------------------------|
|![DCC02](https://github.com/user-attachments/assets/e6e05fe7-1e7f-4390-bb0c-e544ba9d2833)|![DCC02 (2)](https://github.com/user-attachments/assets/cf96be40-720b-4bb4-afc5-46aa1f1e2824)|
## Personal summary
- Advantages:
  - RING mainly decomposes translation and rotation through Radon transform, so that the two changes can be analyzed and estimated separately. Experiments show that RING has more advantages for revisits with larger translation changes.This is the best method we know of for place recognition performance at 20-50m place density.
  - RING can output three-degree-of-freedom pose, which is beneficial for subsequent ICP-based pose estimation.In fact, we found that even if the place recognition method recognizes a loop frame with a large lateral translation, ICP will estimate the wrong pose, which is not conducive to the global positioning of SLAM. Therefore, it is very important for the place recognition method to output a relatively accurate initial pose value for loop detection or relocalization.
  - We have not yet conducted experimental analysis on the 6-channel RING++ for extracting local features. Judging from the experimental results of the paper, RING++ has a slightly improved place recognition capability than RING.
- disadvantages:
  - The implementation of the RING method is very similar to that of LiDAR Iris. Both RING and LiDAR Iris do not use a more efficient data search structure when searching for the best matching frame, and their real-time performance is poor. Both methods may find it difficult to ensure real-time performance on longer sequences. RING can increase the sampling interval to reduce the time load.
  - Experiments show that RING has poor recognition of reverse revisit events. Although the estimation accuracy of yaw is increased by angle_extra in the rotation estimation part, it is ineffective in improving the place recognition ability of the method.
  - The similarity matching score has a small range, basically around 0.4. When this method is integrated into the SLAM system for loop detection, the loop threshold may need to be carefully adjusted.
# cite
```
@INPROCEEDINGS{9981308,
  author={Lu, Sha and Xu, Xuecheng and Yin, Huan and Chen, Zexi and Xiong, Rong and Wang, Yue},
  booktitle={2022 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)}, 
  title={One RING to Rule Them All: Radon Sinogram for Place Recognition, Orientation and Translation Estimation}, 
  year={2022},
  pages={2778-2785},
  keywords={Location awareness;Measurement;Databases;Pose estimation;Radon;Robustness;Mobile robots},
  doi={10.1109/IROS47612.2022.9981308}};

  @INPROCEEDINGS{8593953,
  author={Kim, Giseop and Kim, Ayoung},
  booktitle={2018 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)}, 
  title={Scan Context: Egocentric Spatial Descriptor for Place Recognition Within 3D Point Cloud Map}, 
  year={2018},
  pages={4802-4809},
  keywords={Three-dimensional displays;Sensors;Laser radar;Histograms;Shape;Visualization;Encoding},
  doi={10.1109/IROS.2018.8593953}}
```
