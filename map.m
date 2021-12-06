clear;clc;
%% hurricane parameters
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE3.mat');
hurr=hurr10000.NYRSimHur(100).SimHur(6);
lati1=hurr.Lat;
long1=hurr.Lon;
theta=hurr.HeadDir; %clockwise positive from North for hurricane heading
Vt=hurr.Vt_mps;
B=hurr.B;
dP=hurr.dP;
Rmax=hurr.Rmax;
rho=1.112; %air density TBD. Georgiou(1985) used 1.0. Here use 1.112 for 1000 m height.
%% plot world map and hurricane track
figure
latlim = [10 70];
lonlim = [-110 10];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
plotm(lati1,long1,'or')
%% generate grid for wind field
i=25; %time for the hurricane wind field
nLatiGrid=101;
nLongGrid=51;
latiGrid=lati1(i)-5:0.1:lati1(i)+5;
longGrid=long1(i)-5:0.2:long1(i)+5;
V=zeros(nLatiGrid,nLongGrid);
dir=zeros(nLatiGrid,nLongGrid);
alpha=zeros(nLatiGrid,nLongGrid);
f=zeros(nLatiGrid,nLongGrid);
r=zeros(nLatiGrid,nLongGrid);
%% calculate wind field
for j=1:nLatiGrid
    for k=1:nLongGrid
        %az = azimuth(lati1(i),long1(i),latiGrid(j),longGrid(k));
        [arclen,az] = distance(lati1(i),long1(i),latiGrid(j),longGrid(k)); %clockwise positive from North for azimuth
        alpha(j,k)=deg2rad(az-theta(i)); 
        r(j,k)=deg2km(arclen);
        %r(j,k)=arclen;
        f(j,k)=2*7.2921*10^(-5)*sin(deg2rad(latiGrid(j)));
        dir(j,k)=deg2rad(az)-pi/2; %clockwise positive from North for wind direction
        if dir(j,k)>2*pi
            dir(j,k)=dir(j,k)-2*pi;
        elseif dir(j,k)<0
            dir(j,k)=dir(j,k)+2*pi;
        end
        V(j,k)=0.5*(Vt(i)*sin(alpha(j,k))-f(j,k)*r(j,k))+sqrt(0.25*(Vt(i)*sin(alpha(j,k))-f(j,k)*r(j,k))^2+...
            B(i)*dP(i)*100/rho*(Rmax(i)/r(j,k))^B(i)*exp(-(Rmax(i)/r(j,k))^B(i)));    
    end
end
%% plot wind field
hfig=figure;
[C,h]=contourf(longGrid,latiGrid,V,0:5:60,'ShowText','on');
clabel(C,h,'FontSize',8);
axis equal
xlabel('Longitude','FontSize',8)
ylabel('Latitude','FontSize',8)
set(gca,'FontSize',8)
% hold on
% quiver(longGrid,latiGrid,sin(dir),cos(dir))

% check wind directions
dirDeg=rad2deg(dir);

% save histogram
figWidth=3.5;
figHeight=3.5;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=('.\assets\Fig2.'); %Fig. 2 in the paper
print(hfig,[figname,'jpg'],'-r350','-djpeg');

%% plot hurricane tracks
hfig=figure;
latlim = [10 70];
lonlim = [-110 10];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for i=1:3
    N=length(hurr10000.NYRSimHur(i).SimHur);
    for j=1:N
        latHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lat;
        lonHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lon;
        plotm(latHurrj,lonHurrj,'r')
    end
end
setm(gca,'FontSize',8)
% save histogram
figWidth=3.5;
figHeight=2.5;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=('.\assets\Fig1.'); %Fig. 1 in the paper
print(hfig,[figname,'jpg'],'-r350','-djpeg');