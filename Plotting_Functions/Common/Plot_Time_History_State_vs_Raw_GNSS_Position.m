function hist_pos_fig = Plot_Time_History_State_vs_Raw_GNSS_Position(log_data, plot_options)
%This function provides a standard method of calculating and displaying
%error over distance travelled.  This utilizes the raw GNSS packet to
%provide a source of truth for comparison, as well as the state packet to
%provide a self position estimate.  Useful for analyzing free inertial
%performance.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output
    hist_pos_fig    = [];

    %Grab structs in log file
    fields          = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) &&...
            plot_options.make_video_position_history.type == 0)
        error("Raw GNSS struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "external_position") == 1) ) &&...
            plot_options.make_video_position_history.type == 1)
        error("External Position struct does not exist in log_data");
    end

    %Determine what position source is being used
    if(plot_options.make_video_position_history.type == 0)
        
        %Raw GNSS
        external_position       = log_data.raw_gnss.position(log_data.raw_gnss.status.time_valid == 1,1:2);
        external_heading        = log_data.raw_gnss.heading(log_data.raw_gnss.status.time_valid == 1,:);
        external_time           = log_data.raw_gnss.unix_time_seconds(log_data.raw_gnss.status.time_valid == 1);
        external_utc_time_min   = log_data.raw_gnss.utc_time_min;
    
    elseif(plot_options.make_video_position_history.type == 1)
       
        %External Position
        external_position       = log_data.external_position.position;
        external_time           = log_data.external_position.unix_time_seconds;
        external_utc_time_min   = log_data.external_position.utc_time_min;

        %Derive heading
        %Mask for unique positions
        %Mask for actual external position jumps
        mask_pos_jumps      = diff(log_data.external_position.position(:,1)) ~= 0.0 & diff(log_data.external_position.position(:,2)) ~= 0;
        mask_pos_jumps      = [0; mask_pos_jumps];
        mask_pos_jumps      = logical(mask_pos_jumps);
        
        %Reset position to only include where time updates occur
        external_position           = external_position(mask_pos_jumps,:);
        external_time               = external_time(mask_pos_jumps);

        %Generate time masks
        [state_time, position_time]     = find_closest_time_vector_fast(log_data.state.unix_time_seconds, external_time);
    
        %Grab Velocity
        external_velocity   = calculate_velocity_from_position(external_position, external_time);

        %Calcualte Heading
        external_heading    = calculate_velocity_heading(external_velocity.vel(position_time.mask,:));

    end

    %*********************************************************************%
    %Make Video
    %*********************************************************************%

    %Plot position history in time
    positions.input_1   = log_data.state.position(:,1:2);
    positions.input_2   = external_position;
    heading.input_1     = log_data.state.orientation(:,3);
    heading.input_2     = external_heading;
    times.input_1       = log_data.state.unix_time_seconds(:) - log_data.state.utc_time_min;
    times.input_2       = external_time - external_utc_time_min;
    
    %Select video options
    plot_info.frames_per_second     = 30;
    plot_info.frame_time_step       = 0.1;
    plot_info.frame_time_width      = 10;

    %Define plotting options
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    plot_info.title         = "Raw GNSS vs State Position Video";
    plot_info.legend        = {"State Position", "Raw GNSS Position", "State Heading", "Raw GNSS Velocity Heading"};

    %Call plot position history in time
    hist_pos_fig            = Plot_Position_History_In_Time(positions, heading, times, state_time, plot_info);

end

