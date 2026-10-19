function orientation_check_fig = Plot_Orientation_Check(log_data, plot_options)
%*************************************************************************%
%Common plotting function to check orientation vs orientation standard
%deviation
%*************************************************************************%

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Grab structs in log file
    fields  = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "euler_sd") == 1) ) )
        error("Euler sd struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"Plot Pitch Check", "Plot Roll Check", "Plot Heading Check"};
        
    if(plot_options.plotting_time_type == 1) %date time
        plotting_time_state     = log_data.state.datetime;
        plotting_time_euler     = log_data.euler_sd.datetime;
    elseif(plot_options.plotting_time_type == 2) %duration
        plotting_time_state     = log_data.state.duration_seconds;
        plotting_time_euler     = log_data.euler_sd.duration_seconds;
    elseif(plot_options.plotting_time_type == 3) %Unix Time
        plotting_time_state     = log_data.state.unix_time_seconds;
        plotting_time_euler     = log_data.euler_sd.unix_time_seconds;
    elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
        plotting_time_state     = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
        plotting_time_euler     = log_data.euler_sd.unix_time_seconds - log_data.euler_sd.utc_time_min;
    elseif(plot_options.plotting_time_type == 5) %Index
        plotting_time_state     = [1:length(log_data.state.datetime)];
        plotting_time_euler     = [1:length(log_data.euler_sd.datetime)];
    end
    
    %*********************************************************************%
    %Orientation & Orientation Standard Deviation Plots
    %*********************************************************************%
    
    %Initialize output
    orientation_check_fig(1) = figure('Name',fig_names{1});

    %Subplot -> Pitch
    subplot(2,1,1);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.state.orientation(:,1);
    
    times                   = [];
    times.input_1           = plotting_time_state;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Pitch Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Pitch"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(1)  = Plot_Time_History(times, orientation, plot_info);

    %Subplot -> Pitch SD
    subplot(2,1,2);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.euler_sd.standard_deviation(:,1);
    
    times                   = [];
    times.input_1           = plotting_time_euler;
    
    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Pitch SD Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Pitch SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(1)  = Plot_Time_History(times, orientation, plot_info);

    %Initialize output
    orientation_check_fig(2) = figure('Name',fig_names{2});

    %Subplot -> Roll
    subplot(2,1,1);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.state.orientation(:,2);
    
    times               = [];
    times.input_1       = plotting_time_state;
    
    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Roll Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Roll"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(2)  = Plot_Time_History(times, orientation, plot_info);

    %Subplot -> Roll SD
    subplot(2,1,2);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.euler_sd.standard_deviation(:,2);
    
    times                   = [];
    times.input_1           = plotting_time_euler;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Roll SD Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Roll SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(2)  = Plot_Time_History(times, orientation, plot_info);

    %Initialize output
    orientation_check_fig(3) = figure('Name',fig_names{3});

    %Subplot -> Heading
    subplot(2,1,1);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.state.orientation(:,3);
    
    times                   = [];
    times.input_1           = plotting_time_state;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Heading Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Heading"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(3)  = Plot_Time_History(times, orientation, plot_info);

    %Subplot -> Heading SD
    subplot(2,1,2);

    %Grab orientation & times
    orientation             = [];
    orientation.input_1     = log_data.euler_sd.standard_deviation(:,3);
    
    times                   = [];
    times.input_1           = plotting_time_euler;

    %Make Plot Info
    plot_info               = [];
    plot_info.create_figure = 0;
    plot_info.title         = "Heading SD Time History";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Degrees (deg)";
    plot_info.legend        = {"Heading SD"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Call position history function
    orientation_check_fig(3)  = Plot_Time_History(times, orientation, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(orientation_check_fig, fig_names);
    end

end