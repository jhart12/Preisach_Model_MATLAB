function [t,x] = ironPendulum(a,b,drive,T,dt,mu)

%ironPendulum.m -- this file uses Euler's method to simulate  a driven 
%pendulum with an iron bob in presence of a magnetic field. The magnetic
%field is built in to the density function mu of the Preisach model. We are
%using the small angle approximation, so that x=theta.

%differential equation to use: d2x/dt2 + a(dx/dt) + x = drive(t) + Px,
% where P is the preisach model with input x

% *****INPUTS*****
% a - damping coefficient of pendulum
% b - strength of the hysteresis nonlinearity
% drive - function (of time) handle representing the signal used to drive
% the pendulum
% dt - the Euler time step
% T - the final time

% *****OUTPUTS*****
% t - time at which each x value occurs
% x - position of the pendulum

clear iteratePreisach;

%simulation parameters
N = ceil(T/dt);
t = 0;
% enter initial conditions for pendulum
x0 = -1;
v0 = 0;
x = zeros(1,N);
v = zeros(1,N);
x(1) = x0;
v(1) = v0;

%Euler's method with 2 first order diff eqs.

for i = 2:N
    temp=iteratePreisach(x(i-1),mu);
    v(i) = v(i-1) + dt*(-a*v(i-1) - x(i-1) + drive(i-1) + b*iteratePreisach(x(i-1),mu));
    x(i) =  x(i-1) + dt*v(i-1);
    t = t + dt;
end

%{
testing
for i=2:N
    x(i)=iteratePreisach(drive(i-1),mu);
end
%}
t=linspace(0,T,length(x));
end