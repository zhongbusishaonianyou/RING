function [dx,dy,max_corr] = solve_translation(BEV_Q, BEV_M)
    % �������:
    % a, b: ��ά�Ҷ�ͼ����� [height, width]
    % zero_mean_normalize: �Ƿ�������ֵ��һ�� (Ĭ��Ϊ true)
    % ���:
    % dist: ��һ��������� (����)
    % angle: �Ƕ�ƫ�� (��������λ����)

  BEV_Q = (BEV_Q - mean(BEV_Q(:))) / std(BEV_Q(:));
  BEV_M = (BEV_M - mean(BEV_M(:))) / std(BEV_M(:));

    %% 2. Ƶ����ؼ���
    % ��ά����Ҷ�任
   BEV_Q_fft=fft2(BEV_Q);
   BEV_M_fft=fft2(BEV_M);
    % ��������˷�
   corr_fft = BEV_Q_fft .* conj(BEV_M_fft);
  
    % �渵��Ҷ�任
    corr = ifft2(corr_fft)/120;
  
    %% 3. ���ȼ���
    corr_amp = abs(corr);  % ���㸴������

    %% 4. Ƶ����λ
    corr_shifted = fftshift(corr_amp);  
    %% 5. ��ֵ���
    % �ҵ�������ֵ��λ��
    [max_val, max_idx] = max(corr_shifted(:));
    [row_max, col_max] = ind2sub(size(corr_shifted), max_idx);
    
    % ������������
    [height, width] = size(corr_shifted);
    center_row= floor(height/2) + 1;
    center_col= floor(width/2) + 1;
    %% 6. �Ƕȼ���
    % ����ˮƽƫ����
    dy = center_col-col_max;
    dx = center_row-row_max;
    max_corr=-max_val;
end