function figs = Plot_State_Heading_Vs_Position(state, raw_gnss, create_figure)
%Plot_State_Heading Plots important information to understand 
% Heading performance

    %Inputs: state struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize figure
    figs = [];
    
    %Check to create figure
    if(create_figure)
        figs = figure;
    end

    %Initialize interval
    interval = 10;

    %Calculate heading standard deviation
    heading_standard_deviation = extract_standard_deviation(state.duration_seconds, state.orientation(:,3), 0.5);

    %Not sure what's going on here...
    u = 0.001 * heading_standard_deviation .* sind(state.orientation(:,3));
    v = 0.001 * heading_standard_deviation .* cosd(state.orientation(:,3));

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create scatter plot of state position
    scatter(state.position(:, 2), state.position(:, 1))

    %Set hold on
    hold on

    %Create scatter plot of raw GNSS position
    scatter(raw_gnss.position(raw_gnss.status.time_valid == 1, 2), raw_gnss.position(raw_gnss.status.time_valid == 1, 1))

    %Create quiver plot
    quiver(state.position(1:interval:end, 2), state.position(1:interval:end,1), ...
           u(1:interval:end), v(1:interval:end), 'MaxHeadSize', 0.001)

    %Remove hold
    hold off

    %axis equal
    grid on
    grid minor

    %Set title information
    title("State Heading vs Position");
    xlabel("Longitude (deg)")
    ylabel("Latitude (deg)")
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    legend({"State Position", "Raw GNSS Position", "Heading"})
    
end

