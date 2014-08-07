function indices = intersect_integers(varargin)

% intersect_integers - many sets in parallel
% ------------------------------------------
%
% result = intersect_integers(a, b, ... )
%
% Input
% -----
%  a, b, ... - index vector
%
% Output
% ------
%  c - common indices 

sets = varargin; 

fence = 0;

for k = 1:numel(sets)
    
    set = sets{k};
    for j = 1:numel(set)
        if set(j)>0 %map to even
            set(j) = 2*set(j);
        else % map to odd
            set(j) = -2*set(j) + 1;
        end
    end
    sets{k} = set;
    
    fence = max(fence, max(set));
end

A = sparse(fence, numel(sets));

for k = 1:numel(sets)
   A(sets{k}, k) = 1; 
end

mapped_indices = find(prod(A, 2));

for k = 1:numel(mapped_indices)
    if rem(mapped_indices(k),2)==0 %map back from even to pos
        mapped_indices(k) = mapped_indices(k)/2;
    else %map back from odd to neg or zero
        mapped_indices(k) = (mapped_indices(k)-1)/(-2);
    end
end

indices = sort(mapped_indices);


%----------------------
% FORWARD, BACK
%----------------------

% NOTE: these implement an integer to natural map and its inverse

function n = forward(n)

pos = n > 0; 

n(pos) = 2 * n(pos);

n(~pos) = -2 * n(~pos) + 1;


function n = back(n)

odd = mod(n, 2); 

n(odd) = -0.5 * (n(odd) - 1);

n(~odd) = 0.5 * n(~odd);




