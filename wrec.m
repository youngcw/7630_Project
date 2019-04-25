function out=wrec(img,G,H)
img=squeeze(img);
out=zeros(size(img,2),size(img,3));
s2=size(G,2);
for z=1:4
    temp=[];
    Q=zeros(size(out)); %each quadrant is the size of the original
    if z==1 || z== 2
        f=H;
    else
        f=G;
    end

    for i=1:size(Q,1) %horizontal filter
%         temp=cconv(f,img(z,i,:));
%         Q(i,:)=temp(1+(s2-1)/2:end-(s2-1)/2);
%         pline=[repmat(img(z,i,1),[1 1+(s2-1)/2]) squeeze(img(z,i,:)).' repmat(img(z,i,end),[1 (s2-1)/2])];
        pline=[fliplr(squeeze(img(z,i,2:1+(s2+1)/2))).' squeeze(img(z,i,:)).' fliplr(squeeze(img(z,i,(end-1-(s2-1)/2):end-1))).'];
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
%         temp=cconv(f,img(z,:,i));
%         Q(i,:)=temp(1+(s2-1)/2:end-(s2-1)/2);
%         pline=[repmat(img(z,1,i),[1 1+(s2-1)/2]) squeeze(img(z,:,i)) repmat(img(z,end,i),[1 (s2-1)/2])];
        pline=[fliplr(img(z,2:1+(s2+1)/2,i)) squeeze(img(z,:,i)) fliplr(img(z,(end-1-(s2-1)/2):end-1,i))];
        temp=cconv(f,pline);
        Q(i,:)=temp(s2:end-s2-1);
    end
    Q=Q';
    out=out+Q./(4);
end

end