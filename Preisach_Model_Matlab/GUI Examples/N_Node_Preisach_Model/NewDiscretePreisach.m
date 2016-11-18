function [f]=NewDiscretePreisach(u,mu,n)
% Calculates output for new discrete Preisach model; it is assumed that all
% hysterons begin in the down state

% u is the input, read in from the user
% mu - the 3xN matrix containing the values of a(i=1) and b (i=2) which
%     describe the jth hysteron. (i=3) gives whether the hysteron is on or off 
N=n*(n+1)/2; %calculate from input
for i=1:N %turn on appropriate hysterons
   if mu(3,i)==-1 && mu(1,i)<=u && mu(2,i)<=u
     mu(3,i)=1;
   end
end
f=sum(mu(3,:));