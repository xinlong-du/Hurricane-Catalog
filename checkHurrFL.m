function [loni,lati]=checkHurrFL(lonc,latc)
florida = shaperead('usastatehi',...
   'UseGeoCoords',true,...
   'Selector',{@(name) strcmpi(name,'Florida'),'Name'});
% usamap('massachusetts')
% geoshow(massachusetts,'FaceColor','none')
% plotm(latc,lonc,'r')

[loni, lati] = polyxpoly(lonc, latc, ...
   florida.Lon',florida.Lat');
% plotm(lati, loni, 'bo')