clear;clc;
load('.\windRecordsMass\0MassGrids.mat'); % load grids
GridID=86; %tried 44, 91, 59
latLoc=cenMassLat(GridID);    %Grid coordinates
lonLoc=cenMassLon(GridID);
rad = 250; %radius, consider hurricanes within 250 km of the location
[latC,lonC] = scircle1(latLoc,lonLoc,km2deg(rad));

filename=strcat('.\windRecordsMass\Grid',num2str(GridID),'.mat');
load(filename);
idxDel=[]; % should be 31 for Grid44
for i=1:length(seleHurrGood)
    if seleHurrGood{i}.NYR==1301 && seleHurrGood{i}.SIM==1
        idxDel=i;
    end
end
if ~isempty(idxDel)
    duraGood(idxDel)=[];
    seleHurrGood(idxDel)=[];
end
%% histogram of good duration 
meanDura=mean(duraGood/60.0+2); %convert to hours and consider ramp-up and ramp-down
hfig=figure;
histogram(duraGood/60.0,10,'Normalization','probability','FaceColor','none')
xlabel('Duration (h)','FontSize',8,'FontName','Times New Roman')
ylabel('Probability','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
%title('Duration considering hurricane eyes within 250 km')
% save histogram
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=('.\assets\Fig7.'); %Fig. 8 in the paper
print(hfig,[figname,'tif'],'-r1200','-dtiff');
%% plot good records
% two peak [157,146,142,137,124,99, 84]
%          [450,650,950,600,550,450,1000] duration (min)
% one peak West [162,161,159,156,153,151,148,133,127]
%               [550,550,700,275,650,300,550,550,750]
% one peak East [154,152,132, 130, 85]
%               [550,600,1200,1000,700]
% other not typical patterns [117]
j=3;
for i=[84 151 85]%1:length(seleHurrGood)
    plotWind=seleHurrGood{i};
    
    hfig=figure; %whole track 
    subplot(2,2,1)
    latlim = [10 70];
    lonlim = [-110 10];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn,plotWind.lonIn,'r')
    plotm(latC,lonC,'b')
    title('(a)')
    set(gca,'FontSize',8,'FontName','Times New Roman')
    setm(gca,'FontSize',8,'FontName','Times New Roman')
    
    subplot(2,2,2) %track within 250km
    latlim = [36 46];
    lonlim = [-80 -60];
    worldmap(latlim,lonlim)
    load coastlines
    plotm(coastlat,coastlon)
    geoshow(coastlat,coastlon,'color','k')
    hold on
    plotm(plotWind.latIn250,plotWind.lonIn250,'r')
    plotm(latC,lonC,'b')
    plotm(latLoc,lonLoc,'b.')
    title('(b)')
    set(gca,'FontSize',8,'FontName','Times New Roman')
    setm(gca,'FontSize',8,'FontName','Times New Roman')
    gridm('mlinelocation',5,'MLabelLocation',5,'plinelocation',5,'PLabelLocation',5)
    
    subplot(2,2,3) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250)
    xlabel('Time (min)','FontSize',8,'FontName','Times New Roman')
    ylabel('Wind speed (m/s)','FontSize',8,'FontName','Times New Roman')
    ylim([0 50])
    yyaxis right
    plot(plotWind.tIn250,plotWind.dirIn250,'--')
    ylabel('Wind direction (rad)')
    ylim([0 2*pi])
    if j==4
        legend({'Wind speed','Wind dir.'},'FontSize',8,'FontName','Times New Roman','Location','northeast')
    else
        legend({'Wind speed','Wind dir.'},'FontSize',8,'FontName','Times New Roman','Location','southwest')
    end
    legend('boxoff')
    title('(c)')
    set(gca,'FontSize',8,'FontName','Times New Roman')
    
    subplot(2,2,4) %time history within 250km
    yyaxis left
    plot(plotWind.tIn250,plotWind.VIn250N)
    xlabel('Time (min)','FontSize',8,'FontName','Times New Roman')
    ylabel('Wind speed (m/s)','FontSize',8,'FontName','Times New Roman')
    ylim([-40 40])
    yyaxis right
    plot(plotWind.tIn250,plotWind.VIn250E,'--')
    ylabel('Wind speed (m/s)')
    ylim([-40 40])
    if j==3
        legend({'North dir.','East dir.'},'FontSize',8,'FontName','Times New Roman','Location','west')
    elseif j==4
        legend({'North dir.','East dir.'},'FontSize',8,'FontName','Times New Roman','Location','southeast')
    else
        legend({'North dir.','East dir.'},'FontSize',8,'FontName','Times New Roman','Location','northwest')
    end
    legend('boxoff')
    title('(d)')
    set(gca,'FontSize',8,'FontName','Times New Roman')
    % save histogram
    figWidth=7.6;
    figHeight=5.0;
    set(hfig,'PaperUnits','inches');
    set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
    figname=strcat('.\assets\Fig',num2str(j),'.');
    print(hfig,[figname,'tif'],'-r1200','-dtiff');
    
    j=j+1;
end

%% plot clustered hurricanes
% load clusters
filename=strcat('C:\Users\xinlo\OneDrive - Northeastern University\CRISP\Repositories\Hurricane Catalog\HurricaneClustering\data\windRecordsMass\clusterListGrid',num2str(GridID),'.txt');
fid=fopen(filename);
line1=fgetl(fid);
res=line1;
while ischar(line1)
line1=fgetl(fid);
res=char(res,line1);
end
fclose(fid);
clusters={};
for k=1:size(res,1)-1
  clusters{k}=str2num(res(k,:));
end
nClusters=length(clusters);
PlotHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,seleHurrGood) %plot hurricane tracks

% plot clustered hurricane tracks
function PlotHurrTrackCluster(latLoc,lonLoc,latC,lonC,clusters,seleHurrGood)
for i=1:length(clusters)
hfig=figure;
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
plotm(latLoc,lonLoc,'b.')
setm(gca,'FontSize',8,'FontName','Times New Roman')
gridm('mlinelocation',5,'MLabelLocation',5,'plinelocation',5,'PLabelLocation',5)
% save histogram
figWidth=3.5;
figHeight=2.3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=strcat('.\assets\Fig',num2str(i+14),'(b).');
print(hfig,[figname,'tif'],'-r1200','-dtiff');
end
end