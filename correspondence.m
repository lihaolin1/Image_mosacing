function[correspond1,correspond2] = correspondence(a_grey, b_grey, corner1, corner2,n)
    [m1,n1] = size(corner1);
    %[m2,n2] = size(corner2); just assume corner1 and corner2 are in same
    %size
    use1 = zeros([n,2]);
    use2 = zeros([n,2]);
    %use_use2 = zeros([n,2]);
    use_use1 = [];
    use_use2 = [];
    k1 = 1;
    k2 = 1;
    correspond1 = [];
    correspond2 = [];
    for i = 1:m1
        for j=1:n1
            if corner1(i,j) == 1
                use1(k1,:) = [i+1,j+1];
                k1 =k1 + 1;
            end
            if corner2(i,j) == 1
                use2(k2,:)= [i+1,j+1];
                k2 = k2 + 1;
            end
        end
    end
    
    for i = 1:n
        sr1 = 11;
        sr2 = 13;
        range1 = extract_range(a_grey, use1(i,:),sr1);%7%5); %the last parameter of size must be an odd number
        one_pixel = [];%zeros([1,n]);
        use_use2 = [];
        for j = 1:n
            range2 = extract_range(b_grey, use2(j,:),sr2);%9%11);
            use_range1 = range1 - mean(mean(range1));
            use_range2 = range2 - mean(mean(range2));
            if sum(sum(use_range1)) ~= 0
            use_range1 = use_range1/sum(sum(use_range1));
            end
            if sum(sum(use_range2)) ~= 0
            use_range2 = use_range2/sum(sum(use_range2));
            end
            C = normxcorr2(use_range1,use_range2);%sum(sum(range1.*range2))/sqrt(sum(sum(range1.*range1)) + sum(sum(range2.*range2)));%calculate NCC
            [ypeak, xpeak] = find(C==max(C(:)));
            %Compute translation from max location in correlation matrix
            %yoffSet = ypeak-size(onion,1);
            %xoffSet = xpeak-size(onion,2);
            if size(xpeak,1) > 1
                xpeak = xpeak(1);
                ypeak = ypeak(1);
            end
            if max(C(:)) > 0.94
                one_pixel = [one_pixel,max(C(:))];
            %if one_pixel(j) > 0.7
                %use_use2(j,:) = [use2(j,1)-(13-1)/2+xpeak-1,use2(j,2)-(13-1)/2+ypeak-1];
                use_use2 = [use_use2;[use2(j,1)-(sr2-1)/2+xpeak-1-(sr1-1)/2,use2(j,2)-(sr2-1)/2+ypeak-1-(sr1-1)/2]];
            end
            %find where is the maxmum one_pixel value and make it as our
            %result
        end
        %choose the max as correspondence
        if size(one_pixel) ~= 0
            [big,id] = max(one_pixel);
            correspond1 = [correspond1;use1(i,:)];%[use1(i,1),use1(i,2)]];
            correspond2 = [correspond2;use_use2(id,:)];%[use2(id,1),use2(id,2)]];
        end
    end
end