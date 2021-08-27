clear;clc;
load('loc1NE3-2seleHurrGood.mat');
load('loc1NE3-2duraGood.mat');
[maxDura,idx]=max(duraGood);
%% 1D wind with zero padding at the end
windRecords=zeros(maxDura/10+1,length(seleHurrGood));
windRecords(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250);
    windRecords(2:numP+1,i)=seleHurrGood{i}.VIn250;
end
%save('windRecords.txt', windRecords, '-double', '-tab')
dlmwrite('windRecords.txt',windRecords,'delimiter','\t')
%% 1D wind with zero padding at the beginning and the end
% seleHurrGood(idx)=[];
% duraGood(idx)=[];
% [maxDura,idx]=max(duraGood);
windRecords2=zeros(maxDura/10+1,length(seleHurrGood));
windRecords2(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250);
    mid=round(maxDura/10/2)+1;
    if rem(numP,2)==0
        windRecords2(mid-numP/2+1:mid+numP/2,i)=seleHurrGood{i}.VIn250;
    else
        windRecords2(mid-(numP/2-0.5):mid+(numP/2-0.5),i)=seleHurrGood{i}.VIn250;
    end
end
dlmwrite('windRecords2.txt',windRecords2,'delimiter','\t')
%% 2D wind with zero padding at the beginning and the end
seleHurrGood(idx)=[];
duraGood(idx)=[];
[maxDura,idx]=max(duraGood);
windRecords2D=zeros(maxDura/10+1,length(seleHurrGood)*2);
windRecords2D(1,1:2:end-1)=1:length(seleHurrGood);
windRecords2D(1,2:2:end)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250N);
    mid=round(maxDura/10/2)+1;
    if rem(numP,2)==0
        windRecords2D(mid-numP/2+1:mid+numP/2,2*i-1)=seleHurrGood{i}.VIn250N;
        windRecords2D(mid-numP/2+1:mid+numP/2,2*i)=seleHurrGood{i}.VIn250E;
    else
        windRecords2D(mid-(numP/2-0.5):mid+(numP/2-0.5),2*i-1)=seleHurrGood{i}.VIn250N;
        windRecords2D(mid-(numP/2-0.5):mid+(numP/2-0.5),2*i)=seleHurrGood{i}.VIn250E;
    end
end
dlmwrite('windRecords2D.txt',windRecords2D,'delimiter','\t')