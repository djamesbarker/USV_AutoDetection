function dates = dates_in_year(year)

% dates_in_year - as strings
% --------------------------
%
% dates = dates_in_year(year)
%
% Input:
% ------
%  year - number
%
% Output:
% -------
%  dates - strings

%--
% handle input
%--

if ~nargin
	year = 2010;
end

start = [year, 1, 1, 0, 0, 0]; stop = [year, 12, 31, 0, 0, 0];

start = datenum(start); stop = datenum(stop);

dates = num2cell(linspace(start, stop, 365));
		
for k = 1:numel(dates)
	dates{k} = datestr(dates{k});
end
		
if ~nargout
	disp(' ');
	
	for k = 1:numel(dates)
		disp(dates{k});
	end
	
	disp(' ');
	
	clear dates;
end
