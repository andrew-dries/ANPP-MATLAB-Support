function heading_plot = Plot_Heading_Performance(log_data, plot_options)
%This function does performance analysis of heading

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output
    heading_plot    = [];

    %Grab structs in log file
    fields          = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif( log_data.configuration.DisableDualAntennaHeading == 0 && isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end
    
    %Create plotting times
    if(plot_options.plotting_time_type == 1) %date time
        state_plotting_time     = log_data.state.datetime;
        gnss_plotting_time      = log_data.raw_gnss.datetime;
    elseif(plot_options.plotting_time_type == 2) %duration
        state_plotting_time     = log_data.state.duration_seconds;
        gnss_plotting_time      = log_data.raw_gnss.duration_seconds;
    elseif(plot_options.plotting_time_type == 3) %Unix Time
        state_plotting_time     = log_data.state.unix_time_seconds;
        gnss_plotting_time      = log_data.raw_gnss.unix_time_seconds;
    elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
        state_plotting_time     = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
        gnss_plotting_time      = log_data.raw_gnss.unix_time_seconds - log_data.raw_gnss.utc_time_min;
    elseif(plot_options.plotting_time_type == 5) %Index
        state_plotting_time     = [1:length(log_data.state.datetime)];
        gnss_plotting_time      = [1:length(log_data.raw_gnss.datetime)];
    end

    %Set State Heading to go from -180 to 180
    log_data.state.orientation(log_data.state.orientation(:,3) > 180, 3) = log_data.state.orientation(log_data.state.orientation(:,3) > 180, 3) - 360;

    %Set figure name
    fig_names = {"Heading_Performance"};
    
    %*********************************************************************%
    %Analyze Heading
    %*********************************************************************%
    
    %Make Plot Info
    heading_plot = figure('Name',fig_names{1});

    %If we are doing dual antenna heading
    if( log_data.configuration.DisableDualAntennaHeading == 0 )

        %Calcualte state heading standard deviation
        state_heading_standard_deviation = extract_standard_deviation(state_plotting_time, log_data.state.orientation(:,3), plot_options.plot_heading_analysis.filter_length_s);

        %Calcualte dual gnss heading standard deviation
        gnss_heading_standard_deviation = extract_standard_deviation(gnss_plotting_time, log_data.raw_gnss.heading, plot_options.plot_heading_analysis.filter_length_s);
        
        %Subplot
        subplot(3,1,1);
        
        %State Heading
        plot_info.create_figure = 0;
        plot_info.title         = "State Heading";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Heading (deg)";
        plot_info.legend        = {"State Heading", "+1 Std", "-1 Std"};
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
        
        %Make input vectors
        times                   = [];
        times.time1             = state_plotting_time;
        times.time2             = state_plotting_time;
        times.time3             = state_plotting_time;
    
        input_vectors           = [];
        input_vectors.inp1      = log_data.state.orientation(:,3);
        input_vectors.inp2      = log_data.state.orientation(:,3) + state_heading_standard_deviation;
        input_vectors.inp3      = log_data.state.orientation(:,3) - state_heading_standard_deviation;
    
        %Make plot
        heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

        %Subplot
        subplot(3,1,2);

        %GNSS Heading
        plot_info.create_figure = 0;
        plot_info.title         = "GNSS Heading Heading";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Heading (deg)";
        plot_info.legend        = {"GNSS Heading", "+1 Std", "-1 Std"};
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
        
        %Make input vectors
        times                   = [];
        times.time1             = gnss_plotting_time;
        times.time2             = gnss_plotting_time;
        times.time3             = gnss_plotting_time;
    
        input_vectors           = [];
        input_vectors.inp1      = log_data.raw_gnss.heading;
        input_vectors.inp2      = log_data.raw_gnss.heading + gnss_heading_standard_deviation;
        input_vectors.inp3      = log_data.raw_gnss.heading - gnss_heading_standard_deviation;
    
        %Make plot
        heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

        %Subplot
        subplot(3,1,3);

        %Heading
        plot_info.create_figure = 0;
        plot_info.title         = "Heading Standard Deviation";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Heading Std (deg)";
        plot_info.legend        = {"State Heading Std", "GNSS Heading Std"};
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
        
        %Make input vectors
        times                   = [];
        times.time1             = state_plotting_time;
        times.time1             = gnss_plotting_time;
    
        input_vectors           = [];
        input_vectors.inp1      = state_heading_standard_deviation;
        input_vectors.inp1      = gnss_heading_standard_deviation;
    
        %Make plot
        heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

    else

        %Subplot
        subplot(2,1,1);
        
        %Calcualte state heading standard deviation
        state_heading_standard_deviation = extract_standard_deviation(state_plotting_time, log_data.state.orientation(:,3), plot_options.plot_heading_analysis.filter_length_s);

        %Heading
        plot_info.create_figure = 0;
        plot_info.title         = "State Heading";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Heading (deg)";
        plot_info.legend        = {"State Heading", "+1 Std", "-1 Std"};
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
        
        %Make input vectors
        times                   = [];
        times.time1             = state_plotting_time;
        times.time2             = state_plotting_time;
        times.time3             = state_plotting_time;
    
        input_vectors           = [];
        input_vectors.inp1      = log_data.state.orientation(:,3);
        input_vectors.inp2      = log_data.state.orientation(:,3) + state_heading_standard_deviation;
        input_vectors.inp3      = log_data.state.orientation(:,3) - state_heading_standard_deviation;
    
        %Make plot
        heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

        %Subplot
        subplot(2,1,2);

        %Heading
        plot_info.create_figure = 0;
        plot_info.title         = "State Heading Standard Deviation";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Heading Std (deg)";
        plot_info.legend        = {"Std"};
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
        
        %Make input vectors
        times                   = [];
        times.time1             = state_plotting_time;
    
        input_vectors           = [];
        input_vectors.inp1      = state_heading_standard_deviation;
    
        %Make plot
        heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

    end

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(heading_plot, fig_names);
    end

end