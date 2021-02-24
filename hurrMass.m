clear;clc;
%% find hurricanes pass Massachusetts
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
nHurr=0;
NYR=[];
SIM=[];
for i=1:10000
    N=length(hurr10000.NYRSimHur(i).SimHur);
    for j=1:N
        latc=hurr10000.NYRSimHur(i).SimHur(j).Lat;
        lonc=hurr10000.NYRSimHur(i).SimHur(j).Lon;
        [loni,lati]=checkHurrMass(lonc,latc);
        if ~isempty(loni)
            nHurr=nHurr+1;
            NYR=[NYR;i];
            SIM=[SIM;j];
        end
    end
end
%% plot the selected hurricanes
    figure
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
for i=1:nHurr
    lati1=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i)).Lat;
    long1=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i)).Lon;
    plotm(lati1,long1,'r')
end