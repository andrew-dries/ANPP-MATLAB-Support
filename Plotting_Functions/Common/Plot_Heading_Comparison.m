function heading_plot = Plot_Heading_Comparison(log_data)
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

    %*********************************************************************%
    %Analyze Heading
    %*********************************************************************%
    
    %Make Plot Info
    figure;
    subplot(3,1,1);
    
    %Heading
    plot_info.create_figure = 0;
    plot_info.title         = "Heading Comparison";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Heading (deg)";
    plot_info.legend        = {"State", "Raw Dual GNSS", "Velocity", "Kinematica"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.time2             = log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1) - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.state.orientation(:,3);
    input_vectors.inp2      = log_data.raw_gnss.heading(log_data.raw_gnss.status.time_valid == 1);
    input_vectors.inp3      = calculate_velocity_heading(log_data.raw_gnss.velocity);
    
    %Make plot
    heading_plot            = Plot_Time_History(times, input_vectors, plot_info);
    
    subplot(3,1,2);
    
    %Velocity
    plot_info.create_figure = 0;
    plot_info.title         = "Heading Difference";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Heading (deg)";
    plot_info.legend        = {"State to Dual Antenna", "State to Velocity", "Dual Antenna to Velocity"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [-2,2];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1) - log_data.state.utc_time_min;
    times.time2             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.time3             = log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.state.orientation(find_closest_time_vector_fast(log_data.state.unix_time_seconds, log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1)),3) - log_data.raw_gnss.heading(log_data.raw_gnss.status.time_valid == 1);
    input_vectors.inp1(input_vectors.inp1 > 180) = input_vectors.inp1(input_vectors.inp1 > 180) - 360;
    input_vectors.inp2      = log_data.state.orientation(:,3) - calculate_velocity_heading(log_data.state.velocity);
    input_vectors.inp2(input_vectors.inp2 > 180) = input_vectors.inp2(input_vectors.inp2 > 180) - 360;
    input_vectors.inp3      = log_data.raw_gnss.heading(log_data.raw_gnss.status.time_valid == 1) - calculate_velocity_heading(log_data.raw_gnss.velocity(log_data.raw_gnss.status.time_valid == 1,:));
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

end

