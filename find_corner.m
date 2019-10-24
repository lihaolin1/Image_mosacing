function[corner_img, result, Rmax] = find_corner(img)  %corner_img
    %use prewitt filter to calculate gradient
    %use 5*5 Gaussian filter to smooth
    prew_h = [1 2 1; 0 0 0; -1 -2 -1];
    prew_v = [-1 0 1; -2 0 2; -1 0 1];
    H=fspecial('gaussian',9, 2);% generate Gaussian filter   
    img_gauss=imfilter(img,H,'replicate'); %filt image
    %start calculate gradient
    img_gradient_x = conv2(img_gauss, prew_h, 'valid');%'same');
    img_gradient_y = conv2(img_gauss, prew_v, 'valid');%'same');
    x_square = img_gradient_x.*img_gradient_x;
    y_square = img_gradient_y.*img_gradient_y;
    xy_use = img_gradient_x.*img_gradient_y;
    %process to generate C
    h = fspecial('gaussian',[5 5],1);%ones([5,5]); use gaussian weight
    xx = conv2(x_square,h,'same');
    yy = conv2(y_square,h,'same');
    xy = conv2(xy_use,h,'same');
    Rmax = 0;
    corner_img = zeros([size(x_square,1), size(x_square,2)]);
    result = zeros([size(x_square,1), size(x_square,2)]);
    %R_matrix = zeros([size(x_square,1), size(x_square,2)]);
    for i = 1:size(x_square,1)
        for j = 1:size(y_square,2)
            C = [xx(i,j) xy(i,j); xy(i,j) yy(i,j)];
            R = det(C) - 0.04*(trace(C)^2);
            result(i,j) = R;
            if R > Rmax
                Rmax = R;
            end
        end
    end
    for i = 1:size(x_square,1)
        for j = 1:size(y_square,2)
            if result(i,j) > 0.0005 * Rmax
                corner_img(i,j) = 1;
            end
        end
    end
end