function figs = Plot_Raw_Sensors_Temperature_Correlation(raw_sensors, plot_options)
%Plot Raw Sensors Tempearutre Correlation
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(plot_options.plotting_time_type == 1) %date time
            plotting_time   = raw_sensors.datetime;
        elseif(plot_options.plotting_time_type == 2) %duration
            plotting_time   = raw_sensors.duration_seconds;
        elseif(plot_options.plotting_time_type == 3) %Unix Time
            plotting_time   = raw_sensors.unix_time_seconds;
        elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
            plotting_time   = raw_sensors.unix_time_seconds - raw_sensors.utc_time_min;
        elseif(plot_options.plotting_time_type == 5) %Index
            plotting_time   = [1:length(raw_sensors.datetime)];
        end

    else

        %Default to duration seconds
        plotting_time   = raw_sensors.duration_seconds;

    end

    %Set figure name
    fig_names = {"Accelerometers Temperature Correlation", "Gyroscopes Temperature Correlation"};

    %*********************************************************************%
    %Begin Calculations
    %*********************************************************************%
    
    %Calculate dT
    dTemperature    = abs([0; diff(raw_sensors.imu_temperature)] ./ [1; diff(raw_sensors.unix_time_seconds)]);

    %Calculate correlations
    r_out_accel_x   = calculate_pearson_correlation_coefficient(abs(raw_sensors.accelerometers(:,1)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);
    r_out_accel_y   = calculate_pearson_correlation_coefficient(abs(raw_sensors.accelerometers(:,2)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);
    r_out_accel_z   = calculate_pearson_correlation_coefficient(abs(raw_sensors.accelerometers(:,3)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);

    r_out_gyro_x    = calculate_pearson_correlation_coefficient(abs(raw_sensors.gyroscopes(:,1)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);
    r_out_gyro_y    = calculate_pearson_correlation_coefficient(abs(raw_sensors.gyroscopes(:,2)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);
    r_out_gyro_z    = calculate_pearson_correlation_coefficient(abs(raw_sensors.gyroscopes(:,3)), dTemperature, raw_sensors.unix_time_seconds, plot_options.plot_raw_sensors.filter_length_s);

    %*********************************************************************%
    %Begin Plotting Accelerations
    %*********************************************************************%

    %Make Plot Info
    figs(1) = figure('Name',fig_names{1});

    %Subplot
    subplot(3,1,1);
    
    %Accelerations
    plot_info.create_figure = 0;
    plot_info.title         = "Accelerations";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration (m/s*s)";
    plot_info.legend        = {"X", "Y", "Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;
    times.time2             = plotting_time;
    times.time3             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = raw_sensors.accelerometers(:,1) - mean(raw_sensors.accelerometers(:,1));
    input_vectors.inp2      = raw_sensors.accelerometers(:,2) - mean(raw_sensors.accelerometers(:,2));
    input_vectors.inp3      = raw_sensors.accelerometers(:,3) - mean(raw_sensors.accelerometers(:,3));
    
    %Make plot
    figs(1)                 = Plot_Time_History(times, input_vectors, plot_info);

    %Subplot
    subplot(3,1,2);
    
    %Temperature
    plot_info.create_figure = 0;
    plot_info.title         = "Temperature";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Temperature (deg C/s)";
    plot_info.legend        = {"X"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = raw_sensors.imu_temperature;
    
    %Make plot
    figs(1)                 = Plot_Time_History(times, input_vectors, plot_info);

    %Subplot
    subplot(3,1,3);
    
    %Accelerations
    plot_info.create_figure = 0;
    plot_info.title         = "Accelerometer to Temperature Correlations";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Correlation";
    plot_info.legend        = {"X", "Y", "Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;
    times.time2             = plotting_time;
    times.time3             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = r_out_accel_x;
    input_vectors.inp2      = r_out_accel_y;
    input_vectors.inp3      = r_out_accel_z;
    
    %Make plot
    figs(1)                 = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Begin Plotting Gyroscopes
    %*********************************************************************%

    %Make Plot Info
    figs(2) = figure('Name',fig_names{2});

    %Subplot
    subplot(3,1,1);
    
    %Gyroscopes
    plot_info.create_figure = 0;
    plot_info.title         = "Gyroscopes";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Angular Rates (deg/s)";
    plot_info.legend        = {"X", "Y", "Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;
    times.time2             = plotting_time;
    times.time3             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = raw_sensors.gyroscopes(:,1) - mean(raw_sensors.gyroscopes(:,1));
    input_vectors.inp2      = raw_sensors.gyroscopes(:,2) - mean(raw_sensors.gyroscopes(:,2));
    input_vectors.inp3      = raw_sensors.gyroscopes(:,3) - mean(raw_sensors.gyroscopes(:,3));
    
    %Make plot
    figs(2)                 = Plot_Time_History(times, input_vectors, plot_info);

    %Subplot
    subplot(3,1,2);
    
    %Temperature
    plot_info.create_figure = 0;
    plot_info.title         = "Temperature";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Temperature (deg C/s)";
    plot_info.legend        = {"X"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = raw_sensors.imu_temperature;
    
    %Make plot
    figs(1)                 = Plot_Time_History(times, input_vectors, plot_info);

    %Subplot
    subplot(3,1,3);
    
    %Accelerations
    plot_info.create_figure = 0;
    plot_info.title         = "Gyroscopes to Temperature Correlations";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Correlation";
    plot_info.legend        = {"X", "Y", "Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = plotting_time;
    times.time2             = plotting_time;
    times.time3             = plotting_time;

    input_vectors           = [];
    input_vectors.inp1      = r_out_gyro_x;
    input_vectors.inp2      = r_out_gyro_y;
    input_vectors.inp3      = r_out_gyro_z;
    
    %Make plot
    figs(2)                 = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(figs, fig_names);
    end

end

