clear all;
clc;
clear;clc;  
image = [];
% file_path =  './DanaOffice';  
% img_path_list = dir(strcat(file_path,'*.JPG'));  
% img_num = length(img_path_list);  
% if img_num > 0      
%     for j = 1:img_num          
%         is=num2str(Startframe1);          
%         number = '0000';  % ???????0  ????6?0?          
%         number(end-length(is)+1:end)=is;          
%         filename11=[ file_path1 'DSC_' number '.JPG'];          
%         image = [image,imread(filename11)];      
%     end
% end

% % a = imread('./DanaOffice/DSC_0308.JPG');
% % b = imread('./DanaOffice/DSC_0309.JPG');
% % c = imread('./DanaOffice/DSC_0310.JPG');
% % d = imread('./DanaOffice/DSC_0311.JPG');
% % e = imread('./DanaOffice/DSC_0312.JPG');
% f = imread('./DanaOffice/DSC_0313.JPG');
% g = imread('./DanaOffice/DSC_0314.JPG');
% h = imread('./DanaOffice/DSC_0315.JPG');
% i = imread('./DanaOffice/DSC_0316.JPG');
% j = imread('./DanaOffice/DSC_0317.JPG');
% % image = cat(4,image,a);
% % image = cat(4,image,b);
% % image = cat(4,image,c);
% % image = cat(4,image,d);
% % image = cat(4,image,e);
% image = cat(4,image,f);
% image = cat(4,image,g);
% image = cat(4,image,h);
% image = cat(4,image,i);
% image = cat(4,image,j);
a = imread('./DanaHallWay1/DSC_0283.JPG');
b = imread('./DanaHallWay1/DSC_0282.JPG');
c = imread('./DanaHallWay1/DSC_0281.JPG');
image = cat(4,image,a);
image = cat(4,image,b);
image = cat(4,image,c);
% a = imread('./DanaHallWay2/DSC_0287.JPG');
% b = imread('./DanaHallWay2/DSC_0286.JPG');
% c = imread('./DanaHallWay2/DSC_0285.JPG');
% image = cat(4,image,a);
% image = cat(4,image,b);
% image = cat(4,image,c);
H_matrix = [];%zeros([3,3,size(image,4)]);
middle_number = round(size(image,4)/2);
keep_correspond1 = {};
keep_correspond2 = {};
for i = 1:size(image,4)
    if i < middle_number
        [keep_correspond1_use, keep_correspond2_use] = connect_two_image(image(:,:,:,i),image(:,:,:,i+1));
        keep_correspond1=[keep_correspond1,keep_correspond1_use];
        keep_correspond2=[keep_correspond2,keep_correspond2_use];
        %H_matrix(:,:,i) = cp2tform(keep_correspond1_use,keep_correspond2_use,'projective');
        H_matrix = [H_matrix,cp2tform(keep_correspond1_use,keep_correspond2_use,'projective')];
    elseif i > middle_number
        [keep_correspond1_use, keep_correspond2_use] = connect_two_image(image(:,:,:,i-1),image(:,:,:,i));
        keep_correspond1=[keep_correspond1,keep_correspond1_use];
        keep_correspond2=[keep_correspond2,keep_correspond2_use];
        %H_matrix(:,:,i) = cp2tform(keep_correspond2_use,keep_correspond1_use,'projective');
        H_matrix = [H_matrix,cp2tform(keep_correspond2_use,keep_correspond1_use,'projective')];
    else
        keep_correspond1_use = [1,1;1,size(image,1);size(image,2),1;size(image,2),size(image,1)];
        keep_correspond2_use = [1,1;1,size(image,1);size(image,2),1;size(image,2),size(image,1)];
        H_matrix = [H_matrix,cp2tform(keep_correspond2_use,keep_correspond1_use,'projective')];
    end
