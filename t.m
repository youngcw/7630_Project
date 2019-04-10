clear; close all;
J=2; %number of decompositions to do
load('ims.mat');
load('filter_coeffs.mat');
g=g/norm(g); %need to be normalized to 1
h=h/norm(h);
g=[0 g];
h=[0 h];
% imagesc(img2);
% pause()
imgo=zeros(J+1,4,size(img2,1),size(img2,2)); %#of dec,4quadrants,rows,cols
imgo(1,1,1:size(img2,1),1:size(img2,2))=img2;
for j=2:J+1 %decomposition 1-J with the initial index at 0
    imgo(j,:,:,:)=wd(imgo(j-1,1,:,:),g,h);
    g=[0 upsample(g(2:end),2)];
    h=[0 upsample(h(2:end),2)];
    for i=1:4
        temp=squeeze(imgo(j,i,4:end-4,4:end-4));
        subplot(2,2,i);imagesc(temp);
        title(sprintf('Quadrant %d',i));
        colorbar;
    end
end







% pause()
% [C,S]=wavedec2(img2,j-1,'db2');
% [H1,V1,D1] = detcoef2('all',C,S,1);
% A1 = appcoef2(C,S,'db2',1);
% 
% subplot(2,2,1); imagesc(A1); colorbar;
% subplot(2,2,2); imagesc(H1);colorbar;
% subplot(2,2,3); imagesc(V1);colorbar;
% subplot(2,2,4); imagesc(D1);colorbar;

