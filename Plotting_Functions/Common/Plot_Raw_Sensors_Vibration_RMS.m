function vibe_rms = Plot_Raw_Sensors_Vibration_RMS(log_data, plot_options)
%This function plots the raw sensors vibration RMS to characterize the
%vibration environment.

    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Initialize
    vibe_rms = [];

    %Grab structs in log file
    fields      = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "raw_sensors") == 1) ) )
        error("Raw Sensors struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"Inertial Rates RMS"};

    %*********************************************************************%
    %Plot Accel & Gyro RMS
    %*********************************************************************%
    
    %Make figure
    vibe_rms = figure('Name',fig_names{1});
    
    %Subplot
    subplot(2,1,1);
    
    %Times
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Acceleration RMS";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration (m/s*s)";
    plot_info.legend        = {"X-Axis", "Y-Axis", "Z-Axis"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    times.time2             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    times.time3             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = extract_rms(log_data.raw_sensors.accelerometers(:,1) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.accelerometers(:,1), 1));
    input_vectors.inp2      = extract_rms(log_data.raw_sensors.accelerometers(:,2) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.accelerometers(:,2), 1));
    input_vectors.inp3      = extract_rms(log_data.raw_sensors.accelerometers(:,3) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.accelerometers(:,3), 1));
    
    %Make plot
    vibe_rms                = Plot_Time_History(times, input_vectors, plot_info);
    
    %Subplot
    subplot(2,1,2);
    
    %Times
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Gyroscope RMS";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Angular Rates (deg/s)";
    plot_info.legend        = {"X-Axis", "Y-Axis", "Z-Axis"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    times.time2             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    times.time3             = log_data.raw_sensors.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = extract_rms(log_data.raw_sensors.gyroscopes(:,1) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.gyroscopes(:,1), 1));
    input_vectors.inp2      = extract_rms(log_data.raw_sensors.gyroscopes(:,2) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.gyroscopes(:,2), 1));
    input_vectors.inp3      = extract_rms(log_data.raw_sensors.gyroscopes(:,3) - extract_moving_average(log_data.raw_sensors.unix_time_seconds, log_data.raw_sensors.gyroscopes(:,3), 1));
    
    %Make plot
    vibe_rms                = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(vibe_rms, fig_names);
    end

end

