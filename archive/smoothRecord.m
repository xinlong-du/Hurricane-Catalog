function smoothRecord(uSpdDir,filename)
%% stairs plot
uSpd=uSpdDir(:,1);
uDir=uSpdDir(:,2);
time=0:60:9*60;
time=time';
uSpd=[uSpd;0];
uDir=[uDir;uDir(end)];
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
k=1;
x0=5;
x=0.5:1:9.5;
x=x';
Lspd=uSpd(1);
Ldir=0;
ySpd=logistic(x,Lspd,k,x0);
yDir=logistic(x,Ldir,k,x0);
timeIn=floor(x);
uSpdIn=ySpd;
uDirIn=yDir+uDir(1);
for i=1:9
    Lspd=uSpd(i+1)-uSpd(i);
    Ldir=uDir(i+1)-uDir(i);
    ySpd=logistic(x,Lspd,k,x0)+uSpd(i);
    yDir=logistic(x,Ldir,k,x0)+uDir(i);
    timeIn=[timeIn;time(i:i+1)+i*10];
    timeIn=[timeIn;timeIn(end)+(1:9)'];
    uSpdIn=[uSpdIn;uSpd(i);ySpd];
    uDirIn=[uDirIn;uDir(i);yDir];
end
timeIn=[timeIn;640];
uSpdIn=[uSpdIn;0];
uDirIn=[uDirIn;uDirIn(end)];
%% plot and save
figure
yyaxis left
stairs(timeIn,uSpdIn)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
stairs(timeIn,uDirIn)
ylabel('wind direction (rad)')
ylim([0 2*pi])
fileID=fopen(fullfile('.\smoothRecords',filename),'w');
for i = 1:length(timeIn)
    fprintf(fileID,'%3i %7.4f %7.4f\n',timeIn(i),uSpdIn(i),uDirIn(i));
end
fclose(fileID);