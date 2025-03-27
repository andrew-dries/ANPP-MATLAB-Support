function figs = Plot_GNSS_Status(log_data, time_type)
%PLOT_GNSS_STATUS Plots important information to understand GNSS
%performance

    %Inputs: log data struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(time_type == 1) %date time
            plotting_time   = log_data.raw_sensors.datetime;
        elseif(time_type == 2) %duration
            plotting_time   = log_data.raw_sensors.duration_seconds;
        elseif(time_type == 3) %UTC time
            plotting_time   = log_data.raw_sensors.unix_time_seconds;
        end

    else

        %Default to duration seconds
        plotting_time   = log_data.raw_sensors.duration_seconds;

    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Raw GNSS Position
    figs(1) = figure('Name','Report Page 1 - Raw Sensors');
	subplot(2,2,1);
	plot(plotting_time, log_data.raw_sensors.gyroscopes, ".", 'DisplayName',"raw_sensors.gyroscopes");
	title('XYZ Gyroscopes');
	ylabel('Status');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %TBD

end

