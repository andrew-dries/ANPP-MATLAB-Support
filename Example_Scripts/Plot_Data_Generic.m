%Load in log data & plot time jitter info
close all; clear; clc;

%*************************************************************************%
%Add Paths
%*************************************************************************%

%Add paths
addpath('C:\Users\andrewdries\Documents\MATLAB\Support\ANPP-MATLAB-Support\Search_Path_Functions')
Add_Common_Paths_Function();

%*************************************************************************%
%Set Plotting Options
%*************************************************************************%

%Create plotting options struct
plot_options = plotting_inputs();

%Set plotting options
plot_options.plot_heading_analysis                  = 0;
plot_options.make_video_position_history            = 0;
plot_options.plot_error_over_distance_travelled     = 0;
plot_options.plot_acceleration_error_estimates      = 0;
plot_options.plot_raw_sensors_vibration_rms         = 0;

%*************************************************************************%
%Initializations
%*************************************************************************%

%Time intervals
%fprintf("[%2.12d, %2.12d]\n", log_data.state.unix_time_seconds(950446), log_data.state.unix_time_seconds(1066263))

%Plot Time
time_filter.time_interval   = [];

%Time type
time_filter.time_type       = 3; %1 - date time, 2 - duration, 3 = unix time

%Create time type
time_type                   = 4; %1 - date time, 2 - duration, 3 = unix time, 4 = unix time normalized

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
%Generic Plots
%*************************************************************************%

%Call plot state
state_figs          = Plot_State(log_data.state, log_data.device_information, time_type);

%Call plot raw sensors
raw_sensors_figs    = Plot_Raw_Sensors(log_data.raw_sensors, time_type);

%*************************************************************************%
%Plot Bias
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_bias)

    %Plot bias
    bias_figs   = Plot_Bias(log_data.bias, time_type);

end

%*************************************************************************%
%Plot Error over Distance Travelled
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_gyrocompass_heading_vs_pos)

    %Plot error versus distance travelled
    dist_err = Plot_Position_Error_With_GNSS_Truth(log_data);

    %Plot error versus distance travelled for jammed / spoofed
    %dist_err = Plot_Position_Error_Jammed_Spoofed(log_data);

end

%*************************************************************************%
%Plot Gyrocomapss Heading Versus Position
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_gyrocompass_heading_vs_pos)

    %Plot gyrocompass heading versus position
    dist_err = Plot_Gyrocompass_Heading_Vs_Position(log_data);

end

%*************************************************************************%
%Plot Accelerometer Error Estimates
%*************************************************************************%

%Determing plotting logic
if(plot_options.plot_acceleration_error_estimates)

    %Plot acceleration error estimates
    accel_error_figs = Plot_Acceleration_Error_Estimates(log_data);

end

%*************************************************************************%
%Analyze Heading
%*************************************************************************%

%Check Plotting Logic
if(plot_options.plot_heading_analysis)

    %Plot heading comparison
    heading_plot = Plot_Heading_Comparison(log_data);

end

%*************************************************************************%
%Plot Temperature
%*************************************************************************%

%Plot Raw Sensors Temperature
temp_fig = Plot_Raw_Sensors_Temperature(log_data);

%*************************************************************************%
%Plot Raw Sensors Vibration RMS
%*************************************************************************%

%Plot Raw Sensors Vibration RMS
if(plot_options.plot_raw_sensors_vibration_rms)

    %Plot Raw Sensors Vibration RMS
    vibe_rms = Plot_Raw_Sensors_Vibration_RMS(log_data);

end

%*************************************************************************%
%Plot Time History of Raw GNSS Position vs State Position - Video
%*************************************************************************%

%Determine if video should be made
if(plot_options.make_video_position_history)

    %Plot time history video
    hist_pos_fig = Plot_Time_History_State_vs_Raw_GNSS_Position(log_data);

end
