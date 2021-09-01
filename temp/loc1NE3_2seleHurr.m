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
%% plot clustered hurricane tracks
cluster1=load('cluster1.txt');
cluster2=load('cluster2.txt');
cluster3=load('cluster3.txt');
cluster4=load('cluster4.txt');

latLoc=41.776863;    %Transmission tower location 1
lonLoc=-69.99792;
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));

figure
latlim = [35 45];
lonlim = [-80 -60];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for i=1:length(cluster1)
    idxHurr=cluster1(i);
    plotWind=seleHurrGood{idxHurr};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'bo')

figure
latlim = [35 45];
lonlim = [-80 -60];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for i=1:length(cluster2)
    idxHurr=cluster2(i);
    plotWind=seleHurrGood{idxHurr};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'bo')

figure
latlim = [35 45];
lonlim = [-80 -60];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for i=1:length(cluster3)
    idxHurr=cluster3(i);
    plotWind=seleHurrGood{idxHurr};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'bo')

figure
latlim = [35 45];
lonlim = [-80 -60];
worldmap(latlim,lonlim)
load coastlines
plotm(coastlat,coastlon)
geoshow(coastlat,coastlon,'color','k')
hold on
for i=1:length(cluster4)
    idxHurr=cluster4(i);
    plotWind=seleHurrGood{idxHurr};
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
end
plotm(latC,lonC,'b')
plotm(latLoc,lonLoc,'bo')