clear;clc;
%% select hurricanes from each cluster
load('.\windRecordsMass\0MassGrids.mat'); % load grids
for i=1:length(cenMassLon)
% coordinates of a grid
latLoc=cenMassLat(i);
lonLoc=cenMassLon(i);
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));
% load clusters
filename=strcat('.\windRecordsMass\clusterListGrid',num2str(i),'.txt');
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

% load hurricanes
filename=strcat('.\windRecordsMass\grid',num2str(i),'.mat');
gridHurr=load(filename);

PlotHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,gridHurr.seleHurrGood) %plot hurricane tracks
[seleHurrCluster,sortedHurrCluster,duraSeleCluster,nSeleHurrCluster]=SeleHurrCluster(clusters,gridHurr.seleHurrGood);
filename=strcat('.\windRecordsMass\seleHurrClusterGrid',num2str(i),'.mat');
save(filename,'seleHurrCluster')
PlotSortedHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,sortedHurrCluster)
PlotSeleHurr(latLoc,lonLoc,latC,lonC,duraSeleCluster,clusters,nSeleHurrCluster,seleHurrCluster)
end
%% plot clustered hurricane tracks
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
plotm(latLoc,lonLoc,'bo')
end
end
%% select wind records from each cluster for IDA analysis
function [seleHurrCluster,sortedHurrCluster,duraSeleCluster,nSeleHurrCluster]=SeleHurrCluster(clusters,seleHurrGood)
nHurrCluster=zeros(1,length(clusters));
for i=1:length(clusters)
    nHurrCluster(i)=length(clusters{i});
end
nSeleHurrCluster=round(nHurrCluster/10);
duraCluster={};
HurrCluster={};
duraSeleCluster=[];
for i=1:length(clusters)
    for j=1:length(clusters{i})
        HurrCluster{i}{j}=seleHurrGood{clusters{i}(j)};
        duraCluster{i}(j)=seleHurrGood{clusters{i}(j)}.dura250;
    end
    [dura,idx]=sort(duraCluster{i});
    sortedHurrCluster{i}=HurrCluster{i}(idx); %sort the hurricanes by duration
    seleHurrCluster{i}=sortedHurrCluster{i}(1:nSeleHurrCluster(i));
    duraSeleCluster=[duraSeleCluster,dura(1:nSeleHurrCluster(i))];
end
end
%% plot sorted hurricanes (for validation, figures should be the same with previous ones)
function PlotSortedHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,sortedHurrCluster)
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
    plotWind=sortedHurrCluster{i}{j};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'bo')
end
end
%% plot the selected hurricanes
function PlotSeleHurr(latLoc,lonLoc,latC,lonC,duraSeleCluster,clusters,nSeleHurrCluster,seleHurrCluster)
figure
histogram(duraSeleCluster/60.0,15)
xlabel('Duration (h)')
ylabel('Number of hurricanes')
title('Duration considering hurricane eyes within 250 km')

for i=1:length(clusters)
    figure
    latlim = [35 45];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    for j=1:nSeleHurrCluster(i)
        plotWind=seleHurrCluster{i}{j};
        plotm(plotWind.latIn250,plotWind.lonIn250,'r')
    end
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'bo')
    
    figure
    subplot(2,1,1) %time history within 250km
    for j=1:nSeleHurrCluster(i)
        plotWind=seleHurrCluster{i}{j};
        plot(plotWind.tIn250,plotWind.VIn250N)
        xlabel('time (min)')
        ylabel('wind speed in North (m/s)')
        ylim([-40 40])
        hold on
    end
    subplot(2,1,2) %time history within 250km
    for j=1:nSeleHurrCluster(i)
        plotWind=seleHurrCluster{i}{j};
        plot(plotWind.tIn250,plotWind.VIn250E)
        xlabel('time (min)')
        ylabel('wind speed in East (m/s)')
        ylim([-40 40])
        hold on
    end
end

for i=1:length(clusters)
    for j=1:nSeleHurrCluster(i)
        plotWind=seleHurrCluster{i}{j};
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
        latlim = [35 45];
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
        
%         %whole time history
%         subplot(3,2,5:6)
%         yyaxis left
%         plot(10*plotWind.tIn,plotWind.VIn)
%         xlabel('time (min)')
%         ylabel('wind speed (m/s)')
%         ylim([0 50])
%         yyaxis right
%         plot(10*plotWind.tIn,plotWind.dirIn)
%         ylabel('wind direction (rad)')
%         ylim([0 2*pi])
%         title('Whole time history (Good)')
    end
end
end