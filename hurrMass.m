clear;clc;
%%
hurr10000=load('.\syntheticHurricanes\NYRSimHurV4_NE1.mat');
latc=hurr10000.NYRSimHur(2).SimHur(1).Lat;
lonc=hurr10000.NYRSimHur(2).SimHur(1).Lon-17;
%%
massachusetts = shaperead('usastatehi',...
   'UseGeoCoords',true,...
   'Selector',{@(name) strcmpi(name,'Massachusetts'),'Name'});
usamap('massachusetts')
geoshow(massachusetts,'FaceColor','none')
plotm(latc,lonc,'r')
% lat0 = 42;
% lon0 = -72;
% rad = 50;
% [latc,lonc] = scircle1(lat0,lon0,km2deg(rad));
% plotm(lat0,lon0,'r*')
% plotm(latc,lonc,'r')

[loni, lati] = polyxpoly(lonc, latc, ...
   massachusetts.Lon',massachusetts.Lat');
plotm(lati, loni, 'bo')