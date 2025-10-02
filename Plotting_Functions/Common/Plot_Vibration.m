function vib_figs = Plot_Vibration(raw_sensors)
%Plot_Vibration Plot RMS vibration and other captures of vibration data
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize vibration figures
    vib_figs = [];

    %Initialize RMS & Mean struct
    rms.accelerometers          = zeros(size(raw_sensors.accelerometers));
    rms.gyroscopes              = zeros(size(raw_sensors.gyroscopes));
    mean_cntr.accelerometers    = zeros(size(raw_sensors.accelerometers));
    mean_cntr.gyroscopes        = zeros(size(raw_sensors.gyroscopes));

    %*****************Make Time Mask*****************
    %Grab time
    time        = raw_sensors.duration_seconds;

    %Time filter length
    time_filter = 10;

    %Determine number of bins for time
    time_bin    = floor(max(time)/time_filter);

    %Make rolling mask
    mask_time   = logical(zeros(length(time),time_bin));

    %Step through and make mask
    for i = 1:time_bin

        %determine min and max time bounds
        min_time    = (i-1)*time_filter;
        if(i ~= time_bin)
            max_time    = (i)*time_filter;
        else
            max_time    = max(time);
        end

        %Make mask
        mask_time(:,i) = time >= min_time & time <= max_time;

    end

    %*************************************************%

    %*********************************************************************%
    %Extract vibration data
    %*********************************************************************%

    %Grab Mean Signal for each vector
    for i = 1:time_bin

        %Grab mean signal for each time bin
        for j = 1:3
            mean_cntr.accelerometers(mask_time(:,i),j)     = raw_sensors.accelerometers(mask_time(:,i),j) - mean(raw_sensors.accelerometers(mask_time(:,i),j));
            mean_cntr.gyroscopes(mask_time(:,i),j)         = raw_sensors.gyroscopes(mask_time(:,i),j) - mean(raw_sensors.gyroscopes(mask_time(:,i),j));
        end

        %Grab RMS for each vector
        for j = 1:3
            rms.accelerometers(mask_time(:,i),j)     = sqrt(mean(mean_cntr.accelerometers(mask_time(:,i),j).^2))*ones(size(mean_cntr.accelerometers(mask_time(:,i))));
            rms.gyroscopes(mask_time(:,i),j)         = sqrt(mean(mean_cntr.gyroscopes(mask_time(:,i),j).^2))*ones(size(mean_cntr.accelerometers(mask_time(:,i))));
        end

    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%
    vib_figs(1) = figure('Name','Plot Vibration Gyros');

    %X-axis
    subplot(3,1,1);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.gyroscopes(:,1), ".", 'DisplayName',"mean_cntr.gyroscopes");
    plot(raw_sensors.duration_seconds,rms.gyroscopes(:,1), ".", 'DisplayName',"rms.gyroscopes");
	title('X Gyroscopes Vibration - Mean Centered');
	legend('Mean Centered X','Root Mean Squared - X');
	ylabel('Degrees / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Y-Axis
    subplot(3,1,2);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.gyroscopes(:,2), ".", 'DisplayName',"mean_cntr.gyroscopes");
    plot(raw_sensors.duration_seconds,rms.gyroscopes(:,2), ".", 'DisplayName',"rms.gyroscopes");
	title('Y Gyroscopes Vibration - Mean Centered');
	legend('Mean Centered Y','Root Mean Squared - Y');
	ylabel('Degrees / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Z-Axis
    subplot(3,1,3);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.gyroscopes(:,3), ".", 'DisplayName',"mean_cntr.gyroscopes");
    plot(raw_sensors.duration_seconds,rms.gyroscopes(:,3), ".", 'DisplayName',"rms.gyroscopes");
	title('Z Gyroscopes Vibration - Mean Centered');
	legend('Mean Centered Z','Root Mean Squared - Z');
	ylabel('Degrees / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Set accelerometers
    vib_figs(2) = figure('Name','Plot Vibration Accels');

    %X-Axis
	subplot(3,1,1);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.accelerometers(:,1), ".", 'DisplayName','mean_cntr.accelerometers')
    plot(raw_sensors.duration_seconds,rms.accelerometers(:,1), ".", 'DisplayName',"rms.accelerometers");
	title('X Accelerometers Vibration - Mean Centered');
	legend('Mean Centered X''Root Mean Squared - X');
	ylabel('Metres / second / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Y-Axis
	subplot(3,1,2);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.accelerometers(:,2), ".", 'DisplayName','mean_cntr.accelerometers')
    plot(raw_sensors.duration_seconds,rms.accelerometers(:,2), ".", 'DisplayName',"rms.accelerometers");
	title('Y Accelerometers Vibration - Mean Centered');
	legend('Mean Centered Y','Root Mean Squared - Y');
	ylabel('Metres / second / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %X-Axis
	subplot(3,1,3);
    hold on;
    grid on;
	plot(raw_sensors.duration_seconds,mean_cntr.accelerometers(:,3), ".", 'DisplayName','mean_cntr.accelerometers')
    plot(raw_sensors.duration_seconds,rms.accelerometers(:,3), ".", 'DisplayName',"rms.accelerometers");
	title('Z Accelerometers Vibration - Mean Centered');
	legend('Mean Centered Z','Root Mean Squared - Z');
	ylabel('Metres / second / second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

end

