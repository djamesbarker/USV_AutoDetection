function [info, known_tags] = events_info_str(par, fields, opt)

% events_info_str - create info string for list of browser events
% ---------------------------------------------------------------
%
% [info, known_tags] = events_info_str(par, fields, opt)
%
% Input:
% ------
%  par - browser handle
%  fields - fields to display
%  opt - list options
%
% Output:
% -------
%  info - cell array of event strings

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
%
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 5673 $
% $Date: 2006-07-11 17:21:35 -0400 (Tue, 11 Jul 2006) $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% set and possibly output default options
%--

if (nargin < 3) || isempty(opt)
    
    opt.page = 0; opt.visible = 0; opt.order = 'name';
    
    if ~nargin
        info = opt; return;
    end
    
end

%--
% check sort order value
%--

orders = {'name', 'score', 'time', 'rating'};

if ~ismember(opt.order, orders)
    error(['Unrecognized sort order ''', opt.order, '''.']);
end

%--
% check browser input
%--

if ~is_browser(par)
    error('Input handle is not browser handle.');
end

%--
% set default fields
%--

if (nargin < 2) || isempty(fields)
    
    fields = { ...
        'score', ...
        'rating', ...
        'label', ...
        'channel', ...
        'time' ...
        };
end

%----------------------------
% SETUP
%----------------------------

%--
% get browser state
%--

data = get_browser(par);

%--
% create convenience variables for parts of state
%--

log   = data.browser.log;

sound = data.browser.sound;

grid  = data.browser.grid;

%----------------------------
% KEEP VISIBLE
%----------------------------

%--
% select only displayed channels
%--

% NOTE: it makes sense to use visibility filtering all the time

if opt.visible
    
    %--
    % select remove invisible logs
    %--
    
    log(~[log.visible]) = [];
    
    if isempty(log)
        info = []; known_tags = {}; return;
    end
    
    %--
    % select visible events
    %--
    
    channel = get_channels(data.browser.channels);
    
    if length(channel) < sound.channels
        
        for k = 1:length(log)
            
            %--
            % get event channels and check which are visible
            %--
            
            event_channel = [log(k).event.channel];
            
            %--
            % find visible event indices
            %--
            
            ix = zeros(size(event_channel));
            
            for j = 1:length(channel)
                ix = ix | (event_channel == channel(j));
            end
            
            ix = find(ix);
            
            %--
            % update log copy
            %--
            
            log(k).event = log(k).event(ix); log(k).length = length(ix);
            
        end
        
    end
    
end

%----------------------------
% REMOVE EMPTY LOGS
%----------------------------

for k = length(log):-1:1
    
    if isempty(log(k).event)
        log(k) = [];
    end
    
end

%----------------------------
% GET KNOWN TAGS
%----------------------------

% TODO: factor this whenever we come across it again

known_tags = {};

for k = 1:length(log)
    known_tags = union(known_tags, unique_tags(log(k).event));
end

%--
% remove empty tags
%--

known_tags = setdiff(known_tags, {''});

for k = 1:length(known_tags)
    
    if known_tags{k}(1) == '*'
        known_tags{k}(1) = [];
    end
    
end

%----------------------------
% CREATE STRINGS
%----------------------------

%--
% order logs if sort order is name
%--

if strcmp(opt.order, 'name')
    [ignore, ix] = sort({log.file}); log = log(ix);
end

%--
% loop over logs to generate event strings
%--

% NOTE: putting strings in cell arrays preserves whitespace in 'strcat'

info = cell(0);

% CRP 20110112; pushed label, rating and level to end of event string
score_exists   = 0;
channel_exists = 0;
time_exists    = 0;
level_exists   = 0;
label_exists   = 0;
rating_exists  = 0;

for k = 1:length(log)
    
    %-----------------
    % PREFIX STRING
    %-----------------
    
    % NOTE: this part of the string is invariant to the fields input
    
    % TODO: replace this with a call to 'event_name' when it is done
    
    % CRP 20091105
    % original XBAT: unformatted event ID
    %SK = strcat(file_ext(log(k).file), {' # '}, ...
    %    int_to_str(struct_field(log(k).event, 'id')), {':  '});
    
    % hacked to zero-pad event ID to 6 places for nicer columns but this
    % change alone breaks the callback from the selection clicked in the
    % Sound window so it doesn't highlight the corresponding event
    % in the Events list.
    % this is fixed by hacking Core/event_bdfun.m q.v.
    % to modify the 'pat' searched for when an event box is clicked on
    % in the Sound Browser.
    
    % special case of log of 1 event: we need to coerce the strings
    % into cell arrays or spaces get disappeared by Matlab
    if isequal((log(k).length), 1)
        SK = strcat({file_ext(log(k).file)}, ...
            {' # '}, ...
            {int_to_rts(struct_field(log(k).event, 'id'), 999999, ' ')}, ...
            {':  '});
    else
        
        SK = strcat(file_ext(log(k).file), ...
            {' # '}, ...
            int_to_rts(struct_field(log(k).event, 'id'), 999999, ' '), ...
            {':  '});
    end
    %-----------------
    % FIELDS STRINGS
    %-----------------
    
    for j = 1:length(fields)
        
        switch fields{j}
            
            %-----------------
            % SCORE
            %-----------------
            
            case 'score'
                
                % NOTE: we display score as fractional percent
                
                score = struct_field(log(k).event, 'score');
                
                score = round(1000 * score) / 10;
                score(isnan(score)) = 0.1;
                
                % CRP 20091105
                % original XBAT
                % part = strcat(num2str(score), '%');
                % hacked to format integer score to same precision as float
                % annoyingly num2str removes leading spaces so we have
                % to pad with zeros if all logs are going to line up
                % since score ranges are separately calculated for each
                score_part = strcat(num2str(score, '%08.1f'), '%');
                score_exists = 1;
                
                %-----------------
                % LEVEL
                %-----------------
                
            case 'level'
                
                % CRP 20110111; removed space between L and =
                level_part = strcat({'L= '}, ...
                    int_to_str(struct_field(log(k).event, 'level')));
                
                level_exists = 1;
                
                %-----------------
                % CHANNEL
                %-----------------
                
            case 'channel'
                % CRP 20091105
                % original XBAT: unformatted channel ID
                % part = strcat({'Ch = '}, ...
                %    int_to_str(struct_field(log(k).event, 'channel'), 99));
                
                % hacked to zero-pad channel ID to 2 places
                % removed space after Ch
                channel_part = strcat({'Ch= '}, ...
                    int_to_str(struct_field(log(k).event, 'channel'), 99));
                
                channel_exists = 1;
                
                %-----------------
                % TIME
                %-----------------
                
            case 'time'
                
                %--
                % get values
                %--
                
                t = struct_field(log(k).event, 'time');
                t = t(:, 1);
                
                %--
                % map from record time to real time
                %--
                
                t = map_time(sound, 'real', 'record', t);
                
                %--
                % get string
                %--
                
                % CRP 20091105; removed space between T and =
                time_part = strcat({'T= '}, ...
                    get_grid_time_string(grid, t, sound.realtime));
                
                time_exists = 1;
                
                %-----------------
                % LABEL
                %-----------------
                
                % TODO: implement label using marked tags,
                %  here and in a few other places
                
                % CRP 20110111: moved 'label' to end of Event string
                % we temporarily store a 'label' in label_part
                % then concat this after all other 'part's to SK below
            case 'label'
                
                % get_label returns empty, or the only tag, or
                %  the primary tag (not a list of tags) for each event
                %  in the log
                label_part = get_label(log(k).event);
                
                % turn cells into column of single tags (one per event)
                % turn single string into cell array of one item
                %  (case where there is only 1 event in the log)
                if iscell(label_part)
                    label_part = label_part';
                else
                    label_part = cellstr(label_part);
                end
                
                % create logical array; 1 = empty tag
                label_empty = strcmp(label_part, '');
                
                if label_empty
                    label_size = 1;
                else
                    label_size = size(label_part);
                end
                
                % initialize two character arrays of size
                %   equal to the tag list
                pipes  = char(zeros(label_size) + '|');
                spaces = char(zeros(label_size) + ' ');
                separators = pipes;
                
                % keep the pipe before empty tag
                % change to space char before non-empty tag
                separators(label_empty==0) = ' ';
                separators = char(separators);
                label_part = char(label_part);
                
                % this suppresses an error about concat'ing an empty
                %  array in the next step
                if label_empty
                    label_part = ' ';
                end
                
                % put a pipe out for all to separate tags from
                %  previous fields
                % then apply the separator (pipe or space)
                % then add another space for legibility
                % then tack on the tags (or empty tags)
                labels = [pipes separators spaces label_part];
                
                % convert char array back to cell
                label_part = cellstr(labels);
                
                label_exists = 1;
                
                %-----------------
                % RATING
                %-----------------
                
            case 'rating'
                
                rating = struct_field(log(k).event, 'rating');
                
                rating(isnan(rating)) = 0;
                
                rating_part = strcat(str_line(rating, '*'), ...
                    str_line(5 - rating, ' '));
                
                for r = 1:length(rating_part)
                    if ~isequal(rating_part{r}, '     ')
                        rating_exists = 1;
                    end
                end
                
        end  % switch
        
    end  % fields for-loop
    
    %-----------------
    % CONCATENATE
    %-----------------
    
    % NOTE: separate fields using comma
    % CRP 20110112; changed field sep to period
    %  except for label (see special handling above)
    if score_exists
        SK = strcat(SK, score_part);
    end
    if channel_exists
        SK = strcat(SK, {' . '});
        SK = strcat(SK, channel_part);
    end
    if time_exists
        SK = strcat(SK, {' . '});
        SK = strcat(SK, time_part);
    end
    if label_exists
        SK = strcat(SK, {' '});
        SK = strcat(SK, label_part);
    end
    if rating_exists
        SK = strcat(SK, {' . '});
        SK = strcat(SK, rating_part);
    end
    if level_exists
        SK = strcat(SK, {' . '});
        SK = strcat(SK, level_part);
    end
    
    score_exists   = 0;
    channel_exists = 0;
    time_exists    = 0;
    level_exists   = 0;
    label_exists   = 0;
    rating_exists  = 0;
    
    % CRP: commented out all the original XBAT below
    %--
    % remove orphaned commas
    %--
    
    % NOTE: there must be a better way
    
    %SK = strrep(SK, ':  ..', ': ');
    
    %SK = strrep(SK, ',  ,', ',');
    
    %--
    % append event strings
    %--
    
    info = {info{:}, SK{:}};
    
end  % log event list for-loop

% NOTE: return if there is nothing to sort

if isempty(info)
    info = {}; return;
end

%----------------------------
% SORT STRINGS
%----------------------------

%--
% get sorting information
%--

% NOTE: time mapping is not required since sessions are monotone

score = []; rating = []; channel = []; time = [];

for k = 1:length(log)
    
    % NOTE: the comma-separated list approach does not handle nan values
    
    % 	part = [log(k).event.score]'; score = [score; part];
    
    part = struct_field(log(k).event, 'score'); score = [score; part];
    
    part = struct_field(log(k).event, 'rating'); rating = [rating; part];
    
    part = [log(k).event.channel]'; channel = [channel; part];
    
    time = [time; reshape([log(k).event.time]', 2, [])'];
    
end

time = time(:, 1);

%--
% sort to compute order and order strings
%--

if ~strcmp(opt.order, 'name')
    
    switch opt.order
        
        case 'score'
            [ignore, ix] = sortrows([score, time, channel], [-1, 2, 3]);
            
        case 'rating'
            [ignore, ix] = sortrows([rating, time, channel], [-1, 2, 3]);
            
        case 'time'
            [ignore, ix] = sortrows([time, channel, score], [1, 2, -3]);
            
    end
    
    info = info(ix);
    
end
