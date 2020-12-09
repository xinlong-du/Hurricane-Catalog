clearvars;close all;clc;
rng(1) ;% to ensure reproducibility of the example.
%% load hurrican wind speed and direction records
uSpdDir=load('.\sixHourWindRecords\NYRSimHurV4_NE7_1km.txt');
uSpd=uSpdDir(:,1);
uDir=uSpdDir(:,2)+pi/6;
%curve plot
time=0:60:8*60;
time=time';
figure
yyaxis left
plot(time,uSpd)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
plot(time,uDir)
ylabel('wind direction (rad)')
ylim([0 2*pi])
%stairs plot
figure
time=0:60:9*60;
time=time';
uSpd=[uSpd;0];
uDir=[uDir;0];
yyaxis left
stairs(time,uSpd)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
stairs(time,uDir)
ylabel('wind direction (rad)')
ylim([0 2*pi])
% %% smooth transition of wind speeds and directions
% % time6=0:6:9*60;
% % time6=time6';
% % uSpdIn=interp1q(time',uSpd,time6);
% timeIn=0;
% for i=0:8
%     time1=1:1:4;
%     time2=5:50:55;
%     time3=56:1:59;
%     timeIn=[timeIn,i*60+time1,i*60+time2,i*60+time3];
% end
% timeIn=timeIn';
% uSpdIn=0:uSpd(1)/5:uSpd(1);
% for i=1:8
%     uSpd1=uSpd(i):(uSpd(i+1)-uSpd(i))/10:uSpd(i+1);
%     uSpdIn=[uSpdIn,uSpd1(2:end)];
% end
% uSpd2=uSpd(9):-uSpd(9)/5:0;
% uSpdIn=[uSpdIn,uSpd2(2:end)];
% uSpdIn=uSpdIn';
% figure
% stairs(timeIn,uSpdIn)
% ylim([0 70])
%% smooth use Logistic function
x0=5;
x=x0-5:1:x0+5;
x=x';
L=uSpd(1);
k=1;
y=logistic(x,L,k,x0);
figure
plot(x,y)
timeIn=x(1:end-1);
uSpdIn=y(1:end-1);
for i=1:9
    L=uSpd(i+1)-uSpd(i);
    y=logistic(x,L,k,x0)+uSpd(i);
    figure
    plot(x,y)
    timeIn=[timeIn;time(i:i+1)+i*10];
    timeIn=[timeIn;timeIn(end)+x];
    uSpdIn=[uSpdIn;uSpd(i);uSpd(i);y];
end
figure
stairs(timeIn,uSpdIn)
ylim([0 70])