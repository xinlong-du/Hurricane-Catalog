clear;clc;
load('loc1NE3-2seleHurrGood.mat');
load('loc1NE3-2duraGood.mat');
[maxDura,idx]=max(duraGood);
%% 1D wind with zero padding at the end
windRecords=zeros(maxDura/10+1,length(seleHurrGood));
windRecords(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250);
    windRecords(2:numP+1,i)=seleHurrGood{i}.VIn250;
end
%save('windRecords.txt', windRecords, '-double', '-tab')
dlmwrite('windRecords.txt',windRecords,'delimiter','\t')
%% 1D wind with zero padding at the beginning and the end
% seleHurrGood(idx)=[];
% duraGood(idx)=[];
% [maxDura,idx]=max(duraGood);
windRecords2=zeros(maxDura/10+1,length(seleHurrGood));
windRecords2(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250);
    mid=round(maxDura/10/2)+1;
    if rem(numP,2)==0
        windRecords2(mid-numP/2+1:mid+numP/2,i)=seleHurrGood{i}.VIn250;
    else
        windRecords2(mid-(numP/2-0.5):mid+(numP/2-0.5),i)=seleHurrGood{i}.VIn250;
    end
end
dlmwrite('windRecords2.txt',windRecords2,'delimiter','\t')
%% 2D wind with zero padding at the beginning and the end
seleHurrGood(idx)=[];
duraGood(idx)=[];
[maxDura,idx]=max(duraGood);
windRecords2D=zeros(maxDura/10+1,length(seleHurrGood)*2);
windRecords2D(1,1:2:end-1)=1:length(seleHurrGood);
windRecords2D(1,2:2:end)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250N);
    mid=round(maxDura/10/2)+1;
    if rem(numP,2)==0
        windRecords2D(mid-numP/2+1:mid+numP/2,2*i-1)=seleHurrGood{i}.VIn250N;
        windRecords2D(mid-numP/2+1:mid+numP/2,2*i)=seleHurrGood{i}.VIn250E;
    else
        windRecords2D(mid-(numP/2-0.5):mid+(numP/2-0.5),2*i-1)=seleHurrGood{i}.VIn250N;
        windRecords2D(mid-(numP/2-0.5):mid+(numP/2-0.5),2*i)=seleHurrGood{i}.VIn250E;
    end
end
dlmwrite('windRecords2D.txt',windRecords2D,'delimiter','\t')
%% flatten 2D wind to 1D
windRecords2Dto1D=zeros(maxDura/10*2+1,length(seleHurrGood));
windRecords2Dto1D(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250N);
    mid=round(maxDura/10/2)+1;
    if rem(numP,2)==0
        windRecords2Dto1D(mid-numP/2+1:mid+numP/2,i)=seleHurrGood{i}.VIn250N;
        windRecords2Dto1D(mid-numP/2+1+142:mid+numP/2+142,i)=seleHurrGood{i}.VIn250E;
    else
        windRecords2Dto1D(mid-(numP/2-0.5):mid+(numP/2-0.5),i)=seleHurrGood{i}.VIn250N;
        windRecords2Dto1D(mid-(numP/2-0.5)+142:mid+(numP/2-0.5)+142,i)=seleHurrGood{i}.VIn250E;
    end
end
dlmwrite('windRecords2Dto1D.txt',windRecords2Dto1D,'delimiter','\t')
%% flatten 2D wind to 1D and add ramp-up and ramp-down
windRecords2Dto1Dramp=zeros(maxDura/10*2+1+24,length(seleHurrGood));
windRecords2Dto1Dramp(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250N)+12;
    mid1=round(maxDura/10/2)+1+6;
    mid2=mid1+maxDura/10+12;
    windN=seleHurrGood{i}.VIn250N;
    windE=seleHurrGood{i}.VIn250E;
    windNramp=[(windN(1)/7:windN(1)/7:windN(1)/7*6)';windN;(windN(end)/7*6:-windN(end)/7:windN(end)/7)'];
    windEramp=[(windE(1)/7:windE(1)/7:windE(1)/7*6)';windE;(windE(end)/7*6:-windE(end)/7:windE(end)/7)'];
    if rem(numP,2)==0
        windRecords2Dto1Dramp(mid1-numP/2+1:mid1+numP/2,i)=windNramp;
        windRecords2Dto1Dramp(mid2-numP/2+1:mid2+numP/2,i)=windEramp;
    else
        windRecords2Dto1Dramp(mid1-(numP/2-0.5):mid1+(numP/2-0.5),i)=windNramp;
        windRecords2Dto1Dramp(mid2-(numP/2-0.5):mid2+(numP/2-0.5),i)=windEramp;
    end
end
dlmwrite('windRecords2Dto1Dramp.txt',windRecords2Dto1Dramp,'delimiter','\t')
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