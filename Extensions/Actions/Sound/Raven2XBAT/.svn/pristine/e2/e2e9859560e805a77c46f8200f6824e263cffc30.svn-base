function result = parameter__control__callback(callback, context)

% RAVEN2XBAT_V2 - parameter__control__callback

result = struct;

%--
% control switch
%--

switch callback.control.name
	
    case 'raven_table'
        
        d='Select Raven Selection Tables to convert to XBAT logs';
        [fnRaven,pathRaven]=uigetfile('*.txt', d,'C:\Users\keen\Desktop\Saras Documents\NFCs\AEK_RavenComparison_20111024','MultiSelect','on');
        
        [c,r]=size(fnRaven);
        
        if r == 1 || c==1
            set(callback.control.handles, 'string', [pathRaven '\' fnRaven]);
            result.pathRaven = pathRaven;
            result.fnRaven = fnRaven;
        else
            for i = 1:r
               % set(callback.control.handles, 'string', [pathRaven '\' fnRaven{i}]);
                raven_array{i} =  [pathRaven '\' fnRaven{i}];
            end
            set(callback.control.handles, 'string', raven_array)
        end
        
        
    case 'tags'
        
        t=get(callback.control.handles, 'string')
        
end
