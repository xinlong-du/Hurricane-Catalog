clear;clc;
%% select hurricanes from each cluster
load('.\windRecordsMass\0MassGrids.mat'); % load grids
nClusters=zeros(length(cenMassLon),1);
numHurr=zeros(length(cenMassLon),1);
for i=1:length(cenMassLon)
% coordinates of a grid
latLoc=cenMassLat(i);
lonLoc=cenMassLon(i);
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));
% load clusters
filename=strcat('..\HurricaneClustering\data\windRecordsMass\clusterListSeleGrid',num2str(i),'.txt');
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
nClusters(i)=length(clusters);

% load hurricanes
filename=strcat('.\windRecordsMass\grid',num2str(i),'.mat');
load(filename);
idxDel=[];
for j=1:length(seleHurrGood)
    if seleHurrGood{j}.NYR==1301 && seleHurrGood{j}.SIM==1
        idxDel=j;
    end
end
if ~isempty(idxDel)
    duraGood(idxDel)=[];
    seleHurrGood(idxDel)=[];
end
numHurr(i)=length(seleHurrGood);

duraSeleCluster=[];
for j=1:length(clusters)
    for k=1:length(clusters{j})
        seleHurrCluster{j}{k}=seleHurrGood{clusters{j}(k)};
        duraSeleCluster=[duraSeleCluster;seleHurrGood{clusters{j}(k)}.dura250];
    end
end

filename=strcat('.\windRecordsMass\seleHurrClusterGrid',num2str(i),'.mat');
save(filename,'seleHurrCluster')
%PlotSeleHurr(latLoc,lonLoc,latC,lonC,seleHurrCluster,duraSeleCluster,clusters)
end

%% plot histogram for number of cluesters of all grids
meanNumClusters=mean(nClusters);
hfig=figure;
histogram(nClusters,'FaceColor','none');
set(gca,'XTick',(4:1:8))
set(gca,'FontSize',8,'FontName','Times New Roman')
xlabel('Number of clusters','FontSize',8,'FontName','Times New Roman')
ylabel('Number of grids','FontSize',8,'FontName','Times New Roman')
% save histogram
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=('.\assets\Fig23.');
print(hfig,[figname,'jpg'],'-r1000','-djpeg');

%% plot the selected hurricanes
function PlotSeleHurr(latLoc,lonLoc,latC,lonC,seleHurrCluster,duraSeleCluster,clusters)
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
    for j=1:length(clusters{i})
        plotWind=seleHurrCluster{i}{j};
        plotm(plotWind.latIn250,plotWind.lonIn250,'r')
    end
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'bo')
    
    figure
    subplot(2,1,1) %time history within 250km
    for j=1:length(clusters{i})
        plotWind=seleHurrCluster{i}{j};
        plot(plotWind.tIn250,plotWind.VIn250N)
        xlabel('time (min)')
        ylabel('wind speed in North (m/s)')
        ylim([-40 40])
        hold on
    end
    subplot(2,1,2) %time history within 250km
    for j=1:length(clusters{i})
        plotWind=seleHurrCluster{i}{j};
        plot(plotWind.tIn250,plotWind.VIn250E)
        xlabel('time (min)')
        ylabel('wind speed in East (m/s)')
        ylim([-40 40])
        hold on
    end
end

for i=1:length(clusters)
    for j=1:length(clusters{i})
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