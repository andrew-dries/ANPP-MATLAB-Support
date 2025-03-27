function state_data = load_state_log(filename, time_interval)
%This function reads in state data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in state data from csv
    data = csvread(filename, 1, 1);
    
    %Initialize output struct
    state_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [state_data, time_mask] = process_time_log_file(state_data, data(:,1:2), time_interval);

    %Load in state data
    state_data.system_status.system_failure = data(time_mask,3);
    state_data.system_status.accelerometer_failure = data(time_mask,4);
    state_data.system_status.gyroscope_failure = data(time_mask,5);
    state_data.system_status.magnetometer_failure = data(time_mask,6);
    state_data.system_status.pressure_failure = data(time_mask,7); % For GNSS Compass, this is secondary gnss failure
    state_data.system_status.gnss_failure = data(time_mask,8);
    state_data.system_status.accelerometer_overrange = data(time_mask,9);
    state_data.system_status.gyroscope_overrange = data(time_mask,10);
    state_data.system_status.magnetometer_overrange = data(time_mask,11);
    state_data.system_status.pressure_overrange = data(time_mask,12); % For GNSS Compass, not populated.
    state_data.system_status.minimum_temperature = data(time_mask,13);
    state_data.system_status.maximum_temperature = data(time_mask,14);
    state_data.system_status.low_voltage = data(time_mask,15);  % For GNSS Compass, not populated.
    state_data.system_status.high_voltage = data(time_mask,16); % For GNSS Compass, not populated.
    state_data.system_status.gnss_antenna_disconnected = data(time_mask,17);
    state_data.system_status.data_overflow = data(time_mask,18);
    state_data.filter_status.orientation_initialised = data(time_mask,19);
    state_data.filter_status.navigation_filter_initialised = data(time_mask,20);
    state_data.filter_status.heading_initialised = data(time_mask,21);
    state_data.filter_status.utc_time_initialised = data(time_mask,22);
    state_data.filter_status.gnss_fix_type = data(time_mask,23);
    state_data.filter_status.event1_flag = data(time_mask,24);
    state_data.filter_status.event2_flag = data(time_mask,25);
    state_data.filter_status.internal_gnss_enabled = data(time_mask,26);
    state_data.filter_status.magnetometers_enabled = data(time_mask,27);
    state_data.filter_status.velocity_heading_enabled = data(time_mask,28);
    state_data.filter_status.atmospheric_altitude_enabled = data(time_mask,29);
    state_data.filter_status.external_position_active = data(time_mask,30);
    state_data.filter_status.external_velocity_active = data(time_mask,31);
    state_data.filter_status.external_heading_active = data(time_mask,32);
    state_data.position = data(time_mask,33:35);
    state_data.velocity = data(time_mask,36:38);
    state_data.acceleration = data(time_mask,39:41);
    state_data.g_force = data(time_mask,42);
    state_data.orientation = data(time_mask,43:45);
    state_data.angular_velocity = data(time_mask,46:48);
    state_data.position_error = data(time_mask,49:51);

end
