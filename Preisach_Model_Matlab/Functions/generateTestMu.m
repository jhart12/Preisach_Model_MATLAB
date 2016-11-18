function [mu]=generateTestMu(n,a0,regular)
% Returns density function mu of regularly or randomly distributed
% hysterons.
% This mu matrix can then input to iteratePreisach.m

%-----INPUTS-----
% n - number of hysterons on a side
% a0 - maximum value of a
% regular - boolean that determines whether user wants Regular or Random
% placement of hysterons in a and b

%-----OUTPUTS-----
% mu - Preisach density function
% mu(1,i) gives the beta value of the ith hysteron
% mu(2,i) gives the alpha value of the ith hysteron
% mu(3,i) gives the weight of the ith hysteron

N=n*(n+1)/2; %total number of hysterons
mu=zeros(3,N);
mu(3,:)=1/N; %all hysterons have weight 1/N
if regular
%---for Regular Discrete Preisach Model---
d=2*a0/(n+1); %vertical/horizontal distance between consecutive relays
mu(1,1)=-a0+1.5*d;
mu(2,1)=-a0+.5*d;
h=mu(1,1);
count=1;
for i=2:n
    h=h+d;    
    for j=1:i
        count=count+1;
        mu(1,count)=h;
        if abs(mu(1,count))<10^-10
            mu(1,count)=0;
        end
        if j==1
            mu(2,count)=mu(2,1);
        else
            mu(2,count)=mu(2,count-1)+d;
        end        
        if abs(mu(2,count))<10^-10
            mu(2,count)=0;
        end
    end
end
else
%---for Random Discrete Preisach Model---
V = [-a0, -a0; -a0, a0; a0, a0];  % # Triangle vertices, pairs of (x, y)
t = sqrt(rand(N, 1));
s = rand(N, 1);
P = (1 - t) * V(1, :) + bsxfun(@times, ((1 - s) * V(2, :) + s * V(3, :)),t);
mu(2,:)=P(:,1);
mu(1,:)=P(:,2);
end
