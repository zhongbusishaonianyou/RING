function [TI_RING_FFT] = FFT(TI_RING) 

  TI_RING_FFT=zeros(120,120);
  
  TI_RING = (TI_RING - mean(TI_RING(:))) / std(TI_RING(:));

    %% 2. Ƶ����ؼ���
    % ��ά����Ҷ�任
    for i=1:120
    TI_RING_FFT(i,:) = fft(TI_RING(i,:));
    end
end