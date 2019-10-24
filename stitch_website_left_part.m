function stitchedImage = stitch_website_left_part( im1, im2, homography) %from the website, https://www.mathworks.com/matlabcentral/fileexchange/46148-image-mosaicing?focused=3814177&tab=function
stitchedImage = im1;
stitchedImage = padarray(stitchedImage, [0 size(im2, 2)], 0, 'pre');
stitchedImage = padarray(stitchedImage, [size(im2, 1) 0], 0, 'both');
for i = 1:size(stitchedImage, 2)
    for j = 1:size(stitchedImage, 1)
        %if j < size(im1,1) && i < size(stitchedImage, 2) - size(im1,2)
        if j > size(im2,1) %&&i < size(stitchedImage, 2)-size(im1, 2)
        p2 = homography * [size(im2, 2)-(size(stitchedImage, 2)-i+1); j-floor(size(im2, 1)); 1];
        %p2 = homography * [i-size(im2, 2); j-floor(size(im2, 1))-45; 1];
        p2 = p2 ./ p2(3);
        x2 = floor(p2(1));
        y2 = floor(p2(2));
        if x2 > 0 && x2 <= size(im2, 2) && y2 > 0 && y2 <= size(im2, 1)
            stitchedImage(j, i,:) = im2(y2, x2,:);
        end
        end
    end
end
%crop
[row,col] = find(stitchedImage);
c = max(col(:));
d = max(row(:));
st=imcrop(stitchedImage, [1 1 c d]);
[row,col] = find(stitchedImage ~= 0);
a = min(col(:));
b = min(row(:));
st=imcrop(st, [a b size(st,1) size(st,2)]);
stitchedImage = st;