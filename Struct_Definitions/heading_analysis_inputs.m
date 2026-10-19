classdef heading_analysis_inputs
    %HEADING_ANALYSIS_INPUTS Summary of this class goes here
    %   Detailed explanation goes here
    
    %Define properties
    properties

        %Set plot status i.e. do we plot 1 = yes, 0 = no
        plot                = 0;

        %Set the type of data being used in the heading analysis plot
        %Do we use raw GNSS, State or External Position for deriving
        %velocity heading

        %0 - Raw GNSS
        %1 - External Position
        type                = 0;

        %Set the filter length in seconds
        %This is for the standard deviation filter, and it is the time over
        %which we determine standard deviation
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