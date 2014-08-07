function test_apcluster
%
% test_apcluster - test and demo of affinity propogation code
% -----------------------------------------------------------
%
% Take verbatim from apcluster module description message
% but placed in a function for convenience.
%
% Copyright (c) B.J. Frey & D. Dueck (2006). This software may be 
% freely used and distributed for non-commercial purposes.
%
% See also: apcluster

N=100; x=rand(N,2); M=N*N-N; s=zeros(M,3); j=1;
for i=1:N
  for k=[1:i-1,i+1:N]
    s(j,1)=i; s(j,2)=k; s(j,3)=-sum((x(i,:)-x(k,:)).^2);
    j=j+1;
  end;
end;
p=median(s(:,3)); [idx,netsim,dpsim,expref]=apcluster(s,p,'plot');
fprintf('Number of clusters: %d\n',length(unique(idx)));
fprintf('Fitness (net similarity): %g\n',netsim);
figure; for i=unique(idx)'
  ii=find(idx==i); h=plot(x(ii,1),x(ii,2),'o'); hold on;
  col=rand(1,3); set(h,'Color',col,'MarkerFaceColor',col);
  xi1=x(i,1)*ones(size(ii)); xi2=x(i,2)*ones(size(ii)); 
  line([x(ii,1),xi1]',[x(ii,2),xi2]','Color',col);
end;
axis equal tight;
