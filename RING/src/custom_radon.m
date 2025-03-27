function [RING] = custom_radon(image)
 theta=linspace(0,360,120);
% 生成网格坐标
[x, y] = meshgrid(1:120, 1:120);
% 计算中心坐标
center = [120/2, 120/2];

% 计算每个点到中心的距离
radius = min(120, 120) / 2;
mask = sqrt((x - center(1)).^2 + (y - center(2)).^2) <= radius;
I_circle =image.*mask;
RING=radon(I_circle,theta,120);
end