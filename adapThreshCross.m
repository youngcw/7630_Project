function dhat=adapThreshCross(d, mthresh)
if nargin==0
    test_adtc
    return
end
[M, N, I, J]=size(d); %#ok<*ASGLU>
sig2=median(d(:))/0.674;
dhat=d;

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

function test_adtc()
    rng(3)
    d=3*eye(16)+3*flipud(eye(16)); 
    dn=randn(16,16)+d;
    d2=adapThreshCross(dn,0.1); 
    d3=adapThreshCross(dn,0.8);
    figure; 
    subplot(141); image(10*(d+2)); title('Original');
    subplot(142); image(10*(dn+2)); title('Noisy')
    subplot(143); image(10*(d2+2)); title('Threshold, m=0.1')
    subplot(144); image(10*(d3+2)); title('Threshold, m=0.9')
    
    figure; hold on;
    v=linspace(0,2,3000);
    t1=v; t2=v; t3=v; t4=v; 
    for k=1:length(v)
        t1(k)=softThresh(v(k),0.0,1.0);
        t2(k)=softThresh(v(k),0.3,1.0);
        t3(k)=softThresh(v(k),0.7,1.0);
        t4(k)=softThresh(v(k),1.0,1.0);
    end
    plot(v,t1); plot(v,t2); plot(v,t3); plot(v,t4);  
    title('Threshold function');
    legend('m=0.0','m=0.3','m=0.7','m=1.0')
    xlabel('Original coefficient');
    ylabel('Thresholded coefficient');
end
% d=randn(16,16)+2*eye(16)+2*flipud(eye(16)); d2=adapThresh(d,0.5); figure; subplot(121); imagesc(d); subplot(122); imagesc(d2);
% d=randn(16,16)+3*eye(16)+3*flipud(eye(16)); d2=adapThreshCross(d,0.3); figure; subplot(121); image(5*(d+6)); subplot(122); image(5*(d2+6));