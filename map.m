clear;clc;
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
hurr=hurr10000.NYRSimHur(2).SimHur(1);
%% plot world map
figure
latlim = [10 70];
lonlim = [-110 10];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
%% plot hurricane track
lati1=hurr.Lat;
long1=hurr.Lon;
plotm(lati1,long1,'or')
%% generate grid for wind field
i=23;
nGrid=101;
latiGrid=lati1(i)-5:0.1:lati1(i)+5;
longGrid=long1(i)-5:0.1:long1(i)+5;
V=zeros(nGrid,nGrid);
dir=zeros(nGrid,nGrid);
alpha=zeros(nGrid,nGrid);
f=zeros(nGrid,nGrid);
r=zeros(nGrid,nGrid);
theta=hurr10000.NYRSimHur(2).SimHur(1).HeadDir;
%% calculate parameters
for j=1:nGrid
    for k=1:nGrid
        %az = azimuth(lati1(i),long1(i),latiGrid(j),longGrid(k));
        [arclen,az] = distance(lati1(i),long1(i),latiGrid(j),longGrid(k));
        alpha(j,k)=deg2rad(az-theta(i)); 
        r(j,k)=deg2km(arclen);
        %r(j,k)=arclen;
        f(j,k)=2*7.2921*10^(-5)*sin(deg2rad(latiGrid(j)));
        dir(j,k)=deg2rad(az)-pi/2;
        if dir(j,k)>2*pi
            dir(j,k)=dir(j,k)-2*pi;
        elseif dir(j,k)<0
            dir(j,k)=dir(j,k)+2*pi;
        end
    end
end
Vt=hurr.Vt_mps;
B=hurr.B;
dP=hurr.dP;
rho=1.225; %air density TBD. Georgiou(1985) used 1.0, But 1.225 is more accurate (the coutour is steeper means duration is shorter?)
Rmax=hurr.Rmax;
%% calculate wind field
for j=1:nGrid
    for k=1:nGrid
        V(j,k)=0.5*(Vt(i)*sin(alpha(j,k))-f(j,k)*r(j,k))+sqrt(0.25*(Vt(i)*sin(alpha(j,k))-f(j,k)*r(j,k))^2+...
            B(i)*dP(i)*100/rho*(Rmax(i)/r(j,k))^B(i)*exp(-(Rmax(i)/r(j,k))^B(i)));
    end
end
%% plot wind field
figure
contourf(longGrid,latiGrid,V,'ShowText','on')
axis equal
hold on
quiver(longGrid,latiGrid,sin(dir),cos(dir))