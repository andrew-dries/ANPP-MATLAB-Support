function figs = Plot_Dual_GNSS_Heading(raw_gnss, time_type)
%Plot_Dual_GNSS_Heading Plots important information to understand Dual GNSS
%Heading performance

    %Inputs: raw_gnss struct, time type
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(time_type == 1) %date time
            plotting_time   = raw_gnss.datetime;
        elseif(time_type == 2) %duration
            plotting_time   = raw_gnss.duration_seconds;
        elseif(time_type == 3) %Unix Time
            plotting_time   = raw_gnss.unix_time_seconds;
        end

    else

        %Default to duration seconds
        plotting_time   = raw_gnss.duration_seconds;

    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create figure
    figure('Name','Dual GNSS Heading - Heading Performance');
    subplot(2,2,2);

    %Dual GNSS Heading Status
    plot_info_input.create_figure   = 0;
    plot_info_input.lims_x          = [];
    plot_info_input.lims_y          = [];
    plot_info_input.title           = "Dual GNSS Heading Status";
    plot_info_input.x_label         = "Time (s)";
    plot_info_input.y_label         = "Heading (deg)";
    plot_info_input.legend          = {"Heading Valid - Floating Heading Off", ...
                                       "Heading Valid - Floating Heading On", ...
                                       "Heading Invalid"};

    %Create masks
    masks(:,1) = raw_gnss.status.heading_valid == 1 & raw_gnss.status.floating_heading == 0 & raw_gnss.status.time_valid == 1;
    masks(:,2) = raw_gnss.status.heading_valid == 1 & raw_gnss.status.floating_heading == 1 & raw_gnss.status.time_valid == 1;
    masks(:,3) = raw_gnss.status.heading_valid == 0 & raw_gnss.status.time_valid == 1;
    
    %Call plot time history mask function
    Plot_Time_History_Mask(plotting_time, raw_gnss.heading, masks, plot_info_input);

    %Create Dual GNSS heading vs position plot
    subplot(1,2,1)
    Plot_Dual_GNSS_Heading_Vs_Position(raw_gnss, 0);

    %Create Dual GNSS heading Stddev fix type vs time plot
    subplot(2,2,4)
    Plot_Dual_GNSS_Heading_Stddev_FixType_Vs_Time(plotting_time, raw_gnss, 0);

    %Create GNSS status figure
    figs(2) = figure('Name','Dual GNSS Heading - Heading Status');

    %GNSS Fix Type
	axes1 = subplot(2,2,1);
	plot(plotting_time, raw_gnss.status.fix_type);
	title('GNSS Fix Type');
	ylabel('Fix Type');
	xlabel('Seconds');
	ylim([0,7]);
	set(axes1,'YTickLabel',...
		{'No Fix (0)','2D Fix (1)','3D Fix (2)','SBAS Fix (3)','Differential Fix (4)','Omnistar Fix (5)','RTK Float (6)','RTK Fix (7)'});

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

    %Doppler velocity valid
    if(isfield(raw_gnss.status, 'doppler_velocity_valid'))
        subplot(4,4,3);
	    plot(plotting_time, raw_gnss.status.doppler_velocity_valid);
	    title('Doppler Velocity Valid');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %External GNSS
    if(isfield(raw_gnss.status, 'external_gnss'))
        subplot(4,4,4);
	    plot(plotting_time, raw_gnss.status.external_gnss);
	    title('External GNSS');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Heading Valid
    if(isfield(raw_gnss.status, 'heading_valid'))
        subplot(4,4,7);
	    plot(plotting_time, raw_gnss.status.heading_valid);
	    title('Heading Valid');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Floating Heading
    if(isfield(raw_gnss.status, 'floating_heading'))
        subplot(4,4,8);
	    plot(plotting_time, raw_gnss.status.floating_heading);
	    title('Floating Heading');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Antenna 1 Disconnected
    if(isfield(raw_gnss.status, 'antenna1_disconnected'))
        subplot(4,4,9);
	    plot(plotting_time, raw_gnss.status.antenna1_disconnected);
	    title('Antenna 1 Disconnected');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Antenna 2 Disconnected
    if(isfield(raw_gnss.status, 'antenna2_disconnected'))
        subplot(4,4,10);
	    plot(plotting_time, raw_gnss.status.antenna2_disconnected);
	    title('Antenna 2 Disconnected');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Antenna 1 Short
    if(isfield(raw_gnss.status, 'antenna1_short'))
        subplot(4,4,11);
	    plot(plotting_time, raw_gnss.status.antenna1_short);
	    title('Antenna 1 Short');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %Antenna 2 Short
    if(isfield(raw_gnss.status, 'antenna2_short'))
        subplot(4,4,12);
	    plot(plotting_time, raw_gnss.status.antenna2_short);
	    title('Antenna 2 Short');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %GNSS 1 Failure
    if(isfield(raw_gnss.status, 'gnss1_failure'))
        subplot(4,4,13);
	    plot(plotting_time, raw_gnss.status.gnss1_failure);
	    title('GNSS 1 Failure');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end

    %GNSS 2 Failure
    if(isfield(raw_gnss.status, 'gnss2_failure'))
        subplot(4,4,14);
	    plot(plotting_time, raw_gnss.status.gnss2_failure);
	    title('GNSS 2 Failure');
	    xlabel('Seconds');
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    end
    
end