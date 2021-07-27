clear;clc;
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
%% plot world map
latlim = [10 70];
lonlim = [-110 10];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
%% plot hurricane track
lati1=hurr10000.NYRSimHur(2).SimHur(1).Lat;
long1=hurr10000.NYRSimHur(2).SimHur(1).Lon;
plotm(lati1,long1,'or')

% lati2=hurr10000.NYRSimHur(1).SimHur(2).Lat;
% long2=hurr10000.NYRSimHur(1).SimHur(2).Lon;
% plotm(lati2,long2,'or')
% 
% lati3=hurr10000.NYRSimHur(5).SimHur(2).Lat;
% long3=hurr10000.NYRSimHur(5).SimHur(2).Lon;
% plotm(lati3,long3,'or')
%% generate grid for wind field
i=23;
latiGrid=lati1(i)-10:0.1:lati1(i)+10;
longGrid=long1(i)-10:0.1:long1(i)+10;
V=zeros(201,201);
dir=zeros(201,201);
alpha=zeros(201,201);
f=zeros(201,201);
r=zeros(201,201);
theta=hurr10000.NYRSimHur(2).SimHur(1).HeadDir;
%% calculate parameters
for j=1:201
    for k=1:201
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
Vt=hurr10000.NYRSimHur(2).SimHur(1).Vt_mps;
B=hurr10000.NYRSimHur(2).SimHur(1).B;
dP=hurr10000.NYRSimHur(2).SimHur(1).dP;
rho=1.0;
Rmax=hurr10000.NYRSimHur(2).SimHur(1).Rmax;
%% calculate wind field
for j=1:201
    for k=1:201
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
%%
% for j=1:201
%     for k=1:201
%         V(j,k)=sqrt(...
%             B(i)*dP(i)*100/rho*(Rmax(i)/r(j,k))^B(i)*exp(-(Rmax(i)/r(j,k))^B(i)));
%     end
% end
% figure
% contourf(longGrid,latiGrid,V,'ShowText','on')
% axis equal