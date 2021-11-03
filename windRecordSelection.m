%% load clusters
fid=fopen('clusterList.txt');
line1=fgetl(fid);
res=line1;
while ischar(line1)
line1=fgetl(fid);
res=char(res,line1);
end
fclose(fid);
for k=1:size(res,1)-1
  clusters{k}=str2num(res(k,:));
end
%% plot clustered hurricane tracks
latLoc=41.776863;    %Transmission tower location 1
lonLoc=-69.99792;
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));

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
%% select wind records from 4 clusters for IDA analysis
nHurrCluster=[length(clusters{1}),length(clusters{2}),length(clusters{3}),length(clusters{4})];
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
%% plot sorted hurricanes (for validation, figures should be the same with those from lines 96-118)
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
%% plot the selected hurricanes
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
%%
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