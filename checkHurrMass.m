function [loni,lati]=checkHurrMass(lonc,latc)
massachusetts = shaperead('usastatehi',...
   'UseGeoCoords',true,...
   'Selector',{@(name) strcmpi(name,'Massachusetts'),'Name'});
% usamap('massachusetts')
% geoshow(massachusetts,'FaceColor','none')
% plotm(latc,lonc,'r')

[loni, lati] = polyxpoly(lonc, latc, ...
   massachusetts.Lon',massachusetts.Lat');
% plotm(lati, loni, 'bo')