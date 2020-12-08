clear;clc;
NYRSimHurV4_NE7=load('.\syntheticHurricanes\NYRSimHurV4_NE7.mat');
%% hurricane NYRSimHurV4_NE7_NYR2_Sim1
NYR=2;
Sim=1;
hurr=NYRSimHurV4_NE7.NYRSimHur(NYR).SimHur(Sim);
hurrName=sprintf('NYRSimHurV4_NE7_NYR%1i_Sim%1i',NYR,Sim);
refEye=23;
dLati1=-1.4;
dLati2=-0.9;
dLati3=-0.45;
dLati4=-0.001;
dLong=0.0;
duration=9;
windRecord(hurr,hurrName,refEye,dLati1,dLong,duration)
windRecord(hurr,hurrName,refEye,dLati2,dLong,duration)
windRecord(hurr,hurrName,refEye,dLati3,dLong,duration)
windRecord(hurr,hurrName,refEye,dLati4,dLong,duration)