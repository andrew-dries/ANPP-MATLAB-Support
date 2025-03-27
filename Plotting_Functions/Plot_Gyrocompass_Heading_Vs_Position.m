function figs = Plot_Gyrocompass_Heading_Vs_Position(state, create_figure)
%Plot_Dual_GNSS_Heading Plots important information to understand Dual GNSS
%Heading performance

    %Inputs: state struct, or raw gnss struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize figure
    figs = [];
    
    %Check to create figure
    if(create_figure)
        figs(1) = figure('Name','Gyrcompass Heading vs Position');
    end
    
    %Mask internal variables to remove invalid time
    state.heading_standard_deviation     = max(extract_standard_deviation(state.duration_seconds, state.orientation(state.filter_status.heading_initialised == 1,3), 0.5), 20);
    state.heading                        = state.orientation(state.filter_status.heading_initialised == 1,3);
    state.position                       = state.position(state.filter_status.heading_initialised == 1,:);

    %Initialize interval
    interval = 20;

    %Not sure what's going on here...
    u = sind(state.heading);
    v = cosd(state.heading);

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create scatter plot of position
    geoscatter(state.position(:, 1), state.position(:, 2), "Marker", "*", "LineWidth", 0.25);

    %Set hold on
    hold on

    %Adjust distnace multiplier as needed
    %0.0001     = 10m
    %0.001      = 100m
    dist_mult = 0.001;

    %Make heading at current position
    for i = 1:interval:length(state.position)
            geoplot([state.position(i, 1), ...
                     state.position(i, 1) + dist_mult*v(i)], ...
                    [state.position(i, 2), ...
                     state.position(i, 2) + dist_mult*u(i)], ...
                     color='r');
    end

    %Remove hold
    hold off

    %Set title information
    title("Gyrocompass Heading vs Position");
    legend({"Position", "Heading"})
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
end

