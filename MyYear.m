classdef MyYear
    %MYYEAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public', SetAccess = 'private')
        year;
        months = MyMonth;
        leap = false;
        easter_str;

    end
    
    properties (Access = 'private')
        % containers.Map is something like dict in python, but with types
        % in this particular Map keys must be ints and values must be chars
        holidays = containers.Map('KeyType', 'uint32', 'ValueType', 'char');
        easter;
    end
    
    methods
        function obj = MyYear(val)
            if nargin == 0
                obj.year = 0;
            else
                obj.year = val;
            end
            obj = obj.calculate_easter();
            obj = obj.is_year_leap();
            obj = obj.calculate_holidays();
            for i = 1:12
                obj.months(i) = MyMonth(i, obj.year, obj.leap, obj.holidays);
            end
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
                obj.easter_str = strcat('April', int2str(d + e -9));
                obj.easter = datenum(obj.year, 4, d + e -9);
            else
                obj.easter_str = strcat('March', int2str(22+d+e));
                obj.easter = datenum(obj.year, 3, 22 + d +3);
            end
        end
        
        function obj = is_year_leap(obj)
            if mod(obj.year, 400) == 0
                obj.leap = true;
            elseif and(mod(obj.year, 4) == 0, mod(obj.year, 100) ~= 0)
                obj.leap = true;
            end
        end
        
        function obj = calculate_holidays(obj)
            h_names = containers.Map('KeyType', 'char', 'ValueType', 'uint32');
            
            obj.holidays(obj.easter) = 'Wielkanoc';
            h_names('Wielkanoc') = obj.easter;
            
            [names, days, refs] = obj.get_holidays();
            
            for i = 1:length(days)
                if h_names.isKey(refs{i})
                    x = h_names(refs{i}) + days(i);
                    obj.holidays(x) = names{i};
                    h_names(names{i}) = x;
                end
            end
            
        end
        
        function [names, days, refs] = get_holidays(obj)
            f = fopen('swieta.txt');
            days = [];
            names = [];
            refs = [];
            while ~feof(f)
                line = fgetl(f);
                if ~isempty(line)
                    x = regexp(line, '_', 'split');
                    names = [names; x(1)];
                    refs = [refs; x(3)];
                    days = [days; str2num(x{2})];
                end
            end
            fclose(f);
        end
        
    end
    
end

