V=(seleHurrGood{1}.VInThresh)';
nc=length(V);
al=floor((nc+1)/2); %alpha=size of observability block
be=al;              %beta=size of controllability block
H=[];               %Hankel matrix
for j=1:al
    ind1=be+j-1;
    H=[H;V(j:ind1)];
end
[U,S,Vt]=svd(H);
% [Vt2,S2]=eig(H);
%% plot the singular values of H and select an order 
sn=diag(S);
% sn2=sort(diag(S2),'descend');
figure
semilogy(sn,'r*');
% hold on
% semilogy(sn2,'b*');

figure
plot(sn,'r*');
% hold on
% plot(sn,'b*');