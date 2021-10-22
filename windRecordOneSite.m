function [seleHurrGood,duraGood]=windRecordOneSite(latLoc,lonLoc,spd50y,degTrans)
%% define the location of interest and its properties
% latLoc=42.3601; %Boston
% lonLoc=-71.0589;
% threshold=41.0;

% latLoc=41.776863;    %Transmission tower location 1
% lonLoc=-69.99792;
threshold=spd50y/1.45; %10-min mean wind speed
grad2sea=0.85;       %gradient to sea surface reduction factor (Vickery et al., 2009)
sea2land=0.81;       %sea to land reduction factor for open terrain (the value need to be verified for this location)
% degTrans=0.77;       %the location is about 2km to the sea water
VReduct=grad2sea*(1-(1-sea2land)*degTrans); %wind speed reduction factor

rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));
%% find hurricanes within 250 km of the location
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE3.mat');
NYR=[];
SIM=[];
for i=1:10000
    N=length(hurr10000.NYRSimHur(i).SimHur);
    for j=1:N
        latHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lat;
        lonHurrj=hurr10000.NYRSimHur(i).SimHur(j).Lon;
        [loni,lati]=polyxpoly(lonC,latC,lonHurrj,latHurrj);
        if ~isempty(loni)
            NYR=[NYR;i];
            SIM=[SIM;j];
        end
    end
end
%% calculate wind speed for a location
nSeleHurr=0;
for i=1:length(NYR)
    hurr=hurr10000.NYRSimHur(NYR(i)).SimHur(SIM(i));
    [~,maxVIn,~,tIn,VIn,dirIn,latIn,lonIn]=windRecordlinInterp(hurr,latLoc,lonLoc);
    if maxVIn*VReduct>threshold
        nSeleHurr=nSeleHurr+1;
        seleHurr.NYR=NYR(i);
        seleHurr.SIM=SIM(i);
        seleHurr.tIn=tIn;
        seleHurr.VIn=VIn*VReduct; %consider wind speed reduction
        seleHurr.dirIn=dirIn;
        seleHurr.latIn=latIn;
        seleHurr.lonIn=lonIn;
        seleHurrAll{nSeleHurr}=seleHurr;
    end
end
%% apply 250km limit to the hurricane eye
nSeleHurrGood=0;
duraGood=[];
seleHurrGood={};
nSeleHurrBad=0;
duraBad=[];
seleHurrBad={};
for i=1:length(seleHurrAll)
    plotWind=seleHurrAll{i};
    %find wind records for interpolated hurricane within 250 km
    latHurrIn=plotWind.latIn;
    lonHurrIn=plotWind.lonIn;
    [loni,lati]=polyxpoly(lonC,latC,lonHurrIn,latHurrIn);
    idx=knnsearch([lonHurrIn latHurrIn],[loni lati]);
    idx1=min(idx);
    idx2=max(idx);
    if length(idx)==1
        idx2=length(latHurrIn);
    end
    dura=10.0*seleHurrAll{i}.tIn(idx2)-10.0*seleHurrAll{i}.tIn(idx1)+10.0; %unit=min
    plotWind.tIn250=10*plotWind.tIn(idx1:idx2)-10*plotWind.tIn(idx1); %unit=min
    plotWind.VIn250=plotWind.VIn(idx1:idx2);
    plotWind.dirIn250=plotWind.dirIn(idx1:idx2);
    plotWind.latIn250=plotWind.latIn(idx1:idx2);
    plotWind.lonIn250=plotWind.lonIn(idx1:idx2);
    plotWind.dura250=dura;
    plotWind.VIn250N=plotWind.VIn250.*cos(plotWind.dirIn250); %wind speed in the North direction
    plotWind.VIn250E=plotWind.VIn250.*sin(plotWind.dirIn250); %wind speed in the East direction
    %see if the max VIn250 greater than the threshold
    if max(plotWind.VIn250)>threshold && dura<2400
        nSeleHurrGood=nSeleHurrGood+1;
        duraGood(nSeleHurrGood)=dura;
        seleHurrGood{nSeleHurrGood}=plotWind;
    else
        nSeleHurrBad=nSeleHurrBad+1;
        duraBad(nSeleHurrBad)=dura;
        seleHurrBad{nSeleHurrBad}=plotWind;
    end
