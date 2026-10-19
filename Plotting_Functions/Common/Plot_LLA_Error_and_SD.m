function lla_error_and_sd_plot = Plot_LLA_Error_and_SD(log_data, plot_options)
%This function checks the positional error of your state solution to either
%external position solutions or raw gnss position solutions

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Grab structs in log file
    fields  = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) && ...
            plot_options.plot_lla_error_and_sd.type == 0)
        error("Raw GNSS struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "external_position") == 1) ) && ...
            plot_options.plot_lla_error_and_sd.type == 1)
        error("External Position struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"Latitude Error & SD", "Longitude Error & SD", "Altitude Error & SD"};
        
    %Grab Raw GNSS plotting information
    if(plot_options.plot_lla_error_and_sd.type == 0)

        %Grab positions
        position        = log_data.raw_gnss.position;
        position_sd     = log_data.raw_gnss.position_standard_deviation;

        %Grab plotting times
        if(plot_options.plotting_time_type == 1) %date time
            plotting_time_state         = log_data.state.datetime;
            plotting_time_position      = log_data.raw_gnss.datetime;
        elseif(plot_options.plotting_time_type == 2) %duration
            plotting_time_state         = log_data.state.duration_seconds;
            plotting_time_position      = log_data.raw_gnss.duration_seconds;
        elseif(plot_options.plotting_time_type == 3) %Unix Time
            plotting_time_state         = log_data.state.unix_time_seconds;
            plotting_time_position      = log_data.raw_gnss.unix_time_seconds;
        elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
            plotting_time_state         = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
            plotting_time_position      = log_data.raw_gnss.unix_time_seconds - log_data.raw_gnss.utc_time_min;
        elseif(plot_options.plotting_time_type == 5) %Index
            plotting_time_state         = [1:length(log_data.state.datetime)];
            plotting_time_position      = [1:length(log_data.raw_gnss.datetime)];
        end

    elseif(plot_options.plot_lla_error_and_sd.type == 1)

        %Grab positions
        position        = log_data.external_position.position;
        position_sd     = log_data.external_position.position_sd;

        %Grab plotting times
        if(plot_options.plotting_time_type == 1) %date time
            plotting_time_state         = log_data.state.datetime;
            plotting_time_position      = log_data.external_position.datetime;
        elseif(plot_options.plotting_time_type == 2) %duration
            plotting_time_state         = log_data.state.duration_seconds;
            plotting_time_position      = log_data.external_position.duration_seconds;
        elseif(plot_options.plotting_time_type == 3) %Unix Time
            plotting_time_state         = log_data.state.unix_time_seconds;
            plotting_time_position      = log_data.external_position.unix_time_seconds;
        elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
            plotting_time_state         = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
            plotting_time_position      = log_data.external_position.unix_time_seconds - log_data.external_position.utc_time_min;
        elseif(plot_options.plotting_time_type == 5) %Index
            plotting_time_state         = [1:length(log_data.state.datetime)];
            plotting_time_position      = [1:length(log_data.external_position.datetime)];
        end

    end

    %*********************************************************************%
    %Plot Latitude & SD
    %*********************************************************************%
    
    %Initialize output
    lla_error_and_sd_plot(1) = figure('Name',fig_names{1});

    %Subplot -> Latitude
    subplot(2,1,1);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_1    = log_data.state.position(:,1);
    input_vector.input_2    = position(:,1);
    
    times                   = [];
    times.input_1           = plotting_time_state;
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Latitude Time History History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Latitude (deg)";
    plot_info.legend        = {"State Latitude", "External Latitude"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(1)  = Plot_Time_History(times, input_vector, plot_info);

    %Subplot -> Latitude
    subplot(2,1,2);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_2    = position_sd(:,1);
    
    times                   = [];
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Latitude SD Time History History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Latitude (deg)";
    plot_info.legend        = {"External Latitude SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(1)  = Plot_Time_History(times, input_vector, plot_info);

    %*********************************************************************%
    %Plot Longitude & SD
    %*********************************************************************%

    %Initialize output
    lla_error_and_sd_plot(2) = figure('Name',fig_names{2});

    %Subplot -> Longitude
    subplot(2,1,1);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_1    = log_data.state.position(:,2);
    input_vector.input_2    = position(:,2);
    
    times                   = [];
    times.input_1           = plotting_time_state;
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Longitude Time History History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Latitude (deg)";
    plot_info.legend        = {"State Longitude", "External Longitude"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(2)  = Plot_Time_History(times, input_vector, plot_info);

    %Subplot -> Longitude
    subplot(2,1,2);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_2    = position_sd(:,2);
    
    times                   = [];
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Longitude SD Time History History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Longitude (deg)";
    plot_info.legend        = {"External Longitude SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(2)  = Plot_Time_History(times, input_vector, plot_info);

    %*********************************************************************%
    %Plot Altitude & SD
    %*********************************************************************%

    %Initialize output
    lla_error_and_sd_plot(3) = figure('Name',fig_names{3});

    %Subplot -> Altitude
    subplot(2,1,1);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_1    = log_data.state.position(:,3);
    input_vector.input_2    = position(:,3);
    
    times                   = [];
    times.input_1           = plotting_time_state;
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Altitude Time History History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Altitude (m)";
    plot_info.legend        = {"State Altitude", "External Altitude"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(3)  = Plot_Time_History(times, input_vector, plot_info);

    %Subplot -> Altitude
    subplot(2,1,2);

    %Grab input_vector & times
    input_vector            = [];
    input_vector.input_2    = position_sd(:,3);
    
    times                   = [];
    times.input_2           = plotting_time_position;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Altitude SD Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Altitude (m)";
    plot_info.legend        = {"External Altitude SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    lla_error_and_sd_plot(3)  = Plot_Time_History(times, input_vector, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(lla_error_and_sd_plot, fig_names);
    end

end