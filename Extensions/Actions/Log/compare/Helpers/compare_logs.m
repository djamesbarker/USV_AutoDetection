function [true, false] = compare_logs(reference, test, score_thresh, overlap_thresh, overlap_freq)

if nargin < 4 || isempty(overlap_thresh)
    overlap_thresh = 0;
end

if nargin < 5 || isempty(overlap_freq)
    overlap_freq = 0;
end

if nargin < 3 || isempty(score_thresh)
    score_thresh = 0;
end
% 
% if ~sound_compare(reference.sound, test.sound)
%     error('logs must belong to the same sound');
% end

test_events = test.event;
ref_events = reference.event;

if score_thresh
    test_events([test_events.score] < score_thresh) = [];
end
    
%--
% get vectors of event times
%--

test_times = reshape([test_events.time], 2, [])';
ref_times = reshape([reference.event.time], 2, [])';

[s, tix] = sort(test_times(:, 1)); [s, rix] = sort(ref_times(:, 1));

test_events = test_events(tix);
ref_events = ref_events(rix);


j = 1; k = 1;

overlap_count = 0;
false_count = 0;

while (j <= numel(test_events) && k <= numel(ref_events))
   
    r = ref_events(k).time;
    t = test_events(j).time;
    
    if (t(1) > r(2))
        k = k + 1; continue;
    end
    
    if (t(2) < r(1))
        false_count = false_count + 1; j = j + 1; continue;
    end
    
    j = j + 1; k = k + 1;
    
    if (overlap_percentage(ref_events(k-1).time, test_events(j-1).time) < overlap_thresh)
        continue;
    end
    
    if overlap_freq && (overlap_percentage(ref_events(k-1).freq, test_events(j-1).freq) < overlap_thresh)
        continue;
    end
    
    overlap_count = overlap_count + 1;
    
end

true = overlap_count / reference.length; 
false = false_count / numel(test_events);


function p = overlap_percentage(int1, int2)

p = min([(int1(2) - int2(1)) / diff(int2), (int2(2) - int1(1)) / diff(int1)]);



