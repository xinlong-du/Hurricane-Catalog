clear;clc;
load('.\windRecordsMass\Grid44.mat');
idxDel=[]; % should be 31 for Grid44
for i=1:length(seleHurrGood)
    if seleHurrGood{i}.NYR==1301 && seleHurrGood{i}.SIM==1
        idxDel=i;
    end
end
if ~isempty(idxDel)
    duraGood(idxDel)=[];
    seleHurrGood(idxDel)=[];
end

latLoc=42.7;    %Grid44
lonLoc=-71.5;
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));
%% histogram of good duration 
meanDura=mean(duraGood/60.0); %convert to hours
figure
histogram(duraGood/60.0,10,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
title('Duration considering hurricane eyes within 250 km')
%% plot good records
%[two peak 138 154 165 184 199 192] 
%[one peak 136 152 191 174 171 48 33] 43 32
%[other not typical patterns 137
for i=[183 170 43]%1:length(seleHurrGood)[183 151 190] [183 171 43]
    plotWind=seleHurrGood{i};
    figure
    subplot(2,2,1) %whole track
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    
    subplot(2,2,3) %track within 250km
    latlim = [36 46];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn250,plotWind.lonIn250,'r')
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'bo')
    
    subplot(2,2,2) %time history within 250km
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
    
    subplot(2,2,4) %time history within 250km
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
end