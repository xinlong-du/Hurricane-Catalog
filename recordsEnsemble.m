clear;clc;
hurr10000=load('NYRSimHurV4_NE4.mat');
%% plot world map
latlim = [10 70];
lonlim = [-110 10];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
%% plot hurricane track
lati1=hurr10000.NYRSimHur(1).SimHur(1).Lat;
long1=hurr10000.NYRSimHur(1).SimHur(1).Lon;
plotm(lati1,long1,'or')
%% exact wind speed records at a location
latiLoc=lati1(3)+0.01;
longLoc=long1(3)+0.01;
arclenLoc = distance(lati1(16),long1(16),latiLoc,longLoc);
rLoc=deg2km(arclenLoc);
theta=hurr10000.NYRSimHur(1).SimHur(1).HeadDir;
Vt=hurr10000.NYRSimHur(1).SimHur(1).Vt_mps;
B=hurr10000.NYRSimHur(1).SimHur(1).B;
dP=hurr10000.NYRSimHur(1).SimHur(1).dP;
rho=1.0;
Rmax=hurr10000.NYRSimHur(1).SimHur(1).Rmax;
V=zeros(6,1);
dir=zeros(6,1);
t=0:5;
for i=1:6
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
figure
plot(6*t,V)
xlabel('time (h)')
ylabel('wind speed (m/s)')
figure
plot(6*t,dir)
xlabel('time (h)')
ylabel('wind direction (rad)')
figure
[AX,H1,H2] = plotyy(6*t,V,6*t,dir,'plot');
set(AX(1),'XColor','k','YColor','b');
set(AX(2),'XColor','k','YColor','r');
HH1=get(AX(1),'Ylabel');
set(HH1,'String','wind speed (m/s)');
set(HH1,'color','b');
HH2=get(AX(2),'Ylabel');
set(HH2,'String','wind direction (rad)');
set(HH2,'color','r');
set(H1,'LineStyle','-');
set(H1,'color','b');
set(H2,'LineStyle','--');
set(H2,'color','r');
legend([H1,H2],{'wind speed records';'wind direction records'});
xlabel('time (t)');
title('Hurricane Wind Records');