clear;clc;
%% define the location of interest and its properties
% latLoc=42.3601; %Boston
% lonLoc=-71.0589;
% threshold=41.0;

latLoc=41.776863;   %Transmission tower location 1
lonLoc=-69.99792;
threshold=47.0/1.45; %10-min mean wind speed
grad2sea=0.85;       %gradient to sea surface reduction factor
sea2land=0.81;       %sea to land reduction factor for open terrain (the value need to be verified for this location)
degTrans=0.8;        %the location is about 2km to the sea water
VReduct=grad2sea*(1-(1-sea2land)*degTrans); %wind speed reduction factor

rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));
massachusetts = shaperead('usastatehi',...
   'UseGeoCoords',true,...
   'Selector',{@(name) strcmpi(name,'Massachusetts'),'Name'});
usamap('massachusetts')
geoshow(massachusetts,'FaceColor','none')
plotm(latLoc,lonLoc,'r*')
plotm(latC,lonC,'r')
%% find hurricanes within 250 km of the location
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
nHurr=0;
NYR=[];
SIM=[];
for i=1:10000
    N=length(hurr10000.NYRSimHur(i).SimHur);
    for j=1:N
        latHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lat;
        lonHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lon;
        [loni,lati]=polyxpoly(lonC,latC,lonHurrj,latHurrj);
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
    latHurr=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i)).Lat;
    lonHurr=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i)).Lon;
    plotm(latHurr,lonHurr,'r')
end
plotm(latC,lonC,'b')
%% calculate wind speed for a location
nSeleHurr=0;
for i=1:nHurr
    hurr=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i));
    [maxV,maxVIn,minDist,tIn,VIn,dirIn]=windRecordlinInterp(hurr,latLoc,lonLoc);
    if maxVIn*VReduct>threshold
        nSeleHurr=nSeleHurr+1;
        seleHurr.NYR=NYR(i);
        seleHurr.SIM=SIM(i);
        seleHurr.tIn=tIn;
        seleHurr.VIn=VIn*VReduct; %consider wind speed reduction
        seleHurr.dirIn=dirIn;
        seleHurrAll{nSeleHurr}=seleHurr;
    end
end
%% find the wind > threshold
nSeleHurrGood=0;
duraGood=[];
seleHurrGood={};
nSeleHurrBad=0;
duraBad=[];
seleHurrBad={};
for i=1:nSeleHurr
    plotWind=seleHurrAll{i};
    idx=find(plotWind.VIn>threshold);
    dura=10.0*plotWind.tIn(idx(end))-10.0*plotWind.tIn(idx(1))+10.0; %unit=min
    if dura>0 && dura<1200
        nSeleHurrGood=nSeleHurrGood+1;
        duraGood(nSeleHurrGood)=dura;
        plotWind.tInThresh=10*plotWind.tIn(idx(1):idx(end))-10*plotWind.tIn(idx(1)); %unit=min
        plotWind.VInThresh=plotWind.VIn(idx(1):idx(end));
        plotWind.dirInThresh=plotWind.dirIn(idx(1):idx(end));
        plotWind.duration=dura;
        seleHurrGood{nSeleHurrGood}=plotWind;
    else
        nSeleHurrBad=nSeleHurrBad+1;
        duraBad(nSeleHurrBad)=dura;
        plotWind.tInThresh=10*plotWind.tIn(idx(1):idx(end))-10*plotWind.tIn(idx(1)); %unit=min
        plotWind.VInThresh=plotWind.VIn(idx(1):idx(end));
        plotWind.dirInThresh=plotWind.dirIn(idx(1):idx(end));
        plotWind.duration=dura;
        seleHurrBad{nSeleHurrBad}=plotWind;
    end
end
%% histogram of good duration 
meanDura=mean(duraGood/60.0); %convert to hours
figure
histogram(duraGood/60.0,20,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
%% plot good records
for i=1:nSeleHurrGood
    plotWind=seleHurrGood{i};
    %whole time history
    figure
    yyaxis left
    plot(10*plotWind.tIn,plotWind.VIn)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(10*plotWind.tIn,plotWind.dirIn)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Whole time history')
    %apply threshold
    figure
    yyaxis left
    plot(plotWind.tInThresh,plotWind.VInThresh)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(plotWind.tInThresh,plotWind.dirInThresh)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Applied threshold')
end
%% plot bad records
for i=1:nSeleHurrBad
    plotWind=seleHurrBad{i};
    %whole time history
    figure
    yyaxis left
    plot(10*plotWind.tIn,plotWind.VIn)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(10*plotWind.tIn,plotWind.dirIn)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Whole time history (Bad)')
    %apply threshold
    figure
    yyaxis left
    plot(plotWind.tInThresh,plotWind.VInThresh)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(plotWind.tInThresh,plotWind.dirInThresh)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Applied threshold (Bad)')
end