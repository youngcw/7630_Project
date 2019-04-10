function dhat=adapThresh(d, m)
[M,N,J,I]=size(d); %#ok<*ASGLU>
sig2=medain(d(:))/0.674;

for i=1:I
    for j=1:J
        lambda=sqrt(sig2)*sqrt(2*log(j+1))/log(j+1);
        
    end
end

end

function dhat=softThresh(d,m,lambda)
    if abs(d)<lambda/2
        dhat=0;
    elseif abs(d)<lambda
        dhat=d
    else
        dhat=sign(d)*(abs(d)-m*lambda*(1-exp(-(abs(d)-lambda)))/(1+exp(-(abs(d)-lambda))));
end