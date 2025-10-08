function dist_err = Plot_Position_Error_With_GNSS_Truth(log_data, plot_options)
%This function provides a standard method of calculating and displaying
%error over distance travelled.  This utilizes the raw GNSS packet to
%provide a source of truth for comparison, as well as the state packet to
%provide a self position estimate.  Useful for analyzing free inertial
%performance.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output
    dist_err    = [];

    %Grab structs in log file
    fields      = fieldnames(log_data);

    %Make sure state struct exists
    if(isempty( find( contains(fields, "state") == 1) ) )
        error("State struct does not exist in log_data");
    elseif(isempty( find( contains(fields, "raw_gnss") == 1) ) )
        error("Raw GNSS struct does not exist in log_data");
    end

    %Initialize dist_travel
    dist_travel = zeros(size(log_data.raw_gnss.position(:,1)));

    %Set figure name
    fig_names = {"Error Over Distance Travelled"};

    %*********************************************************************%
    %Plot Error over Distance Travelled
    %*********************************************************************%

    %Create figure
    dist_err                = figure('Name',fig_names{1});

    %Subplot
    subplot(3,1,1)
    
    %Capture positional error
    [pos_error, time]       = distance_between_lat_lon_vectors(log_data.raw_gnss.position(:,1:2), log_data.raw_gnss.unix_time_seconds, ...
                                                               log_data.state.position(:,1:2), log_data.state.unix_time_seconds);

    %Filter our duplicate times
    time_mask = zeros(size(time));
    for i = 2:length(time)
        if(time(i) ~= time(i-1) && time(i) ~= 0)
            time_mask(i) = 1;
        end
    end

    %Convert to a logical
    time_mask = logical(time_mask);

    %Make input vectors
    times                   = [];
    times.time1             = time(time_mask) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = pos_error(time_mask);
    
    %Make Plot Info
    plot_info.create_figure = 0;
    plot_info.title         = "Positional Error:  State vs Raw GNSS (time synchronized)";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Positional Error (m)";
    plot_info.legend        = [];
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make plot
    dist_err                = Plot_Time_History(times, input_vectors, plot_info);
    
    %Copy lims
    xlims_copy              = xlim;

    %Start distsance travelled plot
    subplot(3,1,2)
    
    %Capture all start and stops of GNSS
    LOSS_IND    = 1;
    GAIN_IND    = 1;
    gnss_gain_indecies = [];
    gnss_loss_indecies = [];
    if(log_data.raw_gnss.status.fix_type(1) == 0)
        gnss_loss_indecies(LOSS_IND) = 1;
        LOSS_IND    = 2;
        find_gain   = 1;
        find_loss   = 0;
    else
        find_gain   = 0;
        find_loss   = 1;
    end
    for i = 2:length(log_data.raw_gnss.status.fix_type)
        
        %Look for GNSS stoppage
        if(log_data.raw_gnss.status.fix_type(i-1) > 0 &&...
           log_data.raw_gnss.status.fix_type(i) == 0 && ...
           find_loss)
            gnss_loss_indecies(LOSS_IND)    = i-1;
            find_gain                       = 1;
            find_loss                       = 0;
            LOSS_IND                        = LOSS_IND + 1;
        end

        %Look for GNSS Signal
        if(log_data.raw_gnss.status.fix_type(i-1) == 0 &&...
           log_data.raw_gnss.status.fix_type(i) > 0 && ...
           find_gain)
            gnss_gain_indecies(GAIN_IND)    = i;
            find_gain                       = 0;
            find_loss                       = 1;
            GAIN_IND                        = GAIN_IND + 1;
        end

    end

    %Step through indecies and calculate distance travelled
    for i = 1:length(gnss_gain_indecies)

        %Capture indecies
        ind_delta               = gnss_gain_indecies(i) - gnss_loss_indecies(i)+1;
        ind_range               = gnss_loss_indecies(i):gnss_gain_indecies(i);

        %If the index range is too small, skip
        if(ind_delta >= 200)

            %Capture distance travelled
            dist_travel(ind_range)  = Calculate_Distance_Travelled(log_data.raw_gnss.position(ind_range,1:2));
        end

    end

    %If GNSS is never regained, recalaulte distance travelled here
    if(length(gnss_loss_indecies) > length(gnss_gain_indecies) && ...
       (length(gnss_gain_indecies) == 0 || ...
       gnss_loss_indecies(end) > gnss_gain_indecies(end)))
        
        %Capture indecies
        ind_delta               = length(log_data.raw_gnss.status.fix_type) - gnss_loss_indecies(end) + 1;
        ind_range               = gnss_loss_indecies(end):length(log_data.raw_gnss.status.fix_type);

        %Capture distance travelled
        dist_travel(ind_range)  = Calculate_Distance_Travelled(log_data.raw_gnss.position(ind_range,1:2));
    end

    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = dist_travel/1000;
    
    %Make Plot Info
    plot_info.create_figure = 0;
    plot_info.title         = "Distance Travelled (Raw GNSS)";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Distance (km)";
    plot_info.legend        = [];
    plot_info.lims_x        = [xlims_copy];
    plot_info.lims_y        = [];
    
    %Make plot
    dist_err                = Plot_Time_History(times, input_vectors, plot_info);
    
    %Start error over distance travelled plot
    subplot(3,1,3)
    
    %Make input vectors
    times                   = [];
    times.time1             = log_data.raw_gnss.unix_time_seconds(time_mask) - log_data.state.utc_time_min;
    
    input_vectors           = [];
    input_vectors.inp1      = pos_error(time_mask)./dist_travel(time_mask)*100;
    
    %Make Plot Info
    plot_info.create_figure = 0;
    plot_info.title         = "Error over distance travelled";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Percent (%)";
    plot_info.legend        = [];
    plot_info.lims_x        = [xlims_copy];
    plot_info.lims_y        = [];
    
    %Make plot
    dist_err                = Plot_Time_History(times, input_vectors, plot_info);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(dist_err, fig_names);
    end

end

