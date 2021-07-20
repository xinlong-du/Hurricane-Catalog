function [maxV,maxVIn,minDist,tIn,VIn,dirIn]=windRecordlinInterp(hurr,latiLoc,longLoc)
% %% plot world map
% latlim = [10 70];
% lonlim = [-110 10];
% figure
% worldmap(latlim,lonlim)
% load coastlines
% plotm(coastlat,coastlon)
% geoshow(coastlat,coastlon,'color','k')
% hold on
% %% plot hurricane track
lati=hurr.Lat(2:end-1);
long=hurr.Lon(2:end-1);
% plotm(lati1,long1,'or')
%% distance from a location to hurricane eyes
for i=1:length(lati)
    arclenLoc = distance(lati(i),long(i),latiLoc,longLoc);
    rLoc(i)=deg2km(arclenLoc);
end
minDist=min(rLoc);
%% 7 parameters into 6-hour interval
theta=hurr.HeadDir(2:end-1);
Vt=hurr.Vt_mps(2:end-1);
B=hurr.B(2:end-1);
dP=hurr.dP(2:end-1);
Rmax=hurr.Rmax(2:end-1);
rho=1.0;
%% generate wind record for a location
V=zeros(length(B),1);
dir=zeros(length(B),1);
t=(0:36:(length(B)-1)*36)'; %unit of time is 10 min
for i=1:length(B)
    [arclen,az] = distance(lati(i),long(i),latiLoc,longLoc);
    alpha=deg2rad(az-theta(i)); 
    r=deg2km(arclen);
    f=2*7.2921*10^(-5)*sin(deg2rad(latiLoc));
    V(i)=0.5*(Vt(i)*sin(alpha)-f*r)+sqrt(0.25*(Vt(i)*sin(alpha)-f*r)^2+...
            B(i)*dP(i)*100/rho*(Rmax(i)/r)^B(i)*exp(-(Rmax(i)/r)^B(i)));
    dir(i)=deg2rad(az)-pi/2;
    if dir(i)>2*pi
        dir(i)=dir(i)-2*pi;
    elseif dir(i)<0
        dir(i)=dir(i)+2*pi;
    end
end
maxV=max(V);
%% plot wind records
figure
yyaxis left
plot(10*t,V)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
plot(10*t,dir)
ylabel('wind direction (rad)')
ylim([0 2*pi])
%% linear interpolation of 7 parameters into 10 min interval
tIn=(0:1:(length(B)-1)*36)';
latiIn=interp1q(t,lati,tIn);
longIn=interp1q(t,long,tIn);
thetaIn=interp1q(t,theta,tIn);
VtIn=interp1q(t,Vt,tIn);
BIn=interp1q(t,B,tIn);
dPIn=interp1q(t,dP,tIn);
RmaxIn=interp1q(t,Rmax,tIn);
%% generate interpolated wind record for a location
VIn=zeros(length(BIn),1);
dirIn=zeros(length(BIn),1);
for i=1:length(BIn)
    [arclen,az] = distance(latiIn(i),longIn(i),latiLoc,longLoc);
    alpha=deg2rad(az-thetaIn(i)); 
    r=deg2km(arclen);
    f=2*7.2921*10^(-5)*sin(deg2rad(latiLoc));
    VIn(i)=0.5*(VtIn(i)*sin(alpha)-f*r)+sqrt(0.25*(VtIn(i)*sin(alpha)-f*r)^2+...
            BIn(i)*dPIn(i)*100/rho*(RmaxIn(i)/r)^BIn(i)*exp(-(RmaxIn(i)/r)^BIn(i)));
    dirIn(i)=deg2rad(az)-pi/2;
    if dirIn(i)>2*pi
        dirIn(i)=dirIn(i)-2*pi;
    elseif dirIn(i)<0
        dirIn(i)=dirIn(i)+2*pi;
    end
end
maxVIn=max(VIn);
%% plot interpolated wind records
figure
yyaxis left
plot(10*tIn,VIn)
xlabel('time (min)')
ylabel('wind speed (m/s)')
ylim([0 70])
yyaxis right
plot(10*tIn,dirIn)
ylabel('wind direction (rad)')
ylim([0 2*pi])