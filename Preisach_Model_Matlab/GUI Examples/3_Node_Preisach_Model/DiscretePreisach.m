function [f,mu] = DiscretePreisach(count,uNew,mu,n)
%DiscretePreisach.m Simulation of discrete scalar Preisach model of
%hysteresis. To be used with accompanying GUI PreisachGUI.m
%-----INPUTS-----
% uOld - previous input
uOld=uNew(count-1);
uNew=uNew(count);
% uNew - current input
% mu - the 3xN matrix containing the values of a(i=1) and b (i=2) which
%     describe the jth hysteron. (i=3) gives whether the hysteron is on or off 
% n - number of hysterons up the side of the plane
% N - total number of hysterons

N=n*(n+1)/2; %calculate from input

%-----OUTPUTS-----
% f - scalar output function of time (in vector format)

%Calculate the output
%turn on hysterons with a<u & b<u
if uNew>uOld %if input keeps increasing 
  for i=1:N %turn on appropriate hysterons
    if mu(3,i)==-1 && (mu(1,i)<uNew || abs(mu(1,i)-uNew)<.0001)
      mu(3,i)=1;
    end
  end
elseif uNew<uOld %if input decreases
  for i=1:N %turn off appropriate hysterons
    if mu(3,i)==1 && mu(2,i)>uNew
      mu(3,i)=-1;
    end
  end
end
f=sum(mu(3,:));