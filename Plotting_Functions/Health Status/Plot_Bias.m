function figs = Plot_Bias(bias, plot_options)
%Plots information about bias

    %Inputs:bias struct, and time type
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Determine time type
    if(nargin >= 2)

        %time_type definitions
        %1 - date time
        %2 - duration
        
        if(plot_options.plotting_time_type == 1) %date time
            plotting_time   = bias.datetime;
        elseif(plot_options.plotting_time_type == 2) %duration
            plotting_time   = bias.duration_seconds;
        elseif(plot_options.plotting_time_type == 3) %Unix Time
            plotting_time   = bias.unix_time_seconds;
        elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
            plotting_time   = bias.unix_time_seconds - bias.utc_time_min;
        elseif(plot_options.plotting_time_type == 5) %Index
            plotting_time   = [1:length(bias.datetime)];
        end

    else

        %Default to date time
        plotting_time   = bias.datetime;

    end

    %Set figure name
    fig_names = {"Gyroscope Bias", ...
                 "Accelerometer Bias", ...
                 "Bias Status", ...
                 "Random"};

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%
    
    %**********Raw Sensors**********%

    %Gyroscope Bias
    figs(1) = figure('Name',fig_names{1});

    %Gyroscope Bias
	subplot(2,2,1);
	plot(plotting_time,bias.gyroscope_bias, ".");
	title('Gyroscope Bias');
	legend('X','Y','Z');
	ylabel('Degrees/Second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Gyroscope Bias Standard Deviation
    subplot(2,2,2);
	plot(plotting_time,bias.gyroscope_bias_standard_deviation, ".");
	title('Gyroscope Bias Standard Deviation');
	legend('X','Y','Z');
	ylabel('Degrees/Second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Gyroscope Bias Rejection Counter
    subplot(2,2,3);
	plot(plotting_time,bias.gyroscope_bias_rejection_counter, ".");
	title('Gyroscope Bias Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Zero Angular Rate Updates
    subplot(2,2,4);
	plot(plotting_time,bias.zero_angular_rate_updates, ".");
	title('Zero Angular Rate Updates');
	ylabel('Bool');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Accelerometer Bias
    figs(2) = figure('Name',fig_names{2});

    %Accelerometer Bias
	subplot(2,2,1);
	plot(plotting_time,bias.accelerometer_bias, ".");
	title('Accelerometer Bias');
	legend('X','Y','Z');
	ylabel('Meters/Second/Second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Accelerometer Bias Standard Deviation
	subplot(2,2,2);
	plot(plotting_time,bias.accelerometer_bias_standard_deviation, ".");
	title('Accelerometer Bias Standard Deviation');
	legend('X','Y','Z');
	ylabel('Meters/Second/Second');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Accelerometer Bias Rejection Counter
	subplot(2,2,3);
	plot(plotting_time,bias.accelerometer_bias_rejection_counter, ".");
	title('Accelerometer Bias Rejection Counter');
	legend('X');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %Zero Angular Rate Updates
    subplot(2,2,4);
	plot(plotting_time,bias.zero_velocity_updates, ".");
	title('Zero Velocity Updates');
	ylabel('Bool');
	xlabel('Seconds');

	%**********Bias Status**********%

    %Gyroscope Bias
    figs(3) = figure('Name',fig_names{3});

    %1 Accelerometer Bias Rejection Counter
	subplot(2,5,1);
	plot(plotting_time,bias.accelerometer_bias_rejection_counter, ".");
	title('Accelerometer Bias Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %2 Accelerometer Rejection Counter
	subplot(2,5,2);
	plot(plotting_time,bias.accelerometer_rejection_counter, ".");
	title('Accelerometer Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %3 Gyroscope Bias Rejection Counter
	subplot(2,5,3);
	plot(plotting_time,bias.gyroscope_bias_rejection_counter, ".");
	title('Gyroscope Bias Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %4 Position Rejection Counter
	subplot(2,5,4);
	plot(plotting_time,bias.position_rejection_counter, ".");
	title('Position Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %5 Velocity Rejection Counter
	subplot(2,5,5);
	plot(plotting_time,bias.velocity_rejection_counter, ".");
	title('Velocity Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %6 Heading Rejection Counter
	subplot(2,5,6);
	plot(plotting_time,bias.heading_rejection_counter, ".");
	title('Heading Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %7 Roll / Pitch Rejection Counter
	subplot(2,5,7);
	plot(plotting_time,bias.roll_pitch_rejection_counter, ".");
	title('Roll / Pitch Rejection Counter');
	ylabel('Counts');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %8 Zero Angular Rate Updates
	subplot(2,5,8);
	plot(plotting_time,bias.zero_angular_rate_updates, ".");
	title('Zero Angular Rate Updates');
	ylabel('Bool');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %9 Zero Velocity Updates
	subplot(2,5,9);
	plot(plotting_time,bias.zero_velocity_updates, ".");
	title('Zero Velocity Updates');
	ylabel('Bool');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %10 Magnetometer Zero Rate Updates
	subplot(2,5,10);
	plot(plotting_time,bias.magnetometer_zero_rate_updates, ".");
	title('Magnetometer Zero Rate Updates');
	ylabel('Bool');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %**********Random**********%

    %Gyroscope Bias
    figs(4) = figure('Name',fig_names{4});

    %1 QNH
	subplot(3,1,1);
	plot(plotting_time,bias.qnh, ".");
	title('QNH');
	ylabel('Unknown');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %2 QNH STD
	subplot(3,1,2);
	plot(plotting_time,bias.qnh_standard_deviation, ".");
	title('QNH Standard Deviation');
	ylabel('Unknown');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    %3 X Axis Integratio 
	subplot(3,1,3);
	plot(plotting_time,bias.x_axis_integration, ".");
	title('X Axis Integration');
	ylabel('Unknown');
	xlabel('Seconds');

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

