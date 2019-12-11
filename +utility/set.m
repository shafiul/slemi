classdef set < handle
    %SET Set class around a containers.Map
    %   Detailed explanation goes here
    
    properties
        d;
    end
    
    methods
        function obj = set(data)
            %SET Construct an instance of this class
            if nargin < 1
                data = [];
            end
            
            if isempty(data)
                obj.d = containers.Map();
            else
                if ~ iscell(data)
                    data = {data};
                end
                
                assert(iscell(data));
                
                obj.d = containers.Map(data, num2cell(1: numel(data)));
            end
        end
        
        function ret = isKey(obj,k)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            ret = obj.d.isKey(k);
        end
        
        function add(obj, k)
            obj.d(k) = 1;
        end
        
        function ret = len(obj)
            ret = obj.d.Count;
        end
        
        function ret = get(obj)
            ret = obj.d.keys();
        end
        
        function ret = isempty(obj)
            ret = obj.d.isempty();
        end
    end
end

