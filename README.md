# Paper: One RING to Rule Them All: Radon Sinogram forPlace Recognition, Orientation and Translation Estimation (IEEE IROS 2022).
- Version plus:RING++: Roto-Translation-Invariant Gram for Global Localization on a Sparse Scan Map](https://ieeexplore.ieee.org/document/10224330) (IEEE T-RO 2023).
- Description: we implemented matlab version of RING according to python version of RING.Due to the differences in calling library functions and implementation methods, the experimental results are slightly different from those in the paper.There may be some errors in our implementation.
- Python version: https://github.com/lus6-Jenny/RING.
# PR curve evaluation
## - KITTI dataset results

## - NCLT dataset results

## - MULRAN dataset results

## Personal summary
- Advantages:
  - RING mainly decomposes translation and rotation through Radon transform, so that the two changes can be analyzed and estimated separately. Experiments show that RING has more advantages for revisits with larger translation changes.This is the best method we know of for place recognition performance at 20-50m place density.
  - RING can output three-degree-of-freedom pose, which is beneficial for subsequent ICP-based pose estimation.In fact, we found that even if the place recognition method recognizes a loop frame with a large lateral translation, ICP will estimate the wrong pose, which is not conducive to the global positioning of SLAM. Therefore, it is very important for the place recognition method to output a relatively accurate initial pose value for loop detection or relocalization.
  - We have not yet conducted experimental analysis on the 6-channel RING++ for extracting local features. Judging from the experimental results of the paper, RING++ has a slightly improved place recognition capability than RING.
- disadvantages:
  - The implementation of the RING method is very similar to that of LiDAR Iris. Both RING and LiDAR Iris do not use a more efficient data search structure when searching for the best matching frame, and their real-time performance is poor. Both methods may find it difficult to ensure real-time performance on longer sequences. RING can increase the sampling interval to reduce the time load.
  - Experiments show that RING has poor recognition of reverse revisit events. Although the estimation accuracy of yaw is increased by angle_extra in the rotation estimation part, it is ineffective in improving the place recognition ability of the method.
  - The similarity matching score has a small range, basically around 0.4. When this method is integrated into the SLAM system for loop detection, the loop threshold may need to be carefully adjusted.
