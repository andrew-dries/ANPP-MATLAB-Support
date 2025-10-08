function heading_plot = Plot_Heading_Comparison(log_data, plot_options)
%This function performs a comparison between the state heading, raw gnss
%dual antenna heading (if available) and velocity heading.

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
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end
    
    %Use find closest time vector
    [state_time, raw_gnss_time]     = find_closest_time_vector_fast(log_data.state.unix_time_seconds, log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1));

    %Set figure name
    fig_names = {"Heading_Comparison"};
    
    %*********************************************************************%
    %Analyze Heading
    %*********************************************************************%
    
    %Make Plot Info
    heading_plot = figure('Name',fig_names{1});
    subplot(3,1,1);
    
    %Heading
    plot_info.create_figure = 0;
    plot_info.title         = "Heading Comparison";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Heading (deg)";
    plot_info.legend        = {"State Heading", "Raw Dual GNSS Heading", "Velocity Heading"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.time2             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time.mask) - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time.mask) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.state.orientation(:,3);
    input_vectors.inp2      = log_data.raw_gnss.heading(raw_gnss_time.mask);
    input_vectors.inp3      = calculate_velocity_heading(log_data.raw_gnss.velocity(raw_gnss_time.mask,:));
    
    %Make plot
    heading_plot            = Plot_Time_History(times, input_vectors, plot_info);
    
    subplot(3,1,2);
    
    %Velocity
    plot_info.create_figure = 0;
    plot_info.title         = "Heading Difference";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Heading (deg)";
    plot_info.legend        = {"State Heading to Dual Antenna Heading", "State Heading to Velocity Heading", "Dual Antenna Heading to Velocity Heading"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];

    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time.mask) - log_data.state.utc_time_min;
    times.time2             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds(raw_gnss_time.mask) - log_data.state.utc_time_min;

    input_vectors           = [];
    input_vectors.inp1      = log_data.state.orientation(state_time.mask,3) - log_data.raw_gnss.heading(raw_gnss_time.mask);
    input_vectors.inp1(input_vectors.inp1 > 180) = input_vectors.inp1(input_vectors.inp1 > 180) - 360;
    input_vectors.inp2      = log_data.state.orientation(:,3) - calculate_velocity_heading(log_data.state.velocity);
    input_vectors.inp2(input_vectors.inp2 > 180) = input_vectors.inp2(input_vectors.inp2 > 180) - 360;
    input_vectors.inp3      = log_data.raw_gnss.heading(raw_gnss_time.mask) - calculate_velocity_heading(log_data.raw_gnss.velocity(raw_gnss_time.mask,:));
    input_vectors.inp3(input_vectors.inp3 > 180) = input_vectors.inp3(input_vectors.inp3 > 180) - 360;
    
    %Make plot
    heading_plot            = Plot_Time_History(times, input_vectors, plot_info);
    
    subplot(3,1,3);
    
    %Velocity
    plot_info.create_figure = 0;
    plot_info.title         = "State Velocity";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Velocity (m/s)";
    plot_info.legend        = {};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.state.velocity;
    
    %Make plot
    heading_plot            = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(heading_plot, fig_names);
    end

end