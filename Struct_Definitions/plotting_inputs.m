classdef plotting_inputs
    %Plotting Inputs
    %   This file outlines the class plotting_inputs which can be loaded
    %   into plotting files to assist with setting logic.
    
    %Set property definitions
    properties

        %For making video of position history
        make_video_position_history         = 0;

        %For plotting State heading solution vs Velocity & Raw GNSS heading
        %solutions
        plot_heading_analysis               = 0;

        %For plotting error over distance travelled
        plot_error_over_distance_travelled  = 0;

        %For plotting acceleration error
        plot_acceleration_error_estimates   = 0;

        %For plotting raw sensors vibration rms
        plot_raw_sensors_vibration_rms      = 0;
        
    end

end

