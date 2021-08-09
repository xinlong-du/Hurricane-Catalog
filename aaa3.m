clear;clc;
x = linspace(-2*pi,2*pi);
y = 0:0.1:12;
[X,Y] = meshgrid(x,y);
Z = sin(X) + cos(Y);
figure
contourf(x,y,Z,10)