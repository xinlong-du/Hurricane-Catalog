clear;clc;
NE1_NYR1_Sim1_0km=load('.\windRecords\NYRSimHurV4_NE1_NYR1_Sim1_0km.txt');
uSpdDir=NE1_NYR1_Sim1_0km;
%% stairs plot
uSpd=uSpdDir(:,1);
uDir=uSpdDir(:,2);
time=(0:6:9*6)';
uSpd=[uSpd;0];
uDir=[uDir;uDir(end)];
figure
yyaxis left
stairs(time,uSpd)
xlabel('time (h)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
stairs(time,uDir)
ylabel('wind direction (rad)')
ylim([0 2*pi])
xticks(0:6:54)
%% stairs plot after linear interpolation
uSpd=uSpdDir(:,1);
uDir=uSpdDir(:,2);
uSpd=[0;uSpd];
uDir=[uDir(1);uDir];
time=(0:6:9*6)';
timeIn=(0:1:9*6)';
uSpdIn=interp1q(time,uSpd,timeIn);
uDirIn=interp1q(time,uDir,timeIn);
uSpdIn=[uSpdIn(2:end);0];
uDirIn=[uDirIn(2:end);uDirIn(end)];
figure
yyaxis left
stairs(timeIn,uSpdIn)
xlabel('time (h)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
stairs(timeIn,uDirIn)
ylabel('wind direction (rad)')
ylim([0 2*pi])
xticks(0:6:54)