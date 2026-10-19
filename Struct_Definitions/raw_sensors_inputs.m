classdef raw_sensors_inputs
    %Raw Sensors Inputs Summary of this class goes here
    %   Detailed explanation goes here
    
    %Define properties
    properties

        %Set plot status i.e. do we plot 1 = yes, 0 = no
        plot                = 0;

        %Set the filter length in seconds
        %This is for the correlation window width
        filter_length_s     = 60;

    end
    
    % methods
    %     function obj = heading_analysis_inputs(inputArg1,inputArg2)
    %         %HEADING_ANALYSIS_INPUTS Construct an instance of this class
    %         %   Detailed explanation goes here
    %         obj.Property1 = inputArg1 + inputArg2;
    %     end
    % 
    %     function outputArg = method1(obj,inputArg)
    %         %METHOD1 Summary of this method goes here
    %         %   Detailed explanation goes here
    %         outputArg = obj.Property1 + inputArg;
    %     end
    % end
end