function [ img_cell ] = ptcloud2cartcontext( ptcloud, axis_unit, axis_range )
x_unit = axis_unit(1); % moving direction
y_unit = axis_unit(2); % lateral direction 

x_max = axis_range(1);
y_max = axis_range(2);
x_range = [-x_max, x_max];
y_range = [-y_max, y_max];
z_range= [1,20];

num_x = round((2*x_max) / x_unit);
num_y = round((2*y_max) / y_unit);


% point cloud information 
points = ptcloud.Location;
points = points( (points(:, 1) ~= 0) & (points(:, 2) ~= 0), : );
points = points( (x_range(1) < points(:, 1)) & (points(:, 1) < x_range(2)), : );
points = points( (y_range(1) < points(:, 2)) & (points(:, 2) < y_range(2)), : );
points = points( (z_range(1) < points(:, 3)) & (points(:, 3) < z_range(2)), : );
points_x = points(:, 1);
points_y = points(:, 2);

%
points_xindex = ( sign(points_x) .* (floor(abs(points_x) / x_unit) ) ) + (floor(num_x/2) + 1);
points_yindex = ( sign(points_y) .* (floor(abs(points_y) / y_unit) ) ) + (floor(num_y/2) + 1);

points_5d = [points, points_xindex, points_yindex];
points_5d = sortrows(points_5d, [4, 5]);

img = -100*ones(num_x, num_y);

for ii = 1:length(points_5d)
    pt_z = points_5d(ii, 3);

    pixel_u = points_5d(ii, 4);
    pixel_v = points_5d(ii, 5);
%     disp([pixel_u, pixel_v]);
    
    if(img(pixel_u, pixel_v) < pt_z)
        img(pixel_u, pixel_v) = pt_z;
    end    
end
img_cell=(img>1);


end