end
%% connect image
figure()
after_project = {};
img_final = [];
for i = 1:size(image,4)
    %i = size(image,4)-t+1;
    if i <= middle_number
        kk = i;
        use_H = H_matrix(i);
        for j = kk+1:middle_number
            use_H.tdata.T = (H_matrix(j).tdata.T'*use_H.tdata.T')';
            use_H.tdata.Tinv = (use_H.tdata.Tinv'*H_matrix(j).tdata.Tinv')';
        end
        after_project = [after_project,imtransform(image(:,:,:,i),use_H)];%, 'XData',[1 size(image(:,:,:,i),2)],'YData',[1 size(image(:,:,:,i),1)])];%H_matrix(i))];
    else
        kk = i;
        use_H = H_matrix(i);
        for j = 1:kk-middle_number
            use_H.tdata.T = (H_matrix(kk-j).tdata.T'*use_H.tdata.T')';
            use_H.tdata.Tinv = (use_H.tdata.Tinv'*H_matrix(kk-j).tdata.Tinv')';
        end
        after_project = [after_project,imtransform(image(:,:,:,i),use_H)]; %'XData',[1 size(image(:,:,:,i),2)],'YData',[1 size(image(:,:,:,i),1)])];
    end
    %else
    %    temp = H_matrix(i).tdata.Tinv;
    %    H_matrix(i).tdata.Tinv = H_matrix(i).tdata.T;
    %    H_matrix(i).tdata.T = temp;
    %    after_project = imtransform(image(:,:,:,i),H_matrix(i));
    %end
    
    mm = cell2mat(after_project(i));
    subplot(1,size(image,4),i);
    imshow(mm(:,:,:));
    %img_final = cat(4,img_final,mm);
