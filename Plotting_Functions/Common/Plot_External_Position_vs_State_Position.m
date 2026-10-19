function external_position_vs_state_figs = Plot_External_Position_vs_State_Position(log_data, plot_options)
%*************************************************************************%
%Common plotting function for visualizing Raw GNSS positions vs State
%Position
%*************************************************************************%

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Initialize output
    external_position_vs_state_figs = [];

    %Grab structs in log file
    fields  = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "external_position") == 1) ) )
        error("External Position struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"External Position vs State Position", "External Unique Positions"};
    
    %*********************************************************************%
    %State position vs GNSS position
    %*********************************************************************%
    
    %Mask for unique positions
    %Mask for actual external position jumps
    mask_pos_jumps      = diff(log_data.external_position.position(:,1)) ~= 0.0 & diff(log_data.external_position.position(:,2)) ~= 0;
    mask_pos_jumps      = [0; mask_pos_jumps];
    mask_pos_jumps      = logical(mask_pos_jumps);
    % mask_pos_jumps      = logical(ones(length(log_data.external_position.position),1));

    %Grab positions & times
    positions           = [];
    positions.input_1   = log_data.state.position(:,1:2);
    positions.input_2   = log_data.external_position.position(mask_pos_jumps,1:2);
    
    times               = [];
    times.input_1       = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.input_2       = log_data.external_position.unix_time_seconds(mask_pos_jumps) - log_data.state.utc_time_min;
    
    %Make Plot Info
    plot_info.title         = "Position History (Lat,Long)";
    plot_info.figure_name   = fig_names{1};
    plot_info.x_label       = "Latitude";
    plot_info.y_label       = "Longitude";
    plot_info.legend        = {"State Position", "External Position"};
    
    %Call position history function
    external_position_vs_state_figs(1)  = Plot_Position_History(positions, times, plot_info);

    %*********************************************************************%
    %Analyze Unique Exernal Poitions
    %*********************************************************************%
    
    %Make Plot Info
    external_position_vs_state_figs(2) = figure('Name',fig_names{2});
    
    %Suplot
    subplot(2,1,2);

    %Unique Counts
    plot_info.create_figure = 0;
    plot_info.title         = "External Position Unique Readings";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "bool - unique";
    plot_info.legend        = {"External Position Unique Readings"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = [0,1];
    
    input_vectors           = [];
    input_vectors.inp1      = [length(log_data.external_position.position(:,2)), length( find( mask_pos_jumps == 1 ) )] ;

    %Make plot
    external_position_vs_state_figs(2)     = Plot_Time_History(times, input_vectors, plot_info);

    %Suplot
    subplot(2,1,1);

    %Unique Counts
    plot_info.create_figure = 0;
    plot_info.title         = "External Position Unique Readings";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "bool - unique";
    plot_info.legend        = {"External Position Unique Readings"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.external_position.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = double([0; diff(log_data.external_position.position(:,1)) + diff(log_data.external_position.position(:,2))] ~= 0);

    %Make plot
    external_position_vs_state_figs(2)     = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(external_position_vs_state_figs, fig_names);
    end

end