%Load in log data & plot time jitter info
close all; clear; clc;

%*************************************************************************%
%Initializations
%*************************************************************************%

%Add paths
addpath('C:\Users\andrewdries\Documents\MATLAB\Support\Search_Path_Functions')
Add_Common_Paths_Function();

%Time interval
time_interval = [29790,30704];
%time_interval = [];

%*************************************************************************%
%Load Data
%*************************************************************************%

%Load in data
log_data = load_processed_log_files(pwd, time_interval);

%Throw error of struct comes back empty
if( isempty(log_data) )
    error(strcat("Current path contains no log data!  Path: ", pwd))
end

%*************************************************************************%
%Mask for errors
%*************************************************************************%

%Grab accelerometer & gyro errors
acccel_overrange_mask   = log_data.state.system_status.accelerometer_overrange == 1;
gyro_overrange_mask     = log_data.state.system_status.gyroscope_overrange == 1;
errors_mask             = acccel_overrange_mask | gyro_overrange_mask;

%Find min and max time of these errors
min_time    = min(log_data.state.unix_time_seconds(errors_mask)) - 10.0;
max_time    = max(log_data.state.unix_time_seconds(errors_mask)) + 10.0;

%Make time masks
time_mask_state             = make_time_mask(log_data.state.unix_time_seconds, min_time, max_time);
time_mask_raw_sensors       = make_time_mask(log_data.raw_sensors.unix_time_seconds, min_time, max_time);
time_mask_raw_gnss          = make_time_mask(log_data.raw_gnss.unix_time_seconds, min_time, max_time);
%time_mask_body_vel          = make_time_mask(log_data.body_velocity.unix_time_seconds, min_time, max_time);
%time_mask_ext_body_vel      = make_time_mask(log_data.external_body_velocity.unix_time_seconds, min_time, max_time);
%time_mask_ext_vel           = make_time_mask(log_data.external_velocity.unix_time_seconds, min_time, max_time);
%time_mask_body_accel        = make_time_mask(log_data.body_acceleration.unix_time_seconds, min_time, max_time);

%*************************************************************************%
%Make Plots
%*************************************************************************%

%Explore time histories of velocity & position
hist_fig = figure;
subplot(3,1,1);

%X-Axis Velocity
velocity            = [];
velocity.vel1       = log_data.state.velocity(time_mask_state,1);
velocity.vel2       = log_data.raw_gnss.velocity(time_mask_raw_gnss,1);

time_state          = [];
time_state.time1    = log_data.state.unix_time_seconds(time_mask_state);
time_state.time2    = log_data.raw_gnss.unix_time_seconds(time_mask_raw_gnss);

plot_info.title         = "Time Histories of X-Axis Body Velocity";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "Velocity (m/s)";
plot_info.legend        = {"Body Velocity X-Axis", "Raw GNSS Velocity X-Axis"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, velocity, plot_info);

%Y-Axis Velocity
subplot(3,1,2)
velocity            = [];
velocity.vel1       = log_data.state.velocity(time_mask_state,2);
velocity.vel2       = log_data.raw_gnss.velocity(time_mask_raw_gnss,2);

time_state          = [];
time_state.time1    = log_data.state.unix_time_seconds(time_mask_state);
time_state.time2    = log_data.raw_gnss.unix_time_seconds(time_mask_raw_gnss);

plot_info.title         = "Time Histories of Y-Axis Body Velocity";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "Velocity (m/s)";
plot_info.legend        = {"Body Velocity Y-Axis", "Raw GNSS Velocity Y-Axis"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, velocity, plot_info);

%Append Errors
subplot(3,1,3)
errors.time1        = log_data.state.system_status.accelerometer_overrange(time_mask_state);
errors.time2        = log_data.state.system_status.gyroscope_overrange(time_mask_state);
time_state.time1    = log_data.state.unix_time_seconds(time_mask_state);
time_state.time2    = log_data.state.unix_time_seconds(time_mask_state);

plot_info.title         = "Time Histories of Failures";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "Failure Status";
plot_info.legend        = {"accelerometer_overrange", "gyroscope_overrange"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, errors, plot_info);

%Explore accelerometer values
accel_fig = figure;
subplot(3,1,1);
acceleration                = [];
acceleration.accel1         = log_data.raw_sensors.accelerometers(time_mask_raw_sensors,1);

time_state                  = [];
time_state.time1            = log_data.raw_sensors.unix_time_seconds(time_mask_raw_sensors);

plot_info.title         = "Time Histories of X-Axis Body Acceleration";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "acceleration (m/s^2)";
plot_info.legend        = {"Body Acceleration X-Axis"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, acceleration, plot_info);

subplot(3,1,2);
acceleration                = [];
acceleration.accel1         = log_data.raw_sensors.accelerometers(time_mask_raw_sensors,2);

time_state                  = [];
time_state.time1            = log_data.raw_sensors.unix_time_seconds(time_mask_raw_sensors);

plot_info.title         = "Time Histories of Y-Axis Body Acceleration";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "acceleration (m/s^2)";
plot_info.legend        = {"Body Acceleration Y-Axis"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, acceleration, plot_info);

subplot(3,1,3);
errors.time1        = log_data.state.system_status.accelerometer_overrange(time_mask_state);
errors.time2        = log_data.state.system_status.gyroscope_overrange(time_mask_state);
time_state.time1    = log_data.state.unix_time_seconds(time_mask_state);
time_state.time2    = log_data.state.unix_time_seconds(time_mask_state);

plot_info.title         = "Time Histories of Failures";
plot_info.x_label       = "Time (min)";
plot_info.y_label       = "Failure Status";
plot_info.legend        = {"accelerometer_overrange", "gyroscope_overrange"};
plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.new_figure    = 0;
Plot_Time_History(time_state, errors, plot_info);

%Plot state data
log_data.device_information.device_id = 3;
figs_state              = Plot_State(log_data.state, log_data.device_information, 3);

%Plot raw sensors
figs_raw_sensors        = Plot_Raw_Sensors(log_data.raw_sensors, 3);

%Plot position
%Grab positions & times
positions.input_1   = log_data.state.position(time_mask_state,1:2);
positions.input_2   = log_data.raw_gnss.position(log_data.raw_gnss.status.time_valid == 1 & time_mask_raw_gnss,1:2);

%Make Plot Info
plot_info.title     = "Position History (Lat,Long)";
plot_info.x_label   = "Latitude";
plot_info.y_label   = "Longitude";
plot_info.legend    = {"Position State", "Position Raw GNSS"};

%Call position history function
position_fig_follow = Plot_Position_History(positions, plot_info);

% %Plot position history in time follower
% positions.input_1   = log_data.state.position(time_mask_state,1:2);
% positions.input_2   = log_data.raw_gnss.position(log_data.raw_gnss.status.time_valid == 1 & time_mask_raw_gnss,1:2);
% times.input_1       = log_data.state.unix_time_seconds(time_mask_state);
% times.input_2       = log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1 & time_mask_raw_gnss);
% 
% plot_info.lims_x        = [];
% plot_info.lims_y        = [];
% plot_info.title         = "GNSS vs State Position in Time";
% plot_info.legend        = {"State Position - Previous", "State Position - Current", "Raw GNSS Position - Previous", "Raw GNSS Position - Current"};
% pos_time_hist_follow    = Plot_Position_History_In_Time(positions, times, plot_info);