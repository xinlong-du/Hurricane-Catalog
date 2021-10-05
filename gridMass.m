clear;clc;
% figure
% latlim = [35 45];
% lonlim = [-80 -60];
% worldmap(latlim,lonlim)
% load coastlines
% plotm(coastlat,coastlon)
% geoshow(coastlat,coastlon,'color','k')
%% 
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