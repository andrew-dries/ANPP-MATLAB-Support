function figs = Plot_State(state, device_information, plot_options)
%Plot State Plots time histories of state inputs

    %Inputs: state struct as output by load_state_log.m
    %        device information struct as output by load_device_information.m
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Determine time type
    if(nargin >= 3)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(plot_options.plotting_time_type == 1) %date time
            plotting_time   = state.datetime;
        elseif(plot_options.plotting_time_type == 2) %duration
            plotting_time   = state.duration_seconds;
        elseif(plot_options.plotting_time_type == 3) %Unix Time
            plotting_time   = state.unix_time_seconds;
        elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
            plotting_time   = state.unix_time_seconds - state.utc_time_min;
        elseif(plot_options.plotting_time_type == 5) %Index
            plotting_time   = [1:length(state.datetime)];
        end

    else

        %Default to date time
        plotting_time   = state.datetime;

    end

    %Set figure names
    fig_names = {"Report Page 1 - State", ...
                 "Report Page 2 - Filter Status", ...
                 "Report Page 3 - System Status"};

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%
    figs(1) = figure('Name',fig_names{1});
	subplot(2,2,1);
	plot(plotting_time,state.orientation, ".");
	title('XYZ Orientation');
	legend('X Roll','Y Pitch','Z Heading');
	ylabel('Degrees');
	xlabel('Seconds');
	ylim([-200,400]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(2,2,2);
	speed = magnitude(state.velocity);
	plot(plotting_time,state.velocity*3.6,plotting_time,speed*3.6);
	legend('North','East','Down','Speed');
	title('Velocity');
	ylabel('Kilometres / hour');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	axes1 = subplot(2,2,3);
	plot(plotting_time,state.filter_status.gnss_fix_type);
	title('GNSS Fix Type');
	ylabel('Fix Type');
	xlabel('Seconds');
	ylim([0,7]);
	set(axes1,'YTickLabel',...
		{'No Fix (0)','2D Fix (1)','3D Fix (2)','SBAS Fix (3)','Differential Fix (4)','Omnistar Fix (5)','RTK Float (6)','RTK Fix (7)'});

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(2,2,4);
	plot(plotting_time(2:end),diff(state.unix_time_seconds),"x");
	title('Diff of Unix Time');
	ylabel('Time gap between samples (s)');
	xlabel('Samples');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	% Report Page 3
    figs(2) = figure('Name',fig_names{2});

	subplot(3,3,1);
	plot(plotting_time,state.filter_status.orientation_initialised);
	title('Orientation Filter Status');
	ylabel('Initialised');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,2);
	plot(plotting_time,state.filter_status.navigation_filter_initialised);
	title('Navigation Filter Status');
	ylabel('Initialised');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,3);
	plot(plotting_time,state.filter_status.heading_initialised);
	title('Heading Filter Status');
	ylabel('Initialised');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,4);
	plot(plotting_time,state.filter_status.utc_time_initialised);
	title('UTC Time Filter Status');
	ylabel('Initialised');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)


	subplot(3,3,5);
	plot(plotting_time,state.filter_status.internal_gnss_enabled);
	title('Internal GNSS Enabled');
	ylabel('Enabled');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,6);
	plot(plotting_time,state.filter_status.magnetometers_enabled);
	if device_information.device_id == 19 || device_information.device_id == 4 || device_information.device_id == 5
		title('Dual Antenna Heading Active');
	else
		title('Magnetometers Enabled or Dual Antenna Heading Active');
	end
	ylabel('Enabled / Active');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,7);
	plot(plotting_time,state.filter_status.velocity_heading_enabled);
	title('Velocity Heading Enabled');
	ylabel('Enabled');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,8);
	plot(plotting_time,state.filter_status.atmospheric_altitude_enabled);
	if device_information.device_id == 19
		title('Dual Antenna Heading Outage +60s');
	else
		title('Atmospheric Altitude Enabled');
	end

	ylabel('Enabled');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(3,3,9);
	plot(plotting_time,state.filter_status.external_position_active);
	hold on;
	plot(plotting_time,state.filter_status.external_velocity_active);
	plot(plotting_time,state.filter_status.external_heading_active);
	hold off;
	title('External Inputs Status');
	legend('Ext Position','Ext Velocity','Ext Heading');
	ylabel('Initialised');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    % Report Page 4
    figs(3) = figure('Name',fig_names{3});

	subplot(4,4,1);
	if max(state.system_status.system_failure) == 1
		plot(plotting_time,state.system_status.system_failure,'r')
    else
        plot(plotting_time,state.system_status.system_failure)
    end
	title('System Failure');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,2);
	if max(state.system_status.accelerometer_failure) == 1
		plot(plotting_time,state.system_status.accelerometer_failure,'r')
    else
        plot(plotting_time,state.system_status.accelerometer_failure)
    end
	title('Accelerometer Failure');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,3);
	if max(state.system_status.gyroscope_failure) == 1
		plot(plotting_time,state.system_status.gyroscope_failure,'r')
    else
        plot(plotting_time,state.system_status.gyroscope_failure)
    end
	title('Gyroscope Failure');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,4);
	if max(state.system_status.magnetometer_failure) == 1
		plot(plotting_time,state.system_status.magnetometer_failure,'r')
    else
        plot(plotting_time,state.system_status.magnetometer_failure)
    end
	title('Magnetometer Failure');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,5);
	if max(state.system_status.pressure_failure) == 1
		plot(plotting_time,state.system_status.pressure_failure,'r')
    else
        plot(plotting_time,state.system_status.pressure_failure)
    end
	if device_information.device_id == 19
		title('Secondary GNSS Failure');
	else
		title('Pressure Failure');
	end
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,6);
	if max(state.system_status.gnss_failure) == 1
		plot(plotting_time,state.system_status.gnss_failure,'r')
    else
        plot(plotting_time,state.system_status.gnss_failure)
    end
	if device_information.device_id == 19
		title('Primary GNSS Failure');
	else
		title('GNSS Failure');
	end
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,7);
	if max(state.system_status.accelerometer_overrange) == 1
		plot(plotting_time,state.system_status.accelerometer_overrange,'r')
    else
        plot(plotting_time,state.system_status.accelerometer_overrange)
    end
	title('Accelerometer Overrange');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,8);
	if max(state.system_status.gyroscope_overrange) == 1
		plot(plotting_time,state.system_status.gyroscope_overrange,'r')
    else
        plot(plotting_time,state.system_status.gyroscope_overrange)
    end
	title('Gyroscope Overrange');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,9);
	if max(state.system_status.magnetometer_overrange) == 1
		plot(plotting_time,state.system_status.magnetometer_overrange,'r')
    else
        plot(plotting_time,state.system_status.magnetometer_overrange)
    end
	title('Magnetometer Overrange');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,10);
	if max(state.system_status.pressure_overrange) == 1
		plot(plotting_time,state.system_status.pressure_overrange,'r')
    else
        plot(plotting_time,state.system_status.pressure_overrange)
    end
	if device_information.device_id == 19
		title('Unused');
	else
		title('Pressure Overrange');
	end
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,11);
	if max(state.system_status.minimum_temperature) == 1
		plot(plotting_time,state.system_status.minimum_temperature,'r')
    else
        plot(plotting_time,state.system_status.minimum_temperature)
    end
	title('Minimum Temperature Alarm');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,12);
	if max(state.system_status.maximum_temperature) == 1
		plot(plotting_time,state.system_status.maximum_temperature,'r')
    else
        plot(plotting_time,state.system_status.maximum_temperature)
    end
	title('Maximum Temperature Alarm');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,13);
	if max(state.system_status.low_voltage) == 1
		plot(plotting_time,state.system_status.low_voltage,'r')
    else
        plot(plotting_time,state.system_status.low_voltage)
    end
	title('Low Voltage Alarm');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,14);
	if max(state.system_status.high_voltage) == 1
		plot(plotting_time,state.system_status.high_voltage,'r')
    else
        plot(plotting_time,state.system_status.high_voltage)
    end
	title('High Voltage Alarm');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,15);
	if max(state.system_status.gnss_antenna_disconnected) == 1
		plot(plotting_time,state.system_status.gnss_antenna_disconnected,'r')
    else
        plot(plotting_time,state.system_status.gnss_antenna_disconnected)
    end
	title('GNSS Antenna Fault');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(4,4,16);
	if max(state.system_status.data_overflow) == 1
		plot(plotting_time,state.system_status.data_overflow,'r')
    else
        plot(plotting_time,state.system_status.data_overflow)
    end
	title('Data Overflow');
	xlabel('Seconds');
	ylim([-0.1,1.1]);
	yticks([0 1]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%

    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(figs, fig_names);
    end

end