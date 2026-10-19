%Load in log data & plot time jitter info
close all; clear; clc;

%*************************************************************************%
%Add Paths
%*************************************************************************%

%Path to your ANPP MATLAB Support Directory
ANPP_MATLAB_Support_Path    = 'C:\Users\andrewdries\Documents\Software Development\ANPP-MATLAB-Support';

%Add paths
addpath(strcat(ANPP_MATLAB_Support_Path,'\Search_Path_Functions'));
Add_Common_Paths_Function(ANPP_MATLAB_Support_Path);

%*************************************************************************%
%Set Plotting Options
%*************************************************************************%

%Create plotting options struct
plot_options = plotting_inputs();

%Set generic plotting options
plot_options.save_plots                             = 0;
plot_options.plotting_time_type                     = 4; %1 - date time, 2 - duration, 3 = unix time, 4 = unix time normalized, 5 = counts

%Set plotting options
plot_options.plot_state                             = 1;
plot_options.plot_raw_sensors                       = 0;
plot_options.plot_bias                              = 0;
plot_options.plot_orientation_check                 = 0;
plot_options.plot_heading_analysis.plot             = 0;
plot_options.plot_heading_analysis.type             = 1;
plot_options.plot_velocity_analysis                 = 0;
plot_options.make_video_position_history.plot       = 0;
plot_options.make_video_position_history.type       = 1;
plot_options.plot_error_over_distance_travelled     = 0;
plot_options.plot_position_error.plot               = 0;
plot_options.plot_position_error.type               = 1;
plot_options.plot_acceleration_error_estimates      = 0;
plot_options.plot_raw_sensors_vibration_rms         = 0;
plot_options.plot_gyrocompass_heading_vs_pos.plot   = 0;
plot_options.plot_gyrocompass_heading_vs_pos.type   = 0;
plot_options.plot_state_vs_gnss_position            = 0;
plot_options.plot_state_vs_external_position        = 0;
plot_options.plot_gnss_status                       = 0;
plot_options.plot_lla_error_and_sd.plot             = 0;
plot_options.plot_lla_error_and_sd.type             = 1;

%*************************************************************************%
%Initializations
%*************************************************************************%

%Time intervals
%fprintf("[%2.12d, %2.12d]\n", log_data.state.unix_time_seconds(950446), log_data.state.unix_time_seconds(1066263))

%Time Input
time_filter.time_interval   = [];
%time_filter.time_interval   = [1.777329410839e+09, 1.777329665884e+09]; %Monday Dynamic
%time_filter.time_interval   = [1.777475427643e+09, 1.777477562328e+09]; %Wednesday Driving

time_filter.time_type       = 3; %1 - date time, 2 - duration, 3 = unix time

%*************************************************************************%
%Load Data
%*************************************************************************%

%Load in data
log_data = load_processed_log_files(pwd, time_filter);

%Throw error of struct comes back empty
if( isempty(log_data) )
    error(strcat("Current path contains no log data!  Path: ", pwd))
end
 
%*************************************************************************%
%Plot state
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_state)

    %Call plot state
    state_figs          = Plot_State(log_data.state, log_data.device_information, plot_options);

end


%*************************************************************************%
%Plot raw sensors
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_raw_sensors)

    %Call plot raw sensors
    raw_sensors_figs    = Plot_Raw_Sensors(log_data.raw_sensors, plot_options);

end

%*************************************************************************%
%Plot Heading Check
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_orientation_check)

    %Call plot raw sensors
    orientation_check_fig    = Plot_Orientation_Check(log_data, plot_options);

end

%*************************************************************************%
%Plot Bias
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_bias)

    %Plot Bias
    bias_figs           = Plot_Bias(log_data.bias, plot_options);

end

%*************************************************************************%
%Plot Gyrocompass Heading vs Position
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_gyrocompass_heading_vs_pos.plot)

    %Plot heading history for different GNSS fix types
    gyro_heading_figs   = Plot_Gyrocompass_Heading_Vs_Position(log_data, 1, plot_options);

end

%*************************************************************************%
%State state position vs GNSS position
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_state_vs_gnss_position)

    %Plot Raw GNSS vs State Position
    gnss_vs_state_figs = Plot_Raw_GNSS_vs_State_Position(log_data, plot_options);

end

%*************************************************************************%
%State state position vs External position
%*************************************************************************%

%Determine plotting logic
if(plot_options.plot_state_vs_external_position)

    %Plot External Position vs State Position
    gnss_vs_state_figs = Plot_External_Position_vs_State_Position(log_data, plot_options);

end

%*************************************************************************%
%Plot GNSS Status
%*************************************************************************%

%Determine if video should be made
if(plot_options.plot_gnss_status)

    %Plot GNSS Status
    figs = Plot_GNSS_Status(log_data, plot_options);

end

%*************************************************************************%
%Plot Error over Distance Travelled
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_error_over_distance_travelled)

    %Plot error versus distance travelled
    dist_err = Plot_Position_Error_With_GNSS_Truth(log_data, plot_options);

    %Plot error versus distance travelled for jammed / spoofed
    %dist_err = Plot_Position_Error_Jammed_Spoofed(log_data, plot_options);

end

%*************************************************************************%
%Plot Accelerometer Error Estimates
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_acceleration_error_estimates)

    %Plot acceleration error estimates
    accel_error_figs = Plot_Acceleration_Error_Estimates(log_data, plot_options);

end

%*************************************************************************%
%Analyze Heading
%*************************************************************************%

%Check Plotting Logic
if(plot_options.plot_heading_analysis.plot)

    %Plot heading comparison
    heading_plot = Plot_Heading_Comparison(log_data, plot_options);

end

%*************************************************************************%
%Plot Position Error
%*************************************************************************%

%Check Plotting Logic
if(plot_options.plot_position_error.plot)

    %Plot heading comparison
    position_error_plot = position_error(log_data, plot_options);

end

%*************************************************************************%
%Analyze Velocity Inputs
%*************************************************************************%

%Check Plotting Logic
if(plot_options.plot_velocity_analysis)

    %Plot velocity comparison
    velocity_plot = Plot_Velocity_Comparison(log_data, plot_options);

end

%*************************************************************************%
%Plot Raw Sensors Vibration RMS
%*************************************************************************%

%Plot Raw Sensors Vibration RMS
if(plot_options.plot_raw_sensors_vibration_rms)

    %Plot Raw Sensors Vibration RMS
    vibe_rms = Plot_Raw_Sensors_Vibration_RMS(log_data, plot_options);

end

%*************************************************************************%
%Plot LLA Error & Standard Deviation
%*************************************************************************%

%Plot LLA Error and SD
if(plot_options.plot_lla_error_and_sd.plot)

    %Plot LLA Error and SD
    lla_error_and_sd_plot = Plot_LLA_Error_and_SD(log_data, plot_options);

end

%*************************************************************************%
%Plot Time History of Raw GNSS Position vs State Position - Video
%*************************************************************************%

%Determine if video should be made
if(plot_options.make_video_position_history.plot)

    %Plot time history video
    hist_pos_fig = Plot_Time_History_State_vs_Raw_GNSS_Position(log_data, plot_options);

end

%*************************************************************************%
%Custom Plots
%*************************************************************************%