end
%% the right part
stitch_two1 = image(:,:,:,1);
for i = 1:middle_number-1
    %if i <= middle_number-1
        stitch_two1 = stitch_website_right_part( image(:,:,:,i+1), stitch_two1, H_matrix(i).tdata.Tinv');%homography)
        %stitch_two1 = stitch_website_right_part(stitch_two1,image(:,:,:,i+1),  H_matrix(i).tdata.T');% for wall
        %else
        %stitch_two1 = stitch_website( image(:,:,:,i+1), stitch_two1, H_matrix(i).tdata.T');
    %end
    
end
figure()

imshow(stitch_two1);
%% just some try to get a better result 
% stitch_use_two1 = stitch_two1(:,end:-1:1,:);
% for i = middle_number+1:size(image,4)
%     image_use = image(:,:,:,i);
%     image_use = image_use(:,end:-1:1,:);
%     %if i <= middle_number-1
%         H_matrix_use = H_matrix(i).tdata.T;
%         H_matrix_use(2,3) = H_matrix_use(2,3);%+ size(stitch_use_two1,2);
%         stitch_use_two1 = stitch_website_right_part( stitch_use_two1,image_use, H_matrix(i).tdata.T');%homography)
%         %stitch_two1 = stitch_website_right_part(stitch_two1,image(:,:,:,i+1),  H_matrix(i).tdata.T');% for wall
%         %else
%         %stitch_two1 = stitch_website( image(:,:,:,i+1), stitch_two1, H_matrix(i).tdata.T');
%     %end
% end
% figure()
% imshow(stitch_use_two1);
%% the left part
stitch_two2 = image(:,:,:,size(image,4));
stitch_two2 = stitch_two2(:,end:-1:1,:);
for i = 1:middle_number-1 %i = middle_number+1:size(image,4)
    k = size(image,4)-i+1;
    use_image = image(:,:,:,k-1);
    use_image = use_image(:,end:-1:1,:);
    %stitch_two2 = stitch_website_left_part( image(:,:,:,k-1),stitch_two2, H_matrix(k).tdata.Tinv');%homography)
    stitch_two2 = stitch_website_right_part( use_image,stitch_two2, H_matrix(k).tdata.T');
%     use_H_use = H_matrix(i).tdata.Tinv';
%     j = i-1;
%     while j > middle_number
%     use_H_use = H_matrix(j).tdata.Tinv'*use_H_use;
%     j = j - 1;
%     end
%     stitch_two2 = stitch_website_left_part( stitch_two2,image(:,:,:,i), use_H_use);%H_matrix(i).tdata.Tinv');
end
%subplot(1,2,2)
%imshow(stitch_two2);
stitch_two2 = stitch_two2(:,end:-1:1,:);
figure()
imshow(stitch_two2);
%%
%stitchedImage = stitch_two1(:,1:(size(stitch_two1,2)-size(image,2)),:);
%stitchedImage = padarray(stitchedImage, [0 size(stitch_two2, 2)], 0, 'pre');
%stitchedImage = padarray(stitchedImage, [size(stitch_two2, 1) 0], 0, 'both');
%stitch_two2 is left part, stitch_two1 is rigth part
for i= 1:size(stitch_two1,1)
    if stitch_two1(i,1) ~= 0
        notzero1 = i;
    end
end
for i= 1:size(stitch_two2,1)
    if stitch_two2(i,size(stitch_two2,2)) ~= 0
        notzero2 = i;
    end
end
%if size(stitch_two1,1)> size(stitch_two2,2)
    if notzero1 - notzero2 > 0
        stitch_two2 = padarray(stitch_two2, [notzero1-notzero2 0], 0, 'pre');
%         if size(stitch_two1,1)- size(stitch_two2,2) > 0
%         stitch_two2 = padarray(stitch_two2, [size(stitch_two1,1)- size(stitch_two2,2) 0], 0, 'post');
%         else
%         stitch_two1 = padarray(stitch_two1, [size(stitch_two2,1)- size(stitch_two1,2) 0], 0, 'post');
%         end
    else%if notzero1 - notzero2 < 0
        stitch_two1 = padarray(stitch_two1, [notzero2-notzero1 0], 0, 'pre');
    end
    if size(stitch_two1,1)- size(stitch_two2,1) > 0
        stitch_two2 = padarray(stitch_two2, [size(stitch_two1,1)-size(stitch_two2,1) 0], 0, 'post');
    else
        stitch_two1 = padarray(stitch_two1, [size(stitch_two2,1)-size(stitch_two1,1) 0], 0, 'post');
    end
    
%elseif size(stitch_two1,1)< size(stitch_two2,2)
    
%else
    
%end
stitch_result = [stitch_two2(:,1:(size(stitch_two2,2)-size(image,2))+60,:),stitch_two1(:,60:end,:)];
%stitch_result = stitch_website_left_part( stitch_two1,stitch_two2, [1,0,0;0,1,0;0,0,1]);
figure()
imshow(stitch_result);
%f = [1,0,0;0,1,0;0,0,1];
%panorama = from_others_create( img_final, f, 0);

% [H,W]=size(image(:,:,1,1));%????
% l_r = zeros([1,size(image,4)]);
% for i = 1:size(image,4)-1
%     use1 = cell2mat(keep_correspond1(size(image,4)-i));
%     use2 = cell2mat(keep_correspond2(size(image,4)-i));
%     l_r(i)=abs(use1(1,1)-use2(1,1)); %find the width of overlap
% 
%     % 1?directly connect
% 
%     L=W+1-l_r(i);%left start point
% 
%     R=W;%right end point
% 
%     n=R-L+1;%overlap width
% 
%     %directly connect
%     if i == 1
%         im = image(:,:,:,size(image,4)-i+1);
%     end
%     b_grey = image(:,:,:,size(image,4)-i);
%     %figure(i);
%     %imshow(im);
%     %im=[b_grey,im(:,l_r(i):size(im,2),:)];
%     im = [b_grey(:,1:l_r(i)+1,:),im];
%     
% end
% figure;imshow(im);title('directly connecct');