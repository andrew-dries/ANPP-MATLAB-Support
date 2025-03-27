function status_data = load_status_log(filename, time_interval)
%This function reads in system status data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in system status data from csv
    data = csvread(filename, 1, 1);
    
    %Initialize output struct
    status_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [status_data, time_mask] = process_time_log_file(status_data, data(:,1:2), time_interval);

    %Grab system status data
    status_data.system_status.system_failure = data(time_mask,3);
    status_data.system_status.accelerometer_failure = data(time_mask,4);
    status_data.system_status.gyroscope_failure = data(time_mask,5);
    status_data.system_status.magnetometer_failure = data(time_mask,6);
    status_data.system_status.pressure_failure = data(time_mask,7);
    status_data.system_status.gnss_failure = data(time_mask,8);
    status_data.system_status.accelerometer_overrange = data(time_mask,9);
    status_data.system_status.gyroscope_overrange = data(time_mask,10);
    status_data.system_status.magnetometer_overrange = data(time_mask,11);
    status_data.system_status.pressure_overrange = data(time_mask,12);
    status_data.system_status.minimum_temperature = data(time_mask,13);
    status_data.system_status.maximum_temperature = data(time_mask,14);
    status_data.system_status.low_voltage = data(time_mask,15);
    status_data.system_status.high_voltage = data(time_mask,16);
    status_data.system_status.gnss_antenna_disconnected = data(time_mask,17);
    status_data.system_status.data_overflow = data(time_mask,18);
    status_data.filter_status.orientation_initialised = data(time_mask,19);
    status_data.filter_status.navigation_filter_initialised = data(time_mask,20);
    status_data.filter_status.heading_initialised = data(time_mask,21);
    status_data.filter_status.utc_time_initialised = data(time_mask,22);
    status_data.filter_status.gnss_fix_type = data(time_mask,23);
    status_data.filter_status.event1_flag = data(time_mask,24);
    status_data.filter_status.event2_flag = data(time_mask,25);
    status_data.filter_status.internal_gnss_enabled = data(time_mask,26);
    status_data.filter_status.magnetometers_enabled = data(time_mask,27);
    status_data.filter_status.velocity_heading_enabled = data(time_mask,28);
    status_data.filter_status.atmospheric_altitude_enabled = data(time_mask,29);
    status_data.filter_status.external_position_active = data(time_mask,30);
    status_data.filter_status.external_velocity_active = data(time_mask,31);
    status_data.filter_status.external_heading_active = data(time_mask,32);

end
