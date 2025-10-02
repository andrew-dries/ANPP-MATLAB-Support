function fig_heading = Plot_Heading_Check(state, device_information)
    %Plot Heading Check plots velocity heading vs dual antenna heading 
    % / magnetic heading during heading valid section

    %Inputs: state struct as output by load_state_log.m
    %        device information struct as output by load_device_information.m
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Create heading figure
    fig_heading = figure('Name','Heading Check');
    
    %Grab speed
    speed = magnitude(state.velocity);

    %Grab velocity valid
    velocity_valid = ((state.filter_status.gnss_fix_type > 0) | ...
                      (state.filter_status.external_position_active & state.filter_status.external_velocity_active)) & ...
                     (speed > 1.25);

    %Grab velocity heading
    vh = velocity_heading(state.velocity(velocity_valid,:));

    %Grab heading flag
    if (device_information.device_id == 1 || device_information.device_id == 3)
	    heading_flag = 'Magnetic Heading Active';
    else
	    heading_flag = 'Dual Antenna Heading Active';
    end

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%
    
    %Create plots
    if (sum(velocity_valid) == 0)
	    plot(state.duration_seconds, state.orientation(:,3), state.duration_seconds, state.filter_status.magnetometers_enabled*100, state.duration_seconds, state.filter_status.external_heading_active*150, state.duration_seconds, state.filter_status.heading_initialised*50);
	    legend('INS Heading', heading_flag, 'External Heading Active', 'Heading Initialised');
	    title('Heading Check');
	    ylabel('Degrees');
	    xlabel('Seconds');
    else

        %Create state heading vs velocity heading
        subplot(2,1,1);

        %Set hold on & grid on
        hold on;
        grid on;

        %Make plots
        plot(state.duration_seconds, state.orientation(:,3), 'Marker', 'x', 'color', 'b', 'MarkerSize', 6, 'LineStyle', 'none');
        plot(state.duration_seconds(velocity_valid), vh, 'Marker', '*', 'color', 'r', 'MarkerSize', 4, 'LineStyle', 'none');

        %Create plot text
        legend('INS State Heading', 'Velocity Heading')
        title('Heading Check - INS State Heading vs. Velocity Heading');
	    ylabel('Degrees');
	    xlabel('Seconds');

        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14)

        %Create heading flags plots
        subplot(2,1,2);

        %Set hold on & grid on
        hold on;
        grid on;

        %Make plots
	    plot(state.duration_seconds, state.filter_status.magnetometers_enabled, 'Marker', 'o', 'color', 'g', 'MarkerSize', 8, 'LineStyle', 'none');
        plot(state.duration_seconds, state.filter_status.external_heading_active, 'Marker', '+', 'color', 'k', 'MarkerSize', 8, 'LineStyle', 'none');
        plot(state.duration_seconds, state.filter_status.heading_initialised, 'Marker', 'square', 'color', 'm', 'MarkerSize', 8, 'LineStyle', 'none');
	    
        %Create plot text
        legend(heading_flag, 'External Heading Active', 'Heading Initialised');
	    title('Heading Check');
	    ylabel('Degrees');
	    xlabel('Seconds');

        %Set font 14 bold
        set(gca, 'FontWeight', 'bold', 'FontSize', 14)

    end

end
