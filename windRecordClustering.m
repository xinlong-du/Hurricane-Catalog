clear;clc;
%% load hurricanes for each grid
numHurr=zeros(92,1);
for j=1:92
filename=strcat('.\windRecordsMass\grid',num2str(j),'.mat');
load(filename);

idxDel=[];
for i=1:length(seleHurrGood)
    if seleHurrGood{i}.NYR==1301 && seleHurrGood{i}.SIM==1
        idxDel=i;
    end
end
if ~isempty(idxDel)
    duraGood(idxDel)=[];
    seleHurrGood(idxDel)=[];
end
numHurr(j)=length(seleHurrGood);

% [maxDura,idx]=max(duraGood);
% [windRecords2Dto1Dramp]=flatten2Dto1Dramp(seleHurrGood,maxDura);
% filename=strcat('.\windRecordsMass\windRecords2Dto1DrampGrid',num2str(j),'.txt');
% dlmwrite(filename,windRecords2Dto1Dramp,'delimiter','\t')
% 
% % save hurricane IDs
% [nRow,nCol]=size(windRecords2Dto1Dramp);
% filename=strcat('.\windRecordsMass\hurricaneIDsGrid',num2str(j),'.txt');
% dlmwrite(filename,(1:nCol)')
% plot wind records
% nStep=(nRow-1)/2;
% hfig=figure;
% for k=1:nCol
%     windNramp=windRecords2Dto1Dramp(2:nStep+1,k);
%     windEramp=windRecords2Dto1Dramp(nStep+2:end,k);
%     subplot(2,1,1)
%     plot(0:10:(nStep-1)*10,windNramp)
%     xlabel('Time (min)')
%     ylabel('Wind speed (m/s)')
%     hold on
%     subplot(2,1,2)
%     plot(0:10:(nStep-1)*10,windEramp)
%     xlabel('Time (min)')
%     ylabel('Wind speed (m/s)')
%     hold on
% end
% figname=strcat('Wind speeds in North direction for Grid',num2str(j));
% subplot(2,1,1)
% title(figname)
% figname=strcat('Wind speeds in East direction for Grid',num2str(j));
% subplot(2,1,2)
% title(figname)
% % save figure
% figWidth=6;
% figHeight=4;
% set(hfig,'PaperUnits','inches');
% set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
% figname=strcat('.\windRecordsMass\figGrid',num2str(j),'.');
% print(hfig,[figname,'tif'],'-r800','-dtiff');
end
meanNumHurr=mean(numHurr);
hfig=figure;
histogram(numHurr,10,'FaceColor','none');
xlabel('Number of hurricanes','FontSize',8,'FontName','Times New Roman')
ylabel('Number of grids','FontSize',8,'FontName','Times New Roman')
set(gca,'FontSize',8,'FontName','Times New Roman')
%title('Histogram of number of hurricanes for grids of Massachusetts')
% save histogram
figWidth=3.5;
figHeight=3;
set(hfig,'PaperUnits','inches');
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
figname=('.\assets\Fig9.'); %Fig. 8 in the paper
print(hfig,[figname,'tif'],'-r1200','-dtiff');
%% flatten 2D wind to 1D and add ramp-up and ramp-down
function [windRecords2Dto1Dramp]=flatten2Dto1Dramp(seleHurrGood,maxDura)
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
end