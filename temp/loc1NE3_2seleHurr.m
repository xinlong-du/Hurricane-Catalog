clear;clc;
load('loc1NE3-2seleHurrGood.mat');
load('loc1NE3-2duraGood.mat');
[maxDura,idx]=max(duraGood);
windRecords=zeros(maxDura/10+1,length(seleHurrGood));
windRecords(1,:)=1:length(seleHurrGood);
for i=1:length(seleHurrGood)
    numP=length(seleHurrGood{i}.VIn250);
    windRecords(2:numP+1,i)=seleHurrGood{i}.VIn250;
end
%save('windRecords.txt', windRecords, '-double', '-tab')
dlmwrite('windRecords.txt',windRecords,'delimiter','\t')
%%
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