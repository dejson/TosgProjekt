classdef MyMonth
    %MYMONTH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public', SetAccess = 'private')
        days = MyDay;
        month;
        day_num;
        year;
    end
    
    methods
        function obj = MyMonth(mon, year, leap, holidays)
            if nargin > 0
                obj.month = mon;
                obj.year = year;
                obj.day_num = obj.calculate_day_num(leap);

                for i = 1:obj.day_num+1
                    obj.days(i) = MyDay(i, obj.month, year, holidays);
                end
            end
        end
    end
    
    methods (Access = 'private')
        function day_num = calculate_day_num(obj, leap)
           day_num = 31;
           if obj.month == 2
               if leap
                   day_num = 29;
               else
                   day_num = 28;
               end
           elseif any([4 6 9 11] == obj.month)
               day_num = 30;
           end
        end
    end
    
end

