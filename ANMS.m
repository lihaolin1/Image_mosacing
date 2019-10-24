function[corner] = ANMS(R, Rmax, number_choose)
    large_row1 = [];
    large_row2 = [];
    medium_row1 = [];
    medium_row2 = [];
    medium_distance = [];
    for i = 1:size(R,1)
        for j = 1:size(R,2)
            if R(i,j) >= 0.5*Rmax
                large_row1 = [large_row1 i];
                large_row2 = [large_row2 j];
            end
        end
    end
    large = [large_row1;large_row2];
    for i = 1:size(R,1)
        for j = 1:size(R,2)
            if R(i,j) < 0.5*Rmax && R(i,j) >= 0.05*Rmax
                use = [i*ones([1,size(large,2)]);j*ones([1,size(large,2)])];
                temp = large - use;
                medium_row1 = [medium_row1 i];
                medium_row2 = [medium_row2 j];
                medium_distance = [medium_distance min(sqrt(temp(1,:).^2 + temp(2,:).^2))];
            end
        end
    end
    medium = [medium_row1;medium_row2];
    %
    corner = zeros([size(R,1),size(R,2)]);
    for i = 1:size(large,2)
        corner(large(1,i),large(2,i)) = 1;
        if number_choose > 0
            number_choose = number_choose-1;
        else
            break;
        end
    end
    
    [medium_distance,id] = sort(medium_distance,'descend');
    medium = medium(:,id);
    for i = 1:size(medium,2)
        if number_choose > 0
            corner(medium(1,i),medium(2,i)) = 1;
            number_choose = number_choose - 1;
        else
            break;
        end
    end       
end