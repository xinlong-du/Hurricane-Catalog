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
%% calculate wind speed for a location
latiLoc=42.3601; %Boston
longLoc=-71.0589;
threshold=41.0;
% latiLoc=28.5383; %Orlando
% longLoc=-81.3792;
nSeleHurr=0;
for i=1:nHurr
    hurr=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i));
    [maxV,maxVIn,minDist,tIn,VIn,dirIn]=windRecordlinInterp(hurr,latiLoc,longLoc);
    if maxVIn>threshold
        nSeleHurr=nSeleHurr+1;
        seleHurr.NYR=NYR(i);
        seleHurr.SIM=SIM(i);
        seleHurr.tIn=tIn;
        seleHurr.VIn=VIn;
        seleHurr.dirIn=dirIn;
        seleHurrAll{nSeleHurr}=seleHurr;
    end
end
%% plot interpolated wind records
for i=1:nSeleHurr
    plotWind=seleHurrAll{i};
    figure
    yyaxis left
    plot(10*plotWind.tIn,plotWind.VIn)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 70])
    yyaxis right
    plot(10*plotWind.tIn,plotWind.dirIn)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
end
%% find the wind > threshold
duration=zeros(nSeleHurr,1);
for i=1:nSeleHurr
    plotWind=seleHurrAll{i};
    idx=find(plotWind.VIn>threshold);
    duration(i)=10*plotWind.tIn(idx(end))-10*plotWind.tIn(idx(1));
    figure
    yyaxis left
    plot(10*plotWind.tIn(idx(1):idx(end)),plotWind.VIn(idx(1):idx(end)))
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 70])
    yyaxis right
    plot(10*plotWind.tIn(idx(1):idx(end)),plotWind.dirIn(idx(1):idx(end)))
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
end
idx=find(duration<1000 & duration>0);
duration=duration(idx);
duration=duration/60;
meanDura=mean(duration);
figure
histogram(duration,20,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')