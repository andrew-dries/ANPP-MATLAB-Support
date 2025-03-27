function figs = Plot_Dual_GNSS_Heading_Vs_Position(gnss, create_figure)
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
        figs = figure;
    end
    
    %Mask internal variables to remove invalid time
    gnss.heading_standard_deviation     = gnss.heading_standard_deviation(gnss.status.time_valid == 1);
    gnss.heading                        = gnss.heading(gnss.status.time_valid == 1);
    gnss.position                       = gnss.position(gnss.status.time_valid == 1,:);

    %Initialize interval
    interval = 10;

    %Not sure what's going on here...
    u = 0.001 * gnss.heading_standard_deviation .* sind(gnss.heading);
    v = 0.001 * gnss.heading_standard_deviation .* cosd(gnss.heading);

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create scatter plot of position
    scatter(gnss.position(:, 2), gnss.position(:, 1))

    %Set hold on
    hold on

    %Create quiver plot
    quiver(gnss.position(1:interval:end, 2), gnss.position(1:interval:end,1), ...
           u(1:interval:end), v(1:interval:end), 'MaxHeadSize', 0.001)

    %Remove hold
    hold off

    %axis equal
    grid on
    grid minor

    %Set title information
    title("GNSS Heading vs Position");
    xlabel("Longitude (deg)")
    ylabel("Latitude (deg)")
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    legend({"Position", "Heading"})
    
end

