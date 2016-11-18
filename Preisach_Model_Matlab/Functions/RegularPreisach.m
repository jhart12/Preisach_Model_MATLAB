function [f] = RegularPreisach( u )
%RegularPreisach.m Simulation of discrete scalar Preisach model of
%hysteresis with regularly spaced hysterons
%-----INPUTS-----
% u - input scalar function of time (in vector format), assumed to be -a0 for t<t0

%-----PARAMETERS-----
% n - number of hysterons up the side of the plane
% N - total number of hysterons
% a0 - maximum value of a in distribution of hysterons
n=10;
N=n*(n+1)/2;
a0=1;

%-----VARIABLES-----
% mu - the 2xN matrix containing the values of a(i=1) and b (i=2) which
%     describe the jth hysteron. (i=3) gives whether the hysteron is on or off 
% M - vector whose ith value is the ith local maxima of u
% m - vector whose ith value is the ith local minima of u
% f - scalar output function of time (in vector format)

% Step 1: Determine mu

mu=zeros(3,N);
d=2*a0/(n+1); %vertical/horizontal distance between consecutive relays
mu(1,1)=-a0+1.5*d;%a value
mu(2,1)=-a0+.5*d;%b value
h=mu(1,1);
count=1;
for i=2:n
    h=h+d;    
    for j=1:i
        count=count+1;
        mu(1,count)=h;
        if abs(mu(1,count))<10^-10 %eliminate rounding errors
            mu(1,count)=0;
        end
        if j==1
            mu(2,count)=mu(2,1);
        else
            mu(2,count)=mu(2,count-1)+d;
        end        
        if abs(mu(2,count))<10^-10 %eliminate rounding errors
            mu(2,count)=0;
        end
    end
end

clear count h d

% Step 2: Calculate the output as a function of time
L=length(u);
f=zeros(1,L);
mu(3,:)=-1; %every hysteron starts in down state by assumption
    for i=1:N %turn on appropriate hysterons
        if mu(3,i)==-1 && mu(1,i)<=u(1)
            mu(3,i)=1;
        end
    end
    f(1)=sum(mu(3,:));
for k=2:L    
    if u(k)>u(k-1) %if input keeps increasing 
        for i=1:N %turn on appropriate hysterons
            if mu(3,i)==-1 && (mu(1,i)<=u(k) || abs(mu(1,i)-u(k))<.0001)
                mu(3,i)=1;
            end
        end
    elseif u(k)<u(k-1) %if input decreases
        for i=1:N %turn off appropriate hysterons
            if mu(3,i)==1 && mu(2,i)>u(k)
                mu(3,i)=-1;
            end
        end
    end
    f(k)=sum(mu(3,:));%calculate output
%{%}    
    %-----Plot Results on Preisach graph for each input-----
    %figure(k)
    %hold on
    up=zeros(2,1);
    down=up;
    countUp=0;
    countDown=0;
    for j=1:N
    if mu(3,j)==1
        countUp=countUp+1;
        up(1,countUp)=mu(1,j);
        up(2,countUp)=mu(2,j);
    else
        countDown=countDown+1;
        down(1,countDown)=mu(1,j);
        down(2,countDown)=mu(2,j);
    end
    end
    %{
    if countUp>0
    plot(up(2,:),up(1,:),'x','MarkerSize',14)
    end
    if countDown>0
    plot(down(2,:),down(1,:),'rx','MarkerSize',14)
    end
    plot([-a0 a0],[-a0 a0],'k')
    legend('up','down')
    %}
    
    %-----End Plot-----
end

%Plot Output vs Input
figure
plot(u,f)
xlabel('Input')
ylabel('Output')

%Plot Input and Output vs Time
figure
subplot(2,1,1)
plot(u)
ylabel('Input')
subplot(2,1,2)
plot(f)
ylabel('Output')


end

