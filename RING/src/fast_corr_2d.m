function [dist, angle] = fast_corr_2d(Q_FFT, M_FFT)

    % 复数共轭乘法
    corr_fft = Q_FFT .* conj(M_FFT);
    
    % 逆傅里叶变换
    corr=zeros(120,120);
     for i=1:120
    corr(i,:) = ifft(corr_fft(i,:))/sqrt(120);
     end
    %% 3. 幅度计算
    corr_amp = abs(corr);  % 计算复数幅度
    corr_amp=sum(corr_amp,1);

    %% 4. 频谱移位 (沿宽度方向)
    corr_shifted = fftshift(corr_amp);  % 仅水平方向移位
    %% 5. 峰值检测
    % 找到最大相关值的位置
    [max_val, max_idx] = max(corr_shifted(:));
    [~, col_max] = ind2sub(size(corr_shifted), max_idx);
    
    % 计算中心坐标
    [~, width] = size(corr_shifted);
    center_col= floor(width/2) + 1;

    %% 6. 角度计算
    % 计算水平偏移量
    dy = center_col-col_max;
    
    % 计算角度 (基于圆周位置)
    angle = dy; 
    
    %% 7. 距离计算
    % 归一化因子 (假设与原文的0.15系数匹配)
    normalization_factor = 0.15 *  numel(Q_FFT); % numel(a) = height*width
    dist = 1 - (max_val / normalization_factor);
end