function imgo=wd(img,G,H)
img=squeeze(img);
img=double(img);
imgo=zeros(4,size(img,1),size(img,2));
n=size(img,1);
s2=size(G,2);
for z=1:4
    temp=[];
    Q=zeros(size(img)); %each quadrant is the size of the original
    if z==1 || z== 2
        f=H;
    else
        f=G;
    end

    for i=1:size(img,1) %horizontal filter
%         temp=cconv(f,img(i,:));
%         Q(i,:)=temp(1+(s2-1)/2:end-(s2-1)/2);
%         pline=[repmat(img(i,1),[1 1+(s2-1)/2]) img(i,:) repmat(img(i,end),[1 (s2-1)/2])];
        pline=[fliplr(img(i,2:(s2+1)/2+1)) img(i,:) fliplr(img(i,(end-1-(s2-1)/2):end-1))];
        temp=cconv(f,pline);
        Q(i,:)=temp(s2:end-s2-1);
    end
    
    temp=[];
    Q=Q';
    if z==2 || z== 4
        f=G;
    else
        f=H;
    end    
    for i=1:size(Q,1) %vert filt
%         
%         temp=cconv(f,Q(i,:));
%         Q(i,:)=temp(1+(s2-1)/2:end-(s2-1)/2);
%         pline=[repmat(Q(i,1),[1 1+(s2-1)/2]) Q(i,:) repmat(Q(i,end),[1 (s2-1)/2])];
        pline=[fliplr(Q(i,2:1+(s2+1)/2)) Q(i,:) fliplr(Q(i,(end-1-(s2-1)/2):end-1))];
        temp=cconv(f,pline);
        Q(i,:)=temp(s2:end-s2-1);
    end
    Q=Q';
%     Q=Q./2;
    imgo(z,:,:)=Q;
end

    