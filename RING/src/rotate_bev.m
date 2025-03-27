function [image_rotated,image_rotated_extra]= rotate_bev(image, angle_matched)
    
    ang_res = 2 * pi /120;
    angle_matched_extra = angle_matched - 120 / 2;
              
    angle_matched_rad = angle_matched * ang_res ;
    angle_matched_extra_rad = angle_matched_extra * ang_res ;

    % ������ת��Ϊ����
    angle_deg = angle_matched_rad * 180 / pi;
    % ʹ��˫���Բ�ֵ������ԭʼͼ��ߴ�
    image_rotated = imrotate(image, angle_deg, 'nearest', 'crop');
    
      % ������ת��Ϊ����
    angle_deg_extra = angle_matched_extra_rad * 180 / pi;
    % ʹ��˫���Բ�ֵ������ԭʼͼ��ߴ�
    image_rotated_extra = imrotate(image, angle_deg_extra, 'nearest', 'crop');
end