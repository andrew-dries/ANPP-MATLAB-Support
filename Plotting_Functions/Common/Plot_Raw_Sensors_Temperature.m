function temp_fig = Plot_Raw_Sensors_Temperature(log_data)
%This function plots the temperature from the raw sensors packet against
%time.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output
    temp_fig    = [];

    %Grab structs in log file
    fields      = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "raw_sensors") == 1) ) )
        error("State struct does not exist in log_data");
    end

    %*********************************************************************%
    %Plot Temperature
    %*********************************************************************%
    
    %Times
    plot_info               = [];
    plot_info.create_figure = 1;
    plot_info.title         = "Temperature";
    plot_info.x_label       = "Time";
    plot_info.y_label       = "Time (s)";
    plot_info.legend        = {};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.raw_sensors.imu_temperature;
    
    %Make plot
    temp_fig                = Plot_Time_History(times, input_vectors, plot_info);

end

