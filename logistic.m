function y=logistic(x,L,k,x0)
y=L./(1+exp(-k*x+k*x0));
end
