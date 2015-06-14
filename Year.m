classdef MyYear
    %YEAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %datenum
        months = zeros(12,1);
        easter;
    end
    
    properties (Access = 'private')
        year;
    end
    
    methods
        function obj = MyYear(val)
            if nargin == 0
                obj.year = 0;
            else
                obj.year = val;
            end
            obj = obj.calculate_easter();
        end
    end
    
    methods (Access = 'private')
        function obj = calculate_easter(obj)
            % Based on Gauss algorithm
            a = mod(obj.year, 19);
            b = mod(obj.year, 4);
            c = mod(obj.year, 7);
            k = floor(obj.year/100);
            p = floor((13+8*k)/25);
            q = floor(k/4);
            M = mod(15 - p + k -q, 30);
            N = mod(4 + k - q, 7);
            d = mod(19*a + M, 30);
            e = mod(2*b + 4*c + 6*d + N, 7);
            
            if d + e - 9 > 0
                obj.easter = strcat('April', int2str(d + e -9));
            else
                obj.easter = strcat('March', int2str(22+d+e));
            end
        end
    end
    
end

