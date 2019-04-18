% clear; close all;
J=6; %number of decompositions to do
load('ims.mat');
% load('filter_coeffs.mat');
h=[1 1];
g=[1 -1];
g=g/norm(g); %need to be normalized to 1
h=h/norm(h);
g=[0 g];
h=[0 h];
jtbx=log2(256)-J;
cfg.ti=1;
% figure(1); imagesc(img2);
img2=double(img2(1:256,1:256));
imgPreNoise=img2;
img2=img2.*(1+0.003*randn(size(img2)));
img2=log(double(img2)+1e-18)/log(4);
figure(1); imagesc(img2);

%% Decomposition
imgo=zeros(J+1,4,size(img2,1),size(img2,2)); %#of dec,4quadrants,rows,cols
imgo(1,1,1:size(img2,1),1:size(img2,2))=img2;
for j=2:J+1 %decomposition 1-J with the initial index at 0
    imgo(j,:,:,:)=wd(imgo(j-1,1,:,:),g,h);
%     imgo(j,:,:,:)=wdmat(imgo(j-1,1,:,:),j,g,h);
%     imgo(j,:,:,:)=wdmat(imgo(j-1,1,:,:),j,g,h);
    g=[0 upsample(g(2:end),2)];
    h=[0 upsample(h(2:end),2)];
%     for i=1:4
%         temp=squeeze(imgo(j,i,4:end-4,4:end-4));
%         subplot(2,2,i);imagesc(temp);
%         title(sprintf('Quadrant %d',i));
%         colorbar;
%     end
%     pause()
end

imgo2=zeros(J+1,4,size(img2,1),size(img2,1)); %#of dec,4quadrants,rows,cols
imgo2(1,1,1:size(img2,1),1:size(img2,1))=img2(1:256,1:256);
w_list=perform_wavelet_transform(double(img2(1:256,1:256)),jtbx,1,cfg);
imgo2(1,1,:,:)=w_list{end};
for j=2:J+1
    imgo2(j,2,:,:)=w_list{end-(j-2)*3-1};
    imgo2(j,3,:,:)=w_list{end-(j-2)*3-2};
    imgo2(j,4,:,:)=w_list{end-(j-2)*3-3};
end

imgo=adapThresh(imgo,0.3);
imgo=adapThresh(imgo,0.3);
imgo2=adapThresh(imgo2,0.7);
imgo2=adapThresh(imgo2,0.7);

%    for i=1:4
%         temp=squeeze(imgo(j,i,4:end-4,4:end-4));
%         subplot(2,2,i);imagesc(temp);
%         title(sprintf('Quadrant %d',i));
%         colorbar;
%     end
%     pause()
% 
%% Reconstruction
g=wshift(1,fliplr(g),2^J-2); 
h=wshift(1,fliplr(h),2^J-2);
out=zeros(size(img2));
for j=J+1:-1:2
    out=wrec(imgo(j,:,:,:),g*sqrt(2),h*sqrt(2));
    imgo(j-1,1,:,:)=out;
    g=[0 downsample(g(2:end),2)];
    h=[0 downsample(h(2:end),2)];
end
out=4.^out;
figure(2); imagesc((out));
% figure(2); imagesc((out(12:end-4,10:end-4)));
% caxis([0.994 1.001]);

w_list2=cell(1,length(w_list));
w_list2{end}=squeeze(imgo2(1,1,:,:));
for j=2:J+1
    w_list2{end-(j-2)*3-1}=squeeze(imgo2(j,2,:,:));
    w_list2{end-(j-2)*3-2}=squeeze(imgo2(j,3,:,:));
    w_list2{end-(j-2)*3-3}=squeeze(imgo2(j,4,:,:));
end
out2=perform_wavelet_transform(w_list2,jtbx,1,cfg);
out2=4.^out2;
figure(3); imagesc(out2);

img2=4.^img2;
MSE_pre = sum(sum((imgPreNoise(1:256,1:256)-img2(1:256,1:256)).^2))/numel(out)
MSE_post = sum(sum((imgPreNoise(1:256,1:256)-out(1:256,1:256)).^2))/numel(out)
MSE_post2 = sum(sum((imgPreNoise(1:256,1:256)-out2).^2))/numel(out)





%% Compare
% pause()
% [C,S]=wavedec2(img2,j-1,'db2');
% [H1,V1,D1] = detcoef2('all',C,S,1);
% A1 = appcoef2(C,S,'db2',1);
% 
% subplot(2,2,1); imagesc(A1); colorbar;
% subplot(2,2,2); imagesc(H1);colorbar;
% subplot(2,2,3); imagesc(V1);colorbar;
% subplot(2,2,4); imagesc(D1);colorbar;

