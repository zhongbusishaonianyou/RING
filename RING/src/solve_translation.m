function [dx,dy,max_corr] = solve_translation(BEV_Q, BEV_M)
    % 输入参数:
    % a, b: 二维灰度图像矩阵 [height, width]
    % zero_mean_normalize: 是否进行零均值归一化 (默认为 true)
    % 输出:
    % dist: 归一化距离度量 (标量)
    % angle: 角度偏移 (标量，单位：度)

  BEV_Q = (BEV_Q - mean(BEV_Q(:))) / std(BEV_Q(:));
  BEV_M = (BEV_M - mean(BEV_M(:))) / std(BEV_M(:));

    %% 2. 频域互相关计算
    % 二维傅里叶变换
   BEV_Q_fft=fft2(BEV_Q);
   BEV_M_fft=fft2(BEV_M);
    % 复数共轭乘法
   corr_fft = BEV_Q_fft .* conj(BEV_M_fft);
  
    % 逆傅里叶变换
    corr = ifft2(corr_fft)/120;
  
    %% 3. 幅度计算
    corr_amp = abs(corr);  % 计算复数幅度

    %% 4. 频谱移位
    corr_shifted = fftshift(corr_amp);  
    %% 5. 峰值检测
    % 找到最大相关值的位置
    [max_val, max_idx] = max(corr_shifted(:));
    [row_max, col_max] = ind2sub(size(corr_shifted), max_idx);
    
    % 计算中心坐标
    [height, width] = size(corr_shifted);
    center_row= floor(height/2) + 1;
    center_col= floor(width/2) + 1;
    %% 6. 角度计算
    % 计算水平偏移量
    dy = center_col-col_max;
    dx = center_row-row_max;
    max_corr=-max_val;
end