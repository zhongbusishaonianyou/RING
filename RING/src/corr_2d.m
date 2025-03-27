function [dist, angle] = corr_2d(TI_RING_Q, TI_RING_M)

  Q_FFT=zeros(120,120);
  M_FFT=zeros(120,120);
  
  TI_RING_Q = (TI_RING_Q - mean(TI_RING_Q(:))) / std(TI_RING_Q(:));
  TI_RING_M = (TI_RING_M - mean(TI_RING_M(:))) / std(TI_RING_M(:));
    
  %% 2. Ƶ����ؼ���
    % ��ά����Ҷ�任
    for i=1:120
    Q_FFT(i,:) = fft(TI_RING_Q(i,:));
    M_FFT(i,:) = fft(TI_RING_M(i,:));
    end

    % ��������˷�
    corr_fft = Q_FFT .* conj(M_FFT);
    
    % �渵��Ҷ�任
     for i=1:120
    corr(i,:) = ifft(corr_fft(i,:))/sqrt(120);
     end
    %% 3. ���ȼ���
    corr_amp = abs(corr);  % ���㸴������
    corr_amp=sum(corr_amp,1);

    %% 4. Ƶ����λ (�ؿ�ȷ���)
    corr_shifted = fftshift(corr_amp);  % ��ˮƽ������λ
    %% 5. ��ֵ���
    % �ҵ�������ֵ��λ��
    [max_val, max_idx] = max(corr_shifted(:));
    [~, col_max] = ind2sub(size(corr_shifted), max_idx);
    
    % ������������
    [~, width] = size(corr_shifted);
    center_col= floor(width/2) + 1;

    %% 6. �Ƕȼ���
    % ����ˮƽƫ����
    dy = center_col-col_max;
    
    % ����Ƕ� (����Բ��λ��)
    angle = dy; 
    
    %% 7. �������
    % ��һ������ (������ԭ�ĵ�0.15ϵ��ƥ��)
    normalization_factor = 0.15 *  numel(Q_FFT); % numel(a) = height*width
    dist = 1 - (max_val / normalization_factor);
end