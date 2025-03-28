function fig_antenna_positions = Plot_Antenna_Positions(configuration)
    %Plots the antenna positions relative to the INS

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Make figure
    fig_antenna_positions = figure;

    %Set hold on
    hold on;

    %Make large black X at origin to define INS
    plot3(0,0,0,'Color','k','Marker','x','MarkerSize',15,'DisplayName','INS');

    %Make large red X at primary antenna
    plot3(configuration.gnssAntennaOffsetX,configuration.gnssAntennaOffsetY,configuration.gnssAntennaOffsetZ, ...
          'Color','r','Marker','x','MarkerSize',15,'DisplayName','Primary Antenna');

    %Make large blue X at secondary antenna
    plot3(configuration.gnssManualOffsetX,configuration.gnssManualOffsetY,configuration.gnssManualOffsetZ, ...
          'Color','b','Marker','x','MarkerSize',15,'DisplayName','Secondary Antenna');

    %Turn on grid
    grid on;
    grid minor;

    %Set X Y and Z axis labels
    xlabel("X Axis");
    ylabel("Y Axis");
    zlabel("Z Axis");

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

    %Turn on legend
    legend();

end