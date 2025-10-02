function hist_pos_fig = Plot_Time_History_State_vs_Raw_GNSS_Position(log_data)
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
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end

    %*********************************************************************%
    %Make Video
    %*********************************************************************%

    %Plot position history in time
    positions.input_1   = log_data.state.position(:,1:2);
    positions.input_2   = log_data.raw_gnss.position(log_data.raw_gnss.status.time_valid == 1,1:2);
    heading.input_1     = log_data.state.orientation(:,3);
    heading.input_2     = log_data.raw_gnss.heading(log_data.raw_gnss.status.time_valid == 1,:);
    times.input_1       = log_data.state.duration_seconds(:);
    times.input_2       = log_data.raw_gnss.duration_seconds(log_data.raw_gnss.status.time_valid == 1);
    
    %Select video options
    plot_info.frames_per_second     = 10;
    plot_info.frame_time_step       = 1;
    plot_info.frame_time_width      = 10;

    %Define plotting options
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    plot_info.title         = "Raw GNSS vs State Position Video";
    plot_info.legend        = {"State Position", "Raw GNSS Position", "State Heading", "Raw GNSS Velocity Heading"};

    %Call plot position history in time
    hist_pos_fig            = Plot_Position_History_In_Time(positions, heading, times, plot_info);

end

