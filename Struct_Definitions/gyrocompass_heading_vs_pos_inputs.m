classdef gyrocompass_heading_vs_pos_inputs
    %Gyrocompass Heading vs Pos Inputs Summary of this class goes here
    %   Detailed explanation goes here
    
    %Define properties
    properties

        %Set plot status i.e. do we plot 1 = yes, 0 = no
        plot            = 0;

        %Set the type of data being used in the gyrocompassing vs position
        %plot
        %Do we use raw GNSS, State or External Position for deriving
        %velocity heading

        %0 - State
        %1 - Raw GNSS
        %2 - External Position
        type            = 0;

    end
    
end