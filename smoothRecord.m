clear;close all;clc;
%% load hurrican wind speed and direction records
uSpdDir=load('.\windRecords\NYRSimHurV4_NE7_NYR2_Sim1_50km.txt');
uSpd=uSpdDir(:,1);
uDir=uSpdDir(:,2);
%stairs plot
time=0:60:9*60;
time=time';
uSpd=[uSpd;0];
uDir=[uDir;0];
figure
yyaxis left
stairs(time,uSpd)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
stairs(time,uDir)
ylabel('wind direction (rad)')
ylim([0 2*pi])
%% smooth use Logistic function
x0=5;
x=0.5:1:9.5;
x=x';
L=uSpd(1);
k=1;
y=logistic(x,L,k,x0);
timeIn=floor(x);
uSpdIn=y;
for i=1:9
    L=uSpd(i+1)-uSpd(i);
    y=logistic(x,L,k,x0)+uSpd(i);
    timeIn=[timeIn;time(i:i+1)+i*10];
    timeIn=[timeIn;timeIn(end)+(1:9)'];
    uSpdIn=[uSpdIn;uSpd(i);y];
end
timeIn=[timeIn;640];
uSpdIn=[uSpdIn;0];
figure
stairs(timeIn,uSpdIn,'k.-')
ylim([0 70])