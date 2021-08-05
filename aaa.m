dura250=[];
for i=1:length(seleHurrAll)
    plotWind=seleHurrAll{i};
    latHurrIn=plotWind.latIn;
    lonHurrIn=plotWind.lonIn;
    [loni,lati]=polyxpoly(lonC,latC,lonHurrIn,latHurrIn);
    idx=knnsearch([lonHurrIn latHurrIn],[loni lati]);
    idx1=min(idx);
    idx2=max(idx);
    if length(idx)==1
        idx2=length(latHurrIn);
    end
    
    dura=10.0*seleHurrAll{i}.tIn(idx2)-10.0*seleHurrAll{i}.tIn(idx1)+10.0; %unit=min
    dura250(i)=dura;
    plotWind.tIn250=10*plotWind.tIn(idx1:idx2)-10*plotWind.tIn(idx1); %unit=min
    plotWind.VIn250=plotWind.VIn(idx1:idx2);
    plotWind.dirIn250=plotWind.dirIn(idx1:idx2);
    plotWind.latIn250=plotWind.latIn(idx1:idx2);
    plotWind.lonIn250=plotWind.lonIn(idx1:idx2);
    plotWind.duration=dura;
    plotWind.VInN=plotWind.VIn250.*cos(plotWind.dirIn250); %wind speed in the North direction
    plotWind.VInW=plotWind.VIn250.*sin(plotWind.dirIn250); %wind speed in the West direction
    seleHurr250{i}=plotWind;
    
    figure
    subplot(1,2,1)
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    
    subplot(1,2,2)
    latlim = [35 45];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn250,plotWind.lonIn250,'r*')
    plotm(latC,lonC,'b')
end