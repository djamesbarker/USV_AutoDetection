function fields = collect_fieldnames(in)

% collect_fieldnames - from heterogenous struct collection
% --------------------------------------------------------
%
% field = collect_fieldnames(in)
%
% Input:
% ------
%  in - cell array of structs
%
% Output:
% -------
%  fields - collected 

% NOTE: the output here is a cell of cells each a collection of fieldnames

fields = iterate(@(x)(fieldnames(x)'), in); 

% NOTE: we flatten the disparate sets and keep unique ones

fields = unique([fields{:}]);
