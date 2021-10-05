function windRecord(hurr,hurrName,refEye,dLati,dLong,duration)
%% plot world map
latlim = [10 70];
lonlim = [-110 10];
figure
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
%% plot hurricane track
lati1=hurr.Lat;
long1=hurr.Lon;
plotm(lati1,long1,'or')
%% exact wind speed records at a location
latiLoc=lati1(refEye)+dLati;
longLoc=long1(refEye)+dLong;
arclenLoc = distance(lati1(refEye),long1(refEye),latiLoc,longLoc);
rLoc=deg2km(arclenLoc);
theta=hurr.HeadDir;
Vt=hurr.Vt_mps;
B=hurr.B;
dP=hurr.dP;
rho=1.0;
Rmax=hurr.Rmax;
V=zeros(length(B)-1,1);
dir=zeros(length(B)-1,1);
t=0:length(B)-2;
for i=1:length(B)-1
    [arclen,az] = distance(lati1(i),long1(i),latiLoc,longLoc);
    alpha=deg2rad(az-theta(i+1)); %i+1 consider NaN for the first datum, same for Vt(i+1) 
    r=deg2km(arclen);
    f=2*7.2921*10^(-5)*sin(deg2rad(latiLoc));
    V(i)=0.5*(Vt(i+1)*sin(alpha)-f*r)+sqrt(0.25*(Vt(i+1)*sin(alpha)-f*r)^2+...
            B(i)*dP(i)*100/rho*(Rmax(i)/r)^B(i)*exp(-(Rmax(i)/r)^B(i)));
    dir(i)=deg2rad(az)-pi/2;
    if dir(i)>2*pi
        dir(i)=dir(i)-2*pi;
    elseif dir(i)<0
        dir(i)=dir(i)+2*pi;
    end
end
%% plot wind records
recTime=refEye-(duration-1)/2:refEye+(duration-1)/2;
figure
yyaxis left
plot(6*t(recTime),V(recTime))
xlabel('time (h)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
plot(6*t(recTime),dir(recTime))
ylabel('wind direction (rad)')
ylim([0 2*pi])
%% save wind speed and direction records
filename = sprintf('%25s_%1.0fkm.txt',hurrName,rLoc);
fileID=fopen(fullfile('.\windRecords',filename),'w');
for i = recTime
    fprintf(fileID,'%7.4f %7.4f\n',V(i),dir(i));
end
fclose(fileID);