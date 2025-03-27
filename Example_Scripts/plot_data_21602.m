%Load in log data & plot time jitter info
close all; clear; clc;

%*************************************************************************%
%Initializations
%*************************************************************************%

%Add paths
addpath('C:\Users\andrewdries\Documents\MATLAB\Support\Search_Path_Functions')
Add_Common_Paths_Function();

%Time interval
time_interval = [180,185];
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
%Plot Data
%*************************************************************************%

%Plot state data
log_data.device_information.device_id = 3;
figs_state              = Plot_State(log_data.state, log_data.device_information, 2);

%Plot raw sensors
figs_raw_sensors        = Plot_Raw_Sensors(log_data.raw_sensors, 2);

%Plot Antenna Positions
fig_antenna_positions   = Plot_Antenna_Positions(log_data.configuration);

%Plot Uptime
bias                    = Plot_Bias(log_data.bias, 2);