end
%% apply thresholding of wind speed
duraGoodThresh=[];
seleHurrGoodThresh={};
for i=1:nSeleHurrGood
    plotWind=seleHurrGood{i};
    idx=find(plotWind.VIn250>threshold);
    dura=plotWind.tIn250(idx(end))-plotWind.tIn250(idx(1))+10.0; %unit=min
    duraGoodThresh(i)=dura;
    plotWind.tInThresh=plotWind.tIn250(idx(1):idx(end))-plotWind.tIn250(idx(1)); %unit=min
    plotWind.VInThresh=plotWind.VIn250(idx(1):idx(end));
    plotWind.dirInThresh=plotWind.dirIn250(idx(1):idx(end));
    plotWind.duraThresh=dura;
    plotWind.VInThreshN=plotWind.VIn250N(idx(1):idx(end)); %wind speed in the North direction
    plotWind.VInThreshE=plotWind.VIn250E(idx(1):idx(end)); %wind speed in the East direction
    seleHurrGoodThresh{i}=plotWind;
end
%{
%% histogram of good duration 
meanDura=mean(duraGood/60.0); %convert to hours
figure
histogram(duraGood/60.0,20,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
title('Duration considering hurricane eyes within 250 km')
figure
histogram(duraGoodThresh/60.0,20,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
title('Duration with applying thresholding of wind speeds')
%% plot good records
for i=1:nSeleHurrGood
    plotWind=seleHurrGood{i};
    plotWindThresh=seleHurrGoodThresh{i};
    figure
    subplot(3,3,1) %whole track
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    
    subplot(3,3,4) %track within 250km
    latlim = [35 45];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'bo')
    
    subplot(3,3,2) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(plotWind.tIn250,plotWind.dirIn250)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Time history with in 250km (Polar)')
    
    subplot(3,3,5) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250N)
    xlabel('time (min)')
    ylabel('wind speed in North (m/s)')
    ylim([-40 40])
    yyaxis right
    plot(plotWind.tIn250,plotWind.VIn250E)
    ylabel('wind speed in East (m/s)')
    ylim([-40 40])
    title('Time history with in 250km (Cartesian)')
    
    subplot(3,3,3) %apply threshold
    yyaxis left
    plot(plotWindThresh.tInThresh,plotWindThresh.VInThresh)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(plotWindThresh.tInThresh,plotWindThresh.dirInThresh)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Applied threshold (Polar)')
    
    subplot(3,3,6) %plot wind speed in North and West direction
    yyaxis left
    plot(plotWindThresh.tInThresh,plotWindThresh.VInThreshN)
    xlabel('time (min)')
    ylabel('wind speed in North (m/s)')
    ylim([-40 40])
    yyaxis right
    plot(plotWindThresh.tInThresh,plotWindThresh.VInThreshE)
    ylabel('wind speed in East (m/s)')
    ylim([-40 40])
    title('Applied threshold (Cartesian)')
    
    %whole time history
    subplot(3,3,7:9)
    yyaxis left
    plot(10*plotWind.tIn,plotWind.VIn)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(10*plotWind.tIn,plotWind.dirIn)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Whole time history (Good)')
end
%% plot bad records
for i=1:nSeleHurrBad
    plotWind=seleHurrBad{i};
    figure
    subplot(3,2,1) %whole track
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    
    subplot(3,2,3) %track within 250km
    latlim = [35 45];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'bo')
    
    subplot(3,2,2) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250)
    xlabel('time (min)')
    ylabel('wind speed (m/s)')
    ylim([0 50])
    yyaxis right
    plot(plotWind.tIn250,plotWind.dirIn250)
    ylabel('wind direction (rad)')
    ylim([0 2*pi])
    title('Time history with in 250km (Polar)')
    
    subplot(3,2,4) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250N)
    xlabel('time (min)')
    ylabel('wind speed in North (m/s)')
    ylim([-40 40])
    yyaxis right
    plot(plotWind.tIn250,plotWind.VIn250E)
    ylabel('wind speed in East (m/s)')
    ylim([-40 40])
    title('Time history with in 250km (Cartesian)')
    
    subplot(3,2,5:6) %whole time history
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
end
%}