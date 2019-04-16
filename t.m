% clear; close all;
J=2; %number of decompositions to do
load('ims.mat');
% load('filter_coeffs.mat');
h=[1 1];
g=[1 -1];
g=g/norm(g); %need to be normalized to 1
h=h/norm(h);
g=[0 g];
h=[0 h];
figure(1); imagesc(img2);
img2=log(double(img2)+1e-18)/log(4);

%% Decomposition
imgo=zeros(J+1,4,size(img2,1),size(img2,2)); %#of dec,4quadrants,rows,cols
imgo(1,1,1:size(img2,1),1:size(img2,2))=img2;
for j=2:J+1 %decomposition 1-J with the initial index at 0
    imgo(j,:,:,:)=wd(imgo(j-1,1,:,:),g,h);
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

imgo=adapThresh(imgo,0.3);
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
    out=wrec(imgo(j,:,:,:),g,h);
    imgo(j-1,1,:,:)=out;
    g=[0 downsample(g(2:end),2)];
    h=[0 downsample(h(2:end),2)];
end
out=4.^out;
figure(2); imagesc((out));
% figure(2); imagesc((out(12:end-4,10:end-4)));
% caxis([0.994 1.001]);

    






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

