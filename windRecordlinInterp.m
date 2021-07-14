clear;clc;
NYRSimHurV4_NE1=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
%% hurricane NYRSimHurV4_NE1_NYR1_Sim1
NYR=1;
Sim=1;
hurr=NYRSimHurV4_NE1.NYRSimHur(NYR).SimHur(Sim);
hurrName=sprintf('NYRSimHurV4_NE1_NYR%1i_Sim%1i',NYR,Sim);
refEye=16;
dLati=-0.9;
dLong=-1.12;
duration=9;
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
lati1=hurr.Lat(2:end-1);
long1=hurr.Lon(2:end-1);
plotm(lati1,long1,'or')
%% exact wind speed records at a location
latiLoc=lati1(refEye)+dLati;
longLoc=long1(refEye)+dLong;
arclenLoc = distance(lati1(refEye),long1(refEye),latiLoc,longLoc);
rLoc=deg2km(arclenLoc);
%% 7 parameters into 6-hour interval
theta=hurr.HeadDir(2:end-1);
Vt=hurr.Vt_mps(2:end-1);
B=hurr.B(2:end-1);
dP=hurr.dP(2:end-1);
Rmax=hurr.Rmax(2:end-1);
rho=1.0;
time=(0:36:49*36)';
timeIn=(0:1:49*36)';
lati1In=interp1q(time,lati1,timeIn);
long1In=interp1q(time,long1,timeIn);
thetaIn=interp1q(time,theta,timeIn);
VtIn=interp1q(time,Vt,timeIn);
BIn=interp1q(time,B,timeIn);
dPIn=interp1q(time,dP,timeIn);
RmaxIn=interp1q(time,Rmax,timeIn);
%% generate interpolated wind record for a location
VIn=zeros(length(BIn)-1,1);
dirIn=zeros(length(BIn)-1,1);
tIn=0:length(BIn)-2;
for i=1:length(BIn)-1
    [arclen,az] = distance(lati1In(i),long1In(i),latiLoc,longLoc);
    alpha=deg2rad(az-thetaIn(i+1)); %i+1 consider NaN for the first datum, same for Vt(i+1) 
    r=deg2km(arclen);
    f=2*7.2921*10^(-5)*sin(deg2rad(latiLoc));
    VIn(i)=0.5*(VtIn(i+1)*sin(alpha)-f*r)+sqrt(0.25*(VtIn(i+1)*sin(alpha)-f*r)^2+...
            BIn(i)*dPIn(i)*100/rho*(RmaxIn(i)/r)^BIn(i)*exp(-(RmaxIn(i)/r)^BIn(i)));
    dirIn(i)=deg2rad(az)-pi/2;
    if dirIn(i)>2*pi
        dirIn(i)=dirIn(i)-2*pi;
    elseif dirIn(i)<0
        dirIn(i)=dirIn(i)+2*pi;
    end
end
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

% recTime=(refEye-(duration-1)/2)*36:(refEye+(duration-1)/2)*36;
% figure
% yyaxis left
% plot(10*tIn(recTime),VIn(recTime))
% xlabel('time (min)')
% ylabel('wind speed (m/s)')
% ylim([0 70])
% yyaxis right
% plot(10*tIn(recTime),dirIn(recTime))
% ylabel('wind direction (rad)')
% ylim([0 2*pi])