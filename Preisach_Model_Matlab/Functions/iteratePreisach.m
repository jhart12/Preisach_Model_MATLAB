function [f] = iteratePreisach(u,mu)
%iteratePreisach.m Simulation of one time step of discrete scalar Preisach model of
%hysteresis with user-defined hysterons
%-----INPUTS-----
% u - scalar input
% mu - 3 x N matrix. First row is beta values, Second row is alpha values
%                    Third row is weight of hysteron with those alpha,beta
%                    values

%-----OUTPUT-----
% f - output of Preisach Model

% N - total number of hysterons
[~,N]=size(mu);

persistent last;
%initial value of input is always such that all hysterons start off.
if(isempty(last))
    last = min(min(mu(1:2,:)))-1.0;
end
%stores the state of each hysteron
persistent state;
if(isempty(state))
    state = -1*ones(N,1);
end
%-----VARIABLES-----
% mu - the 2xN matrix containing the values of a(i=1) and b (i=2) which
%     describe the jth hysteron. (i=3) gives whether the hysteron is on or off 
% M - vector whose ith value is the ith local maxima of u
% m - vector whose ith value is the ith local minima of u
% f - scalar output function of time (in vector format)

%Calculate the output at the next time step
    if u>last %if input keeps increasing 
        for i=1:N %turn on appropriate hysterons
            if state(i)==-1 && (mu(2,i)<=u)
                state(i)=1;
            end
        end
    elseif u<last %if input decreases
        for i=1:N %turn off appropriate hysterons
            if state(i)==1 && mu(1,i)>u
                state(i)=-1;
            end
        end
    end
  %{
    %TEMP SECTION TO PLOT PREISACH PLOT FOR TESTING
    figure
    hold on
    for i=1:N
        if state(i)==-1
            plot(mu(1,i),mu(2,i),'rx')
        else
            plot(mu(1,i),mu(2,i),'bx')
        end
    end
    %}
    f=mu(3,:)*state;%calculate output
    last = u;
end

