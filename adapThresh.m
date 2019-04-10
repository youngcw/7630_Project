function dhat=adapThresh(d, mthresh)
[M,N,J,I]=size(d); %#ok<*ASGLU>
sig2=median(d(:))/0.674;
dhat=zeros(size(d));

for i=1:I
    for j=1:J
        lambda=sqrt(sig2)*sqrt(2*log(M*N))/log(j+1);
        for m=1:M
            for n=1:N
                dhat(m,n,i,j)=softThresh(d(m,n,i,j),mthresh,lambda);
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