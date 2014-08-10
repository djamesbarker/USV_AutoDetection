function [true, false] = log_roc(ref, log, scores, overlap_thresh, check_freq)

if nargin < 5 || isempty(check_freq)
    check_freq = 0;
end

if nargin < 4 || isempty(overlap_thresh)
    overlap_thresh = 0.3;
end

if iscell(log)
    
    for j = 1:length(log)
        log_roc(ref, log{j}, scores, overlap_thresh, check_freq);
    end
    
    return;
    
end

k = 1;

for score = scores
    [true(k), false(k)] = compare_logs(ref, log, score, overlap_thresh, check_freq); k = k + 1;
end

if ~nargout
    figure; plot(false, true, 'x'); title(log_name(log)); set(gca, 'xlim', [0 1], 'ylim', [0 1]);
end
