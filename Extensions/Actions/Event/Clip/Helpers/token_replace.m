function str = token_replace(str, tokens, values)

if ischar(tokens)
    tokens = {tokens};
end

if ischar(values)
    values = {values};
end

for k = 1:numel(tokens)
    str = strrep(str, tokens{k}, values{k}); 
end
