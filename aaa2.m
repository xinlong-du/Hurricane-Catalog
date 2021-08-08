    plotWind=seleHurrAll{i};
    figure
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    
    hurr=hurr10000.NYRSimHur(plotWind.NYR).SimHur(plotWind.SIM);
    latHurrj=hurr.Lat;
    lonHurrj=hurr.Lon;
    plotm(latHurrj,lonHurrj,'ro')
    plotm(latC,lonC,'b')
    
    hurr=hurr10000.NYRSimHur(1).SimHur(1);
    [~,maxVIn,~,tIn,VIn,dirIn,latIn,lonIn]=windRecordlinInterp(hurr,latLoc,lonLoc);