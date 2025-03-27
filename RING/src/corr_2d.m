function [dist, angle] = corr_2d(TI_RING_Q, TI_RING_M)

  Q_FFT=zeros(120,120);
  M_FFT=zeros(120,120);
  
  TI_RING_Q = (TI_RING_Q - mean(TI_RING_Q(:))) / std(TI_RING_Q(:));
  TI_RING_M = (TI_RING_M - mean(TI_RING_M(:))) / std(TI_RING_M(:));
    
  %% 2. 频域互相关计算
    % 二维傅里叶变换
    for i=1:120
    Q_FFT(i,:) = fft(TI_RING_Q(i,:));
    M_FFT(i,:) = fft(TI_RING_M(i,:));
    end

    % 复数共轭乘法
    corr_fft = Q_FFT .* conj(M_FFT);
    
    % 逆傅里叶变换
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