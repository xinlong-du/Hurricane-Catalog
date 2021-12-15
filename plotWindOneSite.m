clear;clc;
load('.\windRecordsMass\0MassGrids.mat'); % load grids
GridID=86; %tried 44, 91, 59
latLoc=cenMassLat(GridID);    %Grid coordinates
lonLoc=cenMassLon(GridID);
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));

filename=strcat('.\windRecordsMass\Grid',num2str(GridID),'.mat');
load(filename);
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
%% histogram of good duration 
meanDura=mean(duraGood/60.0); %convert to hours
figure
histogram(duraGood/60.0,10,'Normalization','probability')
xlabel('Duration (h)')
ylabel('Probability')
title('Duration considering hurricane eyes within 250 km')

%% plot good records
% two peak [157,146,142,137,124,99, 84]
%          [450,650,950,600,550,450,1000] duration (min)
% one peak West [162,161,159,156,153,151,148,133,127]
%               [550,550,700,275,650,300,550,550,750]
% one peak East [154,152,132, 130, 85]
%               [550,600,1200,1000,700]
% other not typical patterns [117]
for i=[84 151 85]%1:length(seleHurrGood)
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
    plotm(latLoc,lonLoc,'b.')
    
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

%% plot clustered hurricanes
% load clusters
filename=strcat('C:\Users\xinlo\OneDrive - Northeastern University\CRISP\Repositories\Hurricane Catalog\HurricaneClustering\data\windRecordsMass\clusterListGrid',num2str(GridID),'.txt');
fid=fopen(filename);
line1=fgetl(fid);
res=line1;
while ischar(line1)
line1=fgetl(fid);
res=char(res,line1);
end
fclose(fid);
clusters={};
for k=1:size(res,1)-1
  clusters{k}=str2num(res(k,:));
end
nClusters=length(clusters);
PlotHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,seleHurrGood) %plot hurricane tracks

% plot clustered hurricane tracks
function PlotHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,seleHurrGood)
for i=1:length(clusters)
figure
latlim = [35 45];
lonlim = [-80 -60];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for j=1:length(clusters{i})
    idxHurr=clusters{i}(j);
    plotWind=seleHurrGood{idxHurr};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'b.')
end
end