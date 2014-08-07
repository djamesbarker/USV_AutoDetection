function m = to_mat(s)

% to_mat - convert a struct of scalars to a matrix
% ------------------------------------------------

c = struct2cell(s)';

m = reshape([c{:}], [], numel(fieldnames(s)));
