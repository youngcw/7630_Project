function dhat=adapThresh(d, mthresh)
[J, I, M, N]=size(d); %#ok<*ASGLU>
dno1=(d(2:end,2:end,:,:));
% sig2=median(abs(dno1(:)))/0.6745;
sig2=abs(median(dno1(:)));
dhat=d;


for i=2:I
    for j=1:J
        lambda=sqrt(sig2)*sqrt(2*log(M*N))/log(j+1);

%         dj=d(i,j,:,:);
%         lambda=sqrt(median(dj(:)/0.674))*sqrt(2*log(M*N))/log(j+1);
        for m=1:M
            for n=1:N
                dhat(j,i,m,n)=softThresh(d(j,i,m,n),mthresh,lambda);
            end
        end
    end
end

end

function dhat=softThresh(d,m,lambda)
    if abs(d)<lambda/2
        dhat=0;
    elseif abs(d)<lambda
        dhat=d;
    else
        dhat=sign(d)*(abs(d)-m*lambda*(1-exp(-(abs(d)-lambda)))./(1+exp(-(abs(d)-lambda))));
    end
end

% d=randn(16,16)+2*eye(16)+2*flipud(eye(16)); d2=adapThresh(d,0.5); figure; subplot(121); imagesc(d); subplot(122); imagesc(d2);
% d=randn(16,16)+3*eye(16)+3*flipud(eye(16)); d2=adapThresh(d,0.3); figure; subplot(121); image(5*(d+6)); subplot(122); image(5*(d2+6));