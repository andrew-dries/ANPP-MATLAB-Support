function kinematica_data = load_post_processed_kinematica_log(filename, time_filter)
%This function reads in state data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in state data from csv
    data = csvread(filename, 1, 1);
    
    %Initialize output struct
    kinematica_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [kinematica_data, time_mask] = process_time_log_file(kinematica_data, data(:,1:2), time_filter);

    kinematica_data.fix_type                                = data(time_mask,3);
    kinematica_data.position                                = data(time_mask,4:6);
    kinematica_data.position_error                          = data(time_mask,7:9);
    kinematica_data.velocity                                = data(time_mask,10:12);
    kinematica_data.velocity_error                          = data(time_mask,13:15);
    kinematica_data.orientation                             = data(time_mask,16:18);
    kinematica_data.orientation_error                       = data(time_mask,19:21);
    kinematica_data.accelerometer_bias                      = data(time_mask,22:24);
    kinematica_data.accelerometer_bias_standard_deviation   = data(time_mask,25:27);
    kinematica_data.gyroscope_bias                          = data(time_mask,28:30);
    kinematica_data.gyroscope_bias_standard_deviation       = data(time_mask,31:33);
    kinematica_data.gps_satellites                          = data(time_mask,34);
    kinematica_data.glonass_satellites                      = data(time_mask,35);
    kinematica_data.beidou_satellites                       = data(time_mask,36);
    kinematica_data.galileo_satellites                      = data(time_mask,37);
    kinematica_data.sbas_satellites                         = data(time_mask,38);
	kinematica_data.total_satellites                        = data(time_mask,34) + data(time_mask,35) + data(time_mask,36) + data(time_mask,37) + data(time_mask,38);
    kinematica_data.dual_antenna_fix_type                   = data(time_mask,39);
    
end
