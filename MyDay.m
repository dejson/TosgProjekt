classdef MyDay
    %MYDAY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = 'public', SetAccess = 'private')
        name = ''
        weekday
        weeknum
        day
        month
        year
    end
    
    properties (Access = 'private')
        date
    end
    
    methods
        function obj = MyDay(day, month, year, holidays)
            if nargin > 0
                obj.month = month;
                obj.day = day;
                obj.year = year;
                obj.date = datenum(obj.year, obj.month, obj.day);
                obj.weekday = datestr(obj.date, 'dddd');
                obj.weeknum = str2num(datestr(obj.date, 'dd'));

                if holidays.isKey(obj.date)
                    obj.name = holidays(obj.date);
                end
            end
        end
    end
end

