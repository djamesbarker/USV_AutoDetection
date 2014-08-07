function compare_sunset(lat, year)

%--
% handle input
%--

if nargin < 2
	year = 2010;
end

if ~nargin
	lat = [0, 10, 17.5, 41]; 
end

lon = -75;

%--
% compute sunset times
%--

dates = dates_in_year(year);

time = zeros(365, numel(lat));

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)
		time(k, j) = sunrise(lon, lat(j), date);
	end
end 

%--
% plot sunset times
%--

fig; plot(time); hold on

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)		
		time(k, j) = sunset(lon, lat(j), date);
	end
end 

plot(time);
