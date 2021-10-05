clear;clc;
dura1=load('loc1-3duraGood.mat');
dura1=dura1.duraGood;
dura2=load('loc1NE2duraGood.mat');
dura2=dura2.duraGood;
dura3=load('loc1NE3-2duraGood.mat');
dura3=dura3.duraGood;
dura4=load('loc1NE4duraGood.mat');
dura4=dura4.duraGood;
dura=[dura1,dura2,dura3,dura4];

figure
histogram(dura/60.0,20,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
title('Duration considering hurricane eyes within 250 km')