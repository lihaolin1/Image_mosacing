function[ keep_correspond1, keep_correspond2] = connect_two_image(a,b)  %a,b are two image you want to connect
% keep_correspond1 and  keep_correspond2 are the connected point from two
% different image
%% read in
    %a = imread('./DanaOffice/DSC_0308.JPG');
    %b = imread('./DanaOffice/DSC_0309.JPG');
    %a = imread('./DanaHallWay1/DSC_0281.JPG');
    %b = imread('./DanaHallWay1/DSC_0282.JPG');
    a_grey = rgb2gray(a(30:size(a,1),:,:));
    b_grey = rgb2gray(b(30:size(a,1),:,:));
    %% find corner
    [a_corner_ori, a_R,a_Rmax] = find_corner(a_grey);
    [b_corner_ori, b_R,b_Rmax] = find_corner(b_grey);
    %% apply ANMS
    n = 300;
    a_corner_ANMS = ANMS(a_R, a_Rmax, n);
    b_corner_ANMS = ANMS(b_R, b_Rmax, n);
    %% show the differences between the result apply ANMS or not
    figure()
    subplot(1,2,1);
    show_corner(a_grey, a_corner_ori);
    title('Before ANMS for figure a')
    subplot(1,2,2);
    show_corner(a_grey, a_corner_ANMS);
    title('After ANMS for figure a');
    figure()
    subplot(1,2,1);
    show_corner(b_grey, b_corner_ori);
    title('Before ANMS for figure b');
    subplot(1,2,2);
    show_corner(b_grey, b_corner_ANMS);
    title('After ANMS for figure b');
    %% find the same corner in two image
    [correspond1,correspond2] = correspondence(a_grey, b_grey, a_corner_ANMS, b_corner_ANMS,n);
    %% show the reuslt
    connect = [a_grey;b_grey];
    %showMatchedFeatures(a_grey,b_grey, matchedPoints1,matchedPoints2);
    %for i = size(correspond,2)/2:size(correspond,2)
    %    use_correspond(2,i) = use_correspond(2,i)+ size(a_grey,2);
    %end

    use_correspond1 = [correspond1(:,2),correspond1(:,1)];
    use_correspond2 = [correspond2(:,2),correspond2(:,1)];
    use_correspond2(:,2) = use_correspond2(:,2)+ size(a_grey,1);


    figure
    imshow(connect);
    hold on
    for i = 1:size(use_correspond1,1)
        plot([use_correspond1(i,1),use_correspond2(i,1)], [use_correspond1(i,2),use_correspond2(i,2)],'r-');
        hold on
    end
    plot(use_correspond1(:,1), use_correspond1(:,2),'r.');
    plot(use_correspond2(:,1), use_correspond2(:,2),'r.');
    %for i = 1:size(use_correspond,2)-1
    %    plot(use_correspond(1:2,i),use_correspond(1:2,i+1),'r-')
    %    hold on
    %end
    %% use RANSAC
    use_correspond2(:,2) = use_correspond2(:,2)- size(a_grey,1);
    %% calculate H
    H_save = zeros([3,3,100]);
    save_online = zeros([1,100]);
    for i=1:120%110%size(use_correspond2,1)
        %randomli choose 4 pair points, and calculate the H transformation
        %matrix, then transfor every point from one image two another,
        %calcualte the tranformation and original error, choose the minimum
        %error 4 points, save H
        use_point1 = zeros([4,2]);
        use_point2 = zeros([4,2]);
        for j = 1:4
            choose_point_index1 = ceil(rand(1,1)*size(use_correspond1,1));
            %choose_point_index2 = ceil(rand(1,1)*size(use_correspond2,1)); %randomly choose point
            use_point1(j,:) = use_correspond1(choose_point_index1,:);
            use_point2(j,:) = use_correspond2(choose_point_index1,:);
        end
        %already get 4 pairs of point,calculate matrix H
        H = genreate_tranformation(use_point1, use_point2);
        %now we get H, use H to translate point from img2 to img1, calculate
        %the error between tranlate point and real pair point, choose the pair
        %which have the minimum value; and can also set a threshold, minimum
        %value should smaller than some value
        if max(max(H)) == Inf || sum(sum(isnan(H))) > 0
            continue;
        end
        if rank(H) == 3
            H_save(:,:,i) = H;%inv(H); %H is H matric from 1 to 2, inv(H) is from 2 to 1
            online = 0;
            for j = 1:size(use_correspond1,1)
                fake1 = H*[use_correspond1(j,:),1]';%H\[use_correspond2(j,:),1]';
                fake1 = [round(fake1(1)/fake1(3)),round(fake1(2)/fake1(3))];
                if sqrt(sum((use_correspond2(j,:) - fake1).^2)) < sqrt(6)%1.^2+1.^2)
                    online = online + 1;
                end
            end
            save_online(i) = online;
        end
    end
    %[online_result,id] = sort(save_online,'descend');
    [online_max,id] = max(save_online);
    H_result = H_save(:,:,id); %H_result should be the right tranformation H matrix, from img2 to img1
    %% So the after RANSAC result
    keep_correspond1 = [];
    keep_correspond2 = [];
    for i = 1:size(use_correspond1,1)
        fake1 = H_result*[use_correspond1(i,:),1]';
        fake1 = [round(fake1(1)/fake1(3)),round(fake1(2)/fake1(3))];
        if sqrt(sum((use_correspond2(i,:) - fake1).^2)) < sqrt(10)%2.^2+2.^2)  %the generous
            keep_correspond1 = [keep_correspond1;use_correspond1(i,:)];
            keep_correspond2 = [keep_correspond2;use_correspond2(i,:)];
        end
    end
    keep_correspond2(:,2) = keep_correspond2(:,2)+ size(a_grey,1);
    figure
    imshow(connect);
    hold on
    for i = 1:size(keep_correspond1,1)
        plot([keep_correspond1(i,1),keep_correspond2(i,1)], [keep_correspond1(i,2),keep_correspond2(i,2)],'r-');
        hold on
    end
    plot(keep_correspond1(:,1), keep_correspond1(:,2),'r.');
    hold on
    plot(keep_correspond2(:,1), keep_correspond2(:,2),'r.');
    keep_correspond2(:,2) = keep_correspond2(:,2)- size(a_grey,1);
end