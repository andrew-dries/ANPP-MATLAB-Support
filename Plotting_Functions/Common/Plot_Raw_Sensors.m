function figs = Plot_Raw_Sensors(raw_sensors, time_type)
%PLOT_RAW_SENSORS Plots time histories of raw sensors inputs

    %Inputs: raw_sensors struct as output by load_sensor_log.m
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(time_type == 1) %date time
            plotting_time   = raw_sensors.datetime;
        elseif(time_type == 2) %duration
            plotting_time   = raw_sensors.duration_seconds;
        elseif(time_type == 3) %UTC Time
            plotting_time   = raw_sensors.unix_time_seconds;
        elseif(time_type == 4) %UTC time Normalized
            plotting_time   = raw_sensors.unix_time_seconds - raw_sensors.utc_time_min;
        elseif(time_type == 5) %Index
            plotting_time   = [1:length(raw_sensors.datetime)];
        end

    else

        %Default to duration seconds
        plotting_time   = raw_sensors.duration_seconds;

    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%
    figs(1) = figure('Name','Report Page 1 - Raw Sensors');
	subplot(2,2,1);
	plot(plotting_time,raw_sensors.gyroscopes, ".", 'DisplayName',"raw_sensors.gyroscopes");
	title('XYZ Gyroscopes');
	legend('X','Y','Z');
	ylabel('Degrees / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(2,2,2);
	plot(plotting_time,raw_sensors.accelerometers, ".", 'DisplayName','raw_sensors.accelerometers')
	title('XYZ Accelerometers');
	legend('X','Y','Z');
	ylabel('Metres / second / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(2,2,3);
	m3=sqrt(raw_sensors.magnetometers(:,1).^2 + raw_sensors.magnetometers(:,2).^2 +raw_sensors.magnetometers(:,3).^2);
	plot(plotting_time,raw_sensors.magnetometers, ".",'DisplayName','raw_sensors.magnetometers')
	hold on;
	plot(plotting_time,m3)
	title('XYZ Magnetometers');
	legend('X','Y','Z','Magnitude');
	ylabel('mG');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

	subplot(2,2,4);
	plot(plotting_time,raw_sensors.pressure_temperature, ".");
	hold on
	plot(plotting_time,raw_sensors.imu_temperature, ".");
	title('Temperature');
	ylabel('Degrees C');
	xlabel('Seconds');
	legend('Pressure Sensor Temperature','IMU Sensor Temperature');
	ylim([(min(raw_sensors.imu_temperature)-7),(max(raw_sensors.imu_temperature)+7)]);

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

end

