function gnss_vs_state_figs = Plot_Raw_GNSS_vs_State_Position(log_data, plot_options)
%*************************************************************************%
%Common plotting function for visualizing Raw GNSS positions vs State
%Position
%*************************************************************************%

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Initialize output
    gnss_vs_state_figs = [];

    %Grab structs in log file
    fields  = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end

    %Set figure name
    fig_names = {"Raw GNSS vs State Position"};
    
    %*********************************************************************%
    %State position vs GNSS position
    %*********************************************************************%
    
    %Grab positions & times
    positions           = [];
    positions.input_1   = log_data.state.position(:,1:2);
    positions.input_2   = log_data.raw_gnss.position(:,1:2);
    
    times               = [];
    times.input_1       = log_data.state.unix_time_seconds - log_data.state.utc_time_min;
    times.input_2       = log_data.raw_gnss.unix_time_seconds - log_data.state.utc_time_min;
    
    %Make Plot Info
    plot_info.title         = "Position History (Lat,Long)";
    plot_info.figure_name   = fig_names{1};
    plot_info.x_label       = "Latitude";
    plot_info.y_label       = "Longitude";
    plot_info.legend        = {"State Position", "Raw GNSS Position"};
    
    %Call position history function
    gnss_vs_state_figs  = Plot_Position_History(positions, times, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(gnss_vs_state_figs, fig_names);
    end

end