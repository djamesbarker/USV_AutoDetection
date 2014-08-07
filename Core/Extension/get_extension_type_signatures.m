function [fun, signatures] = get_extension_type_signatures(type)

% get_extension_type_signatures - signature from extension type extension 
% -----------------------------------------------------------------------
%
% [fun, signatures] = get_extension_type_signatures(type)
%
% Input: 
% ------
%  type - extension type for which we desire signatures
%
% Output:
% -------
%  fun - type signatures
%  signatures - handle to extension_type extension signatures function

% NOTE: this is part of the boot-strapping code for extension types

% TODO: add caching and consider failure response carefully

%--
% check for availability of signatures from extension_type extension
%--

root = [extensions_root('extension_type'), filesep, title_caps(type), filesep, 'private'];

file = [root, filesep, 'signatures.m'];

% NOTE: return empty if extension_type extension does not provide signatures

if ~exist(file, 'file') 
	fun = struct; signatures = []; return;
end

%--
% get method handle
%--

current = pwd; cd(root); 

signatures = str2func('signatures');

cd(current);

%--
% call signatures method to get signatures
%--

fun = signatures();

