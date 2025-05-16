function figs = Plot_GNSS_Status(log_data, time_type_in)
%PLOT_GNSS_STATUS Plots important information to understand GNSS
%performance

    %Inputs: log data struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Set booleans
    raw_gnss_exist              = 0;
    satellites_exist            = 0;
    extended_satellites_exist   = 0;
    

    %Initialize figs
    figs                       = [];

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        %Set time type
        time_type = time_type_in;

    else

        %Default to duration seconds
        time_type = 2;

    end

    %Determine what structs exist
    log_fields = fields(log_data);

     %Look for satellites
    if( ~isempty( find( contains(log_fields,'satellites') == 1 ) ) )
        
        %Set raw_gnss exist
        raw_gnss_exist = 1;

        %Grab raw_gnss plotting time
        if(time_type == 1) %date time
            plotting_time_raw_gnss      = log_data.raw_gnss.datetime;
        elseif(time_type == 2) %duration
            plotting_time_raw_gnss      = log_data.raw_gnss.duration_seconds;
        elseif(time_type == 3) %UTC time
            plotting_time_raw_gnss      = log_data.raw_gnss.unix_time_seconds;
        end

    end
    
    %Look for satellites
    if( ~isempty( find( contains(log_fields,'satellites') == 1 ) ) )
        
        %Set satellites exist
        satellites_exist = 1;

        %Grab satellites plotting time
        if(time_type == 1) %date time
            plotting_time_sat       = log_data.satellites.datetime;
        elseif(time_type == 2) %duration
            plotting_time_sat       = log_data.satellites.duration_seconds;
        elseif(time_type == 3) %UTC time
            plotting_time_sat       = log_data.satellites.unix_time_seconds;
        end

    end

    %Look for detailed satellites
    if( ~isempty( find( contains(log_fields,'extended_satellites') == 1 ) ) )

        %Set extended satellites exist
        extended_satellites_exist = 1;

        %Grab satellites plotting time
        if(time_type == 1) %date time
            plotting_time_extsat    = log_data.extended_satellites.datetime;
        elseif(time_type == 2) %duration
            plotting_time_extsat    = log_data.extended_satellites.duration_seconds;
        elseif(time_type == 3) %UTC time
            plotting_time_extsat    = log_data.extended_satellites.unix_time_seconds;
        end

    end

    %*********************************************************************%
    %GNSS Status - CEP50
    %*********************************************************************%

    %Call Plot CEP 50 if raww gnss exists
    if(raw_gnss_exist)
        figs(1) = Plot_CEP_2D(log_data.raw_gnss.position(:,1:2), 0.50);
    end

    %*********************************************************************%
    %GNSS Status - Status Overview
    %*********************************************************************%

    %Create GNSS status figure if raw gnss exists
    if(raw_gnss_exist)

        %Create figure
        figs(2) = figure('Name','GNSS Status - Status Overview');
    
        %GNSS Fix Type
	    axes1 = subplot(2,2,1);
	    plot(plotting_time_raw_gnss, log_data.raw_gnss.status.fix_type);
	    title('GNSS Fix Type');
	    ylabel('Fix Type');
	    xlabel('Seconds');
	    ylim([0,7]);
	    set(axes1,'YTickLabel',...
		    {'No Fix (0)','2D Fix (1)','3D Fix (2)','SBAS Fix (3)','Differential Fix (4)','Omnistar Fix (5)','RTK Float (6)','RTK Fix (7)'});
    
        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14);
    
        %Doppler velocity valid
        if(isfield(log_data.raw_gnss.status, 'doppler_velocity_valid'))
            subplot(4,4,3);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.doppler_velocity_valid);
	        title('Doppler Velocity Valid');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %External GNSS
        if(isfield(log_data.raw_gnss.status, 'external_gnss'))
            subplot(4,4,4);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.external_gnss);
	        title('External GNSS');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Heading Valid
        if(isfield(log_data.raw_gnss.status, 'heading_valid'))
            subplot(4,4,7);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.heading_valid);
	        title('Heading Valid');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Floating Heading
        if(isfield(log_data.raw_gnss.status, 'floating_heading'))
            subplot(4,4,8);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.floating_heading);
	        title('Floating Heading');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Antenna 1 Disconnected
        if(isfield(log_data.raw_gnss.status, 'antenna1_disconnected'))
            subplot(4,4,9);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.antenna1_disconnected);
	        title('Antenna 1 Disconnected');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Antenna 2 Disconnected
        if(isfield(log_data.raw_gnss.status, 'antenna2_disconnected'))
            subplot(4,4,10);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.antenna2_disconnected);
	        title('Antenna 2 Disconnected');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Antenna 1 Short
        if(isfield(log_data.raw_gnss.status, 'antenna1_short'))
            subplot(4,4,11);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.antenna1_short);
	        title('Antenna 1 Short');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %Antenna 2 Short
        if(isfield(log_data.raw_gnss.status, 'antenna2_short'))
            subplot(4,4,12);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.antenna2_short);
	        title('Antenna 2 Short');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %GNSS 1 Failure
        if(isfield(log_data.raw_gnss.status, 'gnss1_failure'))
            subplot(4,4,13);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.gnss1_failure);
	        title('GNSS 1 Failure');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end
    
        %GNSS 2 Failure
        if(isfield(log_data.raw_gnss.status, 'gnss2_failure'))
            subplot(4,4,14);
	        plot(plotting_time_raw_gnss, log_data.raw_gnss.status.gnss2_failure);
	        title('GNSS 2 Failure');
	        xlabel('Seconds');
        
            %Set font 14 bold
            set(gca, 'FontWeight', 'bold', 'FontSize', 14);
        end

    end

    %*********************************************************************%
    %GNSS Status - Plot Satellites Data
    %*********************************************************************%

    %Plot satellites if they exist
    if(satellites_exist)

         %Create GNSS status figure
        figs(3) = figure('Name','GNSS Status - Satellites Data Overview');

        %Subplot - HDOP & VDOP plot
        subplot(2,1,1);

        %Create plot info struct
        plot_info_input.create_figure   = 0;
        plot_info_input.lims_x          = [];
        plot_info_input.lims_y          = [];
        plot_info_input.title           = "HDOP & VDOP";
        plot_info_input.x_label         = "Time (s)";
        plot_info_input.y_label         = "HDOP & VDOP";
        plot_info_input.legend          = {"HDOP", ...
                                           "VDOP"};
    
        %Gather times
        times                           = [];
        times.hdop                      = plotting_time_sat;
        times.vdop                      = plotting_time_sat;
    
        %Gather input vectors
        input_vectors                   = [];
        input_vectors.hdop              = log_data.satellites.hdop;
        input_vectors.vdop              = log_data.satellites.vdop;
        
        %Call plot time history mask function
        time_hist = Plot_Time_History(times, input_vectors, plot_info_input);

        %Subplot - Satellites Plot
        subplot(2,1,2);

        %Create plot info struct
        plot_info_input.create_figure   = 0;
        plot_info_input.lims_x          = [];
        plot_info_input.lims_y          = [];
        plot_info_input.title           = "Satellites In View";
        plot_info_input.x_label         = "Time (s)";
        plot_info_input.y_label         = "Satellites";
        plot_info_input.legend          = {"GPS", "Glonas", "Beidou", ...
                                           "Gelileo", "SBAS", "Total"};
    
        %Gather times
        times                           = [];
        times.GPS                       = plotting_time_sat;
        times.Glonas                    = plotting_time_sat;
        times.Beidou                    = plotting_time_sat;
        times.Gelileo                   = plotting_time_sat;
        times.SBAS                      = plotting_time_sat;
        times.Total                     = plotting_time_sat;
    
        %Gather input vectors
        input_vectors                   = [];
        input_vectors.GPS               = log_data.satellites.gps_satellites;
        input_vectors.Glonas            = log_data.satellites.glonass_satellites;
        input_vectors.Beidou            = log_data.satellites.beidou_satellites;
        input_vectors.Gelileo           = log_data.satellites.galileo_satellites;
        input_vectors.SBAS              = log_data.satellites.sbas_satellites;
        input_vectors.Total             = log_data.satellites.total_satellites;
        
        %Call plot time history mask function
        time_hist = Plot_Time_History(times, input_vectors, plot_info_input);

    end

end

