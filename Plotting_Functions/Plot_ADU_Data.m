function figs = Plot_ADU_Data(adu_data, wind_data, state_data, raw_gnss, time_type)
%Plot_ADU_Data Plots important information to understand the performance of
%the ADU

    %Inputs: adu structg, wind struct, state struct, raw_gnss struct, time type
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(time_type == 1) %date time
            plotting_time_adu       = adu_data.datetime;
            plotting_time_wind      = wind_data.datetime;
            plotting_time_state     = state_data.datetime;
            plotting_time_gnss      = raw_gnss.datetime;
        elseif(time_type == 2) %duration
            plotting_time_adu       = adu_data.duration_seconds;
            plotting_time_wind      = wind_data.duration_seconds;
            plotting_time_state     = state_data.duration_seconds;
            plotting_time_gnss      = raw_gnss.duration_seconds;
        elseif(time_type == 3) %Unix Time
            plotting_time_adu       = adu_data.unix_time_seconds;
            plotting_time_wind      = wind_data.unix_time_seconds;
            plotting_time_state     = state_data.unix_time_seconds;
            plotting_time_gnss      = raw_gnss.unix_time_seconds;
        end

    else

        %Default to duration seconds
        plotting_time_adu       = adu_data.duration_seconds;
        plotting_time_wind      = wind_data.duration_seconds;
        plotting_time_state     = state_data.duration_seconds;
        plotting_time_gnss      = raw_gnss.duration_seconds;

    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create figure
    figs(1) = figure('Name','Air Data Unit Status');
    subplot(2,2,1);

    %ADU vs State vs GNSS
    plot_info_input.create_figure   = 0;
    plot_info_input.lims_x          = [];
    plot_info_input.lims_y          = [];
    plot_info_input.title           = "ADU vs State vs GNSS";
    plot_info_input.x_label         = "Time (s)";
    plot_info_input.y_label         = "Velocity (m/s)";
    plot_info_input.legend          = {"ADU Air Speed", ...
                                       "Raw GNSS Velocity", ...
                                       "State Velocity"};

    %Gather times
    times.adu                       = plotting_time_adu;
    times.state                     = plotting_time_state;
    times.gnss                      = plotting_time_gnss;

    %Gather input vectors
    input_vectors.adu               = adu_data.airspeed;
    input_vectors.state             = sqrt(state_data.velocity(:,1).^2 + state_data.velocity(:,2).^2 + state_data.velocity(:,3).^2);
    input_vectors.gnss              = sqrt(raw_gnss.velocity(:,1).^2 + raw_gnss.velocity(:,2).^2 + raw_gnss.velocity(:,3).^2);
    
    %Call plot time history mask function
    hist_fig1 = Plot_Time_History(times, input_vectors, plot_info_input);

    %Subplot 2
    subplot(2,2,2);

    %Windspeed
    plot_info_input.create_figure   = 0;
    plot_info_input.lims_x          = [];
    plot_info_input.lims_y          = [];
    plot_info_input.title           = "Windspeed";
    plot_info_input.x_label         = "Time (s)";
    plot_info_input.y_label         = "Windspeed (m/s)";
    plot_info_input.legend          = {"Wind North", ...
                                       "Wind East"};

    %Gather times
    times                           = [];
    times.wind_north                = plotting_time_wind;
    times.wind_east                 = plotting_time_wind;

    %Gather input vectors
    input_vectors                   = [];
    input_vectors.wind_north        = wind_data.velocity(:,1);
    input_vectors.wind_east         = wind_data.velocity(:,2);
    
    %Call plot time history mask function
    hist_fig2 = Plot_Time_History(times, input_vectors, plot_info_input);

    %Air Speed Valid
    if(isfield(adu_data.system_status, 'airspeed_valid'))
        subplot(4,3,7);
	    plot(plotting_time_adu, adu_data.system_status.airspeed_valid);
	    title('Air Speed Valid');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Air Speed Overrange
    if(isfield(adu_data.system_status, 'airspeed_overrange'))
        subplot(4,3,8);
	    plot(plotting_time_adu, adu_data.system_status.airspeed_overrange);
	    title('Air Speed Overrange');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Air Speed Sensor Failure
    if(isfield(adu_data.system_status, 'airspeed_sensor_failure'))
        subplot(4,3,9);
	    plot(plotting_time_adu, adu_data.system_status.airspeed_sensor_failure);
	    title('Air Speed Sensor Failure');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Altitude Valid
    if(isfield(adu_data.system_status, 'altitude_valid'))
        subplot(4,3,10);
	    plot(plotting_time_adu, adu_data.system_status.altitude_valid);
	    title('Altitude Valid');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Altitude Overrange
    if(isfield(adu_data.system_status, 'altitude_overrange'))
        subplot(4,3,11);
	    plot(plotting_time_adu, adu_data.system_status.altitude_overrange);
	    title('Altitude Overrange');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Altitude Sensor Failure
    if(isfield(adu_data.system_status, 'altitude_sensor_failure'))
        subplot(4,3,12);
	    plot(plotting_time_adu, adu_data.system_status.altitude_sensor_failure);
	    title('Altitude Sensor Failure');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end
    
end