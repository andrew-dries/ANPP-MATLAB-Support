function accel_error_figs = Plot_Acceleration_Error_Estimates(log_data, plot_options)
%UNTITLED Summary of this function goes here

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Grab structs in log file
    fields      = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"Acceleration Error"};

    %*********************************************************************%
    %Estimate Bias from State vs GNSS Velocity
    %*********************************************************************%
    
    %Create figure
    accel_error_figs = figure('name',fig_names{1});
    
    %Create subplot
    subplot(2,1,1);
    
    %Sync times
    [state_time_index, raw_gnss_time_index]        = find_closest_time_vector_fast(log_data.state.unix_time_seconds(log_data.state.filter_status.utc_time_initialised == 1), ...
                                                                                   log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1));
    
    %Calculate velocity error
    velocity_err            = log_data.state.velocity(state_time_index.index,:) - log_data.raw_gnss.velocity(raw_gnss_time_index.index,:);
    
    %Calculate acceleration error
    acceleration_err        = [0,0,0; diff(velocity_err)./diff(log_data.state.unix_time_seconds(state_time_index.index))];
    
    %Convert acceleration error to MG
    acceleration_err        = acceleration_err/9.8*1000;
    
    %Mask out NaNs
    mask                    = acceleration_err(:,1) ~= NaN & acceleration_err ~= inf;
    
    %Times
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Estimated Velocity Error";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Velocity (m/s)";
    plot_info.legend        = {"Error - X-axis", "Error - Y-axis", "Error - Z-axis"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,1)),:) - log_data.state.utc_time_min;
    times.time2             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,2)),:) - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,3)),:) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = velocity_err(mask(:,1),1);
    input_vectors.inp2      = velocity_err(mask(:,2),2);
    input_vectors.inp3      = velocity_err(mask(:,3),3);
    
    %Make plot
    accel_err               = Plot_Time_History(times, input_vectors, plot_info);
    
    %Subplot
    subplot(2,1,2);
    
    %Times
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Estimated Acceleration Error";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration (m/s/s)";
    plot_info.legend        = {"Error - X-axis", "Error - Y-axis", "Error - Z-axis"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,1)),:) - log_data.state.utc_time_min;
    times.time2             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,2)),:) - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time_index.index(mask(:,3)),:) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = extract_moving_average(times.time1, acceleration_err(mask(:,1),1), 60);
    input_vectors.inp2      = extract_moving_average(times.time2, acceleration_err(mask(:,2),2), 60);
    input_vectors.inp3      = extract_moving_average(times.time3, acceleration_err(mask(:,3),3), 60);
    
    %Make plot
    accel_err               = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(accel_error_figs, fig_names);
    end

end

