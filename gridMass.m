clear;clc;
%% make grids on Massachusetts
figure
massachusetts = shaperead('usastatehi',...
   'UseGeoCoords',true,...
   'Selector',{@(name) strcmpi(name,'Massachusetts'),'Name'});
latlim = [41 43];
lonlim = [-74 -69];
ax=usamap(latlim,lonlim);
geoshow(massachusetts,'FaceColor','none')
gridm('on');
gridm('mlinelocation',0.2,'plinelocation',0.2,'GColor','k','GLineWidth',1,'GLineStyle',':')
hold on
%% find centroid of each grid
cenLat=41+0.1:0.2:43-0.1;
cenLon=-74+0.1:0.2:-69-0.1;
[cenLatMesh,cenLonMesh]=meshgrid(cenLat,cenLon);
plotm(cenLatMesh,cenLonMesh,'r*')
%% find grids for Massachusetts
lonID=[];
latID=[];
for i=1:length(cenLon)
    for j=1:length(cenLat)
        lonij=cenLonMesh(i,j);
        latij=cenLatMesh(i,j);
        lonGrid=[lonij-0.1,lonij+0.1,lonij+0.1,lonij-0.1,lonij-0.1];
        latGrid=[latij-0.1,latij-0.1,latij+0.1,latij+0.1,latij-0.1];
        in=inpolygon(lonGrid,latGrid,massachusetts.Lon',massachusetts.Lat');
        [lonInter,latiInter] = polyxpoly(lonGrid,latGrid,massachusetts.Lon',massachusetts.Lat');
        if in(1) || in(2) || in(3) || in(4) || ~isempty(lonInter)
        %if ~isempty(lonInter)
            lonID=[lonID;i];
            latID=[latID;j];
        end
    end
end
cenMassLat=zeros(length(lonID),1);
cenMassLon=zeros(length(lonID),1);
for i=1:length(lonID)
    cenMassLat(i)=cenLatMesh(lonID(i),latID(i));
    cenMassLon(i)=cenLonMesh(lonID(i),latID(i));
    plotm(cenMassLat(i),cenMassLon(i),'b*')
end
[arclen,az] = distance(cenMassLat(1),cenMassLon(1),cenMassLat(2),cenMassLon(2));
r=deg2km(arclen); %distance between 1 and 2 is 22.2390km (0.2000rad); distance between 1 and 3 is 16.5008km (0.1484rad)
%% prepare site properties
%50-year MRI
filename = '.\assets\siteProperties.xlsx';
% xlswrite(filename,[cenMassLat,cenMassLon],1,'A2')
siteProp=xlsread(filename);
spd50y=siteProp(:,3); %50-y MRI (m/s)

%degTrans
load coastlines  
coastIndexes = nan(size(cenMassLat));
distFromCoastDeg = nan(size(cenMassLat));
% Find distance and corresponding coastal point  
for i=1:1:numel(cenMassLat)  
    [dist, az] = distance(cenMassLat(i), cenMassLon(i), coastlat, coastlon);
    [distFromCoastDeg(i),coastIndexes(i)] = min(dist);
end
distFromCoastKm=deg2km(distFromCoastDeg);
filename = '.\assets\degTrans3sGust.csv';
degTrans3s=csvread(filename);
filename = '.\assets\degTrans1hAverage.csv';
degTrans1h=csvread(filename);
degTransGrid3s=interp1(degTrans3s(:,1),degTrans3s(:,2),distFromCoastKm*1000);
degTransGrid1h=interp1(degTrans1h(:,1),degTrans1h(:,2),distFromCoastKm*1000);
degTransGrid10min=(degTransGrid3s+degTransGrid1h)/2; %approximate degTrans for 10min mean wind speed
%% calculate wind speeds for each grid
for i=1:length(cenMassLon)
    [seleHurrGood,duraGood]=windRecordOneSite(cenMassLat(i),cenMassLon(i),spd50y(i),degTransGrid10min(i));
    filename=strcat('.\windRecordsMass\grid',num2str(i),'.mat');
    save(filename,'seleHurrGood','duraGood')
end
%% number of hurricanes for each grid
numHurr=zeros(length(cenMassLon),1);
for i=1:length(cenMassLon)
    filename=strcat('.\windRecordsMass\grid',num2str(i),'.mat');
    gridHurr=load(filename);
    numHurr(i)=length(gridHurr.seleHurrGood);
end

meanNumHurr=mean(numHurr);
figure
histogram(numHurr,10);
xlabel('Number of hurricanes')
ylabel('Number of grids')
title('Histogram of number of hurricanes for grids of Massachusetts')