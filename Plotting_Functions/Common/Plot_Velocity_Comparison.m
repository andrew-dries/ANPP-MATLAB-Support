function velocity_plot = Plot_Velocity_Comparison(log_data, plot_options)
%This function performs a comparison between the state velocity, raw gnss
%velocity(if available) and external input velocity.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output
    velocity_plot    = [];
    
    %Use find closest time vector
    [external_position_time, automotive_time]       = find_closest_time_vector_fast(log_data.external_position.unix_time_seconds, log_data.automotive.unix_time_seconds);

    %Mask for actual external position jumps
    mask_pos_jumps      = diff(log_data.external_position.position(:,1)) ~= 0.0 & diff(log_data.external_position.position(:,2)) ~= 0.0;
    mask_pos_jumps = [0; mask_pos_jumps];
    mask_pos_jumps = logical(mask_pos_jumps);

    %Calculate external position velocity
    external_position_velocity = calculate_velocity_from_position(log_data.external_position.position(mask_pos_jumps,:), ...
                                                                  log_data.external_position.unix_time_seconds(mask_pos_jumps));

    %Calculate external position acceleration
    external_position_acceleration = calculate_derivitive(external_position_velocity.mag, log_data.external_position.unix_time_seconds(mask_pos_jumps));

    %Raw Sensors Magnitude
    magnitude_raw_sensors_accel     = sqrt(log_data.raw_sensors.accelerometers(:,1).^2 + ...
                                           log_data.raw_sensors.accelerometers(:,2).^2);

    %Set figure name
    fig_names = {"Velocity_Comparison", "Acceleration Plot"};
    
    %*********************************************************************%
    %Analyze Velocity
    %*********************************************************************%
    
    %Make Plot Info
    velocity_plot = figure('Name',fig_names{1});
    
    %Heading
    plot_info.create_figure = 0;
    plot_info.title         = "VelocityComparison";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Velocity(m/s)";
    plot_info.legend        = {"External Position Derived Velocity", "Automotive Velocity"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.external_position.unix_time_seconds(mask_pos_jumps) - log_data.state.utc_time_min;
    times.time2             = log_data.automotive.unix_time_seconds(mask_pos_jumps) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = external_position_velocity.mag;
    input_vectors.inp2      = sqrt(log_data.automotive.velocity_x(mask_pos_jumps).^2 + ...
                                   log_data.automotive.velocity_y(mask_pos_jumps).^2);
    

    %Make plot
    velocity_plot           = Plot_Time_History(times, input_vectors, plot_info);
    
    %*********************************************************************%
    %Analyze Acceleration
    %*********************************************************************%
    
    %Make Plot Info
    acceleration_plot = figure('Name',fig_names{2});
    
    %Create subplot
    subplot(2,1,1);

    %Heading
    plot_info.create_figure = 0;
    plot_info.title         = "Acceleration Comparison";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration (m/s^3)";
    plot_info.legend        = {"External Position Derived Acceleration", "Raw Accelerometers"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.external_position.unix_time_seconds(mask_pos_jumps) - log_data.state.utc_time_min;
    times.time2             = log_data.raw_sensors.unix_time_seconds(mask_pos_jumps) - log_data.raw_sensors.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = external_position_acceleration;
    input_vectors.inp2      = magnitude_raw_sensors_accel(mask_pos_jumps);

    %Make plot
    acceleration_plot       = Plot_Time_History(times, input_vectors, plot_info);

    %Create subplot
    subplot(2,1,2);

    accel_diff = magnitude_raw_sensors_accel(mask_pos_jumps) - external_position_acceleration;

    %Heading
    plot_info.create_figure = 0;
    plot_info.title         = "Acceleration Error";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration (m/s^3)";
    plot_info.legend        = {"Accel Error"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.external_position.unix_time_seconds(mask_pos_jumps) - log_data.state.utc_time_min;

    input_vectors           = [];
    input_vectors.inp1      = accel_diff;

    %Make plot
    acceleration_plot       = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(heading_plot, fig_names);
    end

end