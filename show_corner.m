function[] = show_corner(img, corner)
    result = cat(3,img,img,img);%zeros([size(img,1),size(img,2)]);
    for i = 1:size(corner,1)
        for j = 1:size(corner,2)
            if corner(i,j) == 1
                result(i+1,j+1,1) = 255;
                result(i+1,j+1,2) = 0;
                result(i+1,j+1,3) = 0;
            else
                result(i,j,1) = img(i,j);
                result(i,j,2) = img(i,j);
                result(i,j,3) = img(i,j);
            end
        end
    end
    %imshow(uint8(result))
    imshow(result);
end