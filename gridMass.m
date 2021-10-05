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
cenLat=41-0.1:0.2:43-0.1;
cenLon=-74-0.1:0.2:-69-0.1;
[cenLatMesh,cenLonMesh]=meshgrid(cenLat,cenLon);
plotm(cenLatMesh,cenLonMesh,'r*')