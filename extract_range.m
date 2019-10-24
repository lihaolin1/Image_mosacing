function[range] = extract_range(img, point, s)
    r = (s-1)/2;
    range = zeros([s,s]);
   
    range(r+1,r+1) = img(point(1),point(2));
    for i = 1:r
        for j = 1:r
            if point(1)+i <= size(img,1)
                if point(2)+j <= size(img,2)
                    range(r+1+i,r+1+j) = img(point(1)+i,point(2)+j);
                end
                if point(2)-j > 0
                    range(r+1+i,r+1-j) = img(point(1)+i,point(2)-j);
                end
            end
            if point(1)-i > 0
                if point(2)+j <= size(img,2)
                    range(r+1-i,r+1+j) = img(point(1)-i,point(2)+j);
                end
                if point(2)-j > 0
                    range(r+1-i,r+1-j) = img(point(1)-i,point(2)-j);
                end
            end
        end
    end
end