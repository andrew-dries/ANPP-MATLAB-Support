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
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) && plot_options.plot_heading_analysis.type == 0 )
        error("Raw GNSS struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "external_position") == 1) ) && plot_options.plot_heading_analysis.type == 1 )
        error("External Position struct does not exist in log_data");
    end

    %Determine position source
    if(plot_options.plot_heading_analysis.type == 0)
        position       = log_data.raw_gnss;
    elseif(plot_options.plot_heading_analysis.type == 1)
        position       = log_data.external_position;
    elseif(plot_options.plot_heading_analysis.type == 2)
        position       = log_data.state;
    end
    
    %Use find closest time vector & perform other housekeeping
    if(plot_options.plot_heading_analysis.type == 0)

        %Find closest time vector
        [state_time, position_time]     = find_closest_time_vector_fast(log_data.state.unix_time_seconds, position.unix_time_seconds(position.status.time_valid == 1));

        %Set GNSS heading to go from 0 to 360 instead of -180 to 180
        position.heading( position.heading < 0) = position.heading( position.heading < 0) + 360;

    elseif(plot_options.plot_heading_analysis.type == 1)
        
        %Mask for unique positions
        %Mask for actual external position jumps
        mask_pos_jumps      = diff(log_data.external_position.position(:,1)) ~= 0.0 & diff(log_data.external_position.position(:,2)) ~= 0.0;
        mask_pos_jumps      = [0; mask_pos_jumps];
        mask_pos_jumps      = logical(mask_pos_jumps);
        
        %Reset position to only include where time updates occur
        position.position           = position.position(mask_pos_jumps,:);
        position.unix_time_seconds  = position.unix_time_seconds(mask_pos_jumps);

        %Generate time masks
        [state_time, position_time]     = find_closest_time_vector_fast(log_data.state.unix_time_seconds, position.unix_time_seconds);
    
        %Grab Velocity
        velocity                        = calculate_velocity_from_position(position.position, position.unix_time_seconds);
        position.velocity               = velocity.vel;

    elseif(plot_options.plot_heading_analysis.type == 2)
        [state_time, position_time]     = find_closest_time_vector_fast(log_data.state.unix_time_seconds, position.unix_time_seconds);
    end

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
    if(plot_options.plot_heading_analysis.type == 0)
    times.time2             = position.unix_time_seconds(position_time.mask) - log_data.state.utc_time_min;
    end
    times.time3             = position.unix_time_seconds(position_time.mask) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = log_data.state.orientation(:,3);
    if(plot_options.plot_heading_analysis.type == 0)
    input_vectors.inp2      = position.heading(position_time.mask);
    end
    input_vectors.inp3      = calculate_velocity_heading(position.velocity(position_time.mask,:));

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
    input_vectors           = [];

    %State Heading vs Raw GNSS Dual GNSS Heading
    if(plot_options.plot_heading_analysis.type == 0)
        times.time1             = position.unix_time_seconds(position_time.mask) - log_data.state.utc_time_min;
        input_vectors.inp1      = log_data.state.orientation(state_time.mask,3) - position.heading(position_time.mask);
        input_vectors.inp1(input_vectors.inp1 > 180) = input_vectors.inp1(input_vectors.inp1 > 180) - 360;
    end

    %State Heading vs Derived Velocity Heading
    times.time2             = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    input_vectors.inp2      = log_data.state.orientation(:,3) - calculate_velocity_heading(log_data.state.velocity);
    input_vectors.inp2(input_vectors.inp2 > 180) = input_vectors.inp2(input_vectors.inp2 > 180) - 360;
   
    %Dual GNSS Heading vs Derived Velocity Heading
    if(plot_options.plot_heading_analysis.type == 1)
        times.time3             = position.unix_time_seconds(position_time.mask) - log_data.state.utc_time_min;
        input_vectors.inp3      = log_data.state.orientation(state_time.mask,3) - calculate_velocity_heading(position.velocity.vel(position_time.mask,:));
        input_vectors.inp3(input_vectors.inp3 > 180) = input_vectors.inp3(input_vectors.inp3 > 180) - 360;
    end

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