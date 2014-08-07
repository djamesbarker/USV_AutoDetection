function compare_twilight(lat, year)

%--
% handle input
%--

if nargin < 2
	year = 2010;
end

if ~nargin
	lat = [55, 17]; 
end

lon = -75;

dates = dates_in_year(year);

time = zeros(365, numel(lat));

%--
% plot dawn times
%--

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)
		time(k, j) = dawn(lon, lat(j), date);
	end
end 

fig; plot(time); hold on

%--
% plot sunrise times
%--

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)
		time(k, j) = sunrise(lon, lat(j), date);
	end
end 

plot(time); hold on

%--
% plot sunset times
%--

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)		
		time(k, j) = sunset(lon, lat(j), date);
	end
end 

plot(time); hold on

%--
% plot dusk times
%--

for k = 1:numel(dates)
	date = datevec(dates{k});
	
	for j = 1:numel(lat)
		time(k, j) = dusk(lon, lat(j), date);
	end
end 

plot(time);
