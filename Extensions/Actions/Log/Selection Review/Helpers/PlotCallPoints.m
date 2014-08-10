function PlotCallPoints();
hold on;
X = CallPoints(:,1);
Y = CallPoints(:,2);
YY = spline(x,y,x);
plot(x,yy,'ro');
end