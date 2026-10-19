classdef plotting_inputs
    %Plotting Inputs
    %   This file outlines the class plotting_inputs which can be loaded
    %   into plotting files to assist with setting logic.
    
    %Set property definitions
    properties

        %For plotting state
        plot_state                          = 0;

        %For plotting raw sensors
        plot_raw_sensors                    = raw_sensors_inputs();

        %For plotting bias
        plot_bias                           = 0;

        %For making video of position history
        make_video_position_history         = make_video_position_history_inputs();

        %Orientations & orientation SD plots
        plot_orientation_check              = 0;

        %For plotting State heading solution vs Velocity & Raw GNSS heading
        %solutions
        plot_heading_analysis               = heading_analysis_inputs();

        %For plotting various heading solutions against eachother
        plot_velocity_analysis              = 0;

        %For plotting error over distance travelled
        plot_error_over_distance_travelled  = 0;

        %For plotting position error vs raw gnss or external position
        plot_position_error                 = plot_position_error_inputs();

        %For plotting acceleration error
        plot_acceleration_error_estimates   = 0;

        %For plotting raw sensors vibration rms
        plot_raw_sensors_vibration_rms      = 0;

        %For plotting gyrocompassing heading versus position
        plot_gyrocompass_heading_vs_pos     = gyrocompass_heading_vs_pos_inputs();

        %For plotting state position
        plot_state_position                 = 0;

        %For plotting state vs gnss position
        plot_state_vs_gnss_position         = 0;

        %For plotting state vs external position
        plot_state_vs_external_position     = 0;

        %For plotting GNSS status including CEP50
        plot_gnss_status                    = 0;

        %Plot lla error and standard deviation
        plot_lla_error_and_sd               = plot_lla_error_and_sd_inputs();

        %For saving plots
        save_plots                          = 0;

        %For plotting time type
        plotting_time_type                  = 0; %1 - date time, 2 - duration, 3 = unix time, 4 = unix time normalized, 5 = counts
        
    end

end