function [TI_RING_FFT] = FFT(TI_RING) 

  TI_RING_FFT=zeros(120,120);
  
  TI_RING = (TI_RING - mean(TI_RING(:))) / std(TI_RING(:));

    %% 2. 频域互相关计算
    % 二维傅里叶变换
    for i=1:120
    TI_RING_FFT(i,:) = fft(TI_RING(i,:));
    end
end