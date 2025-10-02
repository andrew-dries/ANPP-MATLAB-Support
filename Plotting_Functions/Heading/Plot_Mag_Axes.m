function figs = Plot_Mag_Axes(sensors)
%Plot_Mag_Axes Plots important information to understand magnetometer
%calibration

    %Inputs: raw sensors struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    % Magnetic Calibration Report
    figs(1) = figure('Name','Magnetic Calibration','Position', [ 80 80 1200 800 ]);
    subplot(2,2,1);
    plot(sensors.magnetometers(:,1),sensors.magnetometers(:,2));
    title('X / Y Axes');
    ylabel('Y-Axis mG');
    xlabel('X-Axis mG');
    axis equal;
    
    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
    subplot(2,2,2);
    plot(sensors.magnetometers(:,1),sensors.magnetometers(:,3));
    title('X / Z Axes');
    ylabel('Z-Axis mG');
    xlabel('X-Axis mG');
    axis equal;
    
    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
    subplot(2,2,3);
    plot(sensors.magnetometers(:,2),sensors.magnetometers(:,3));
    title('Y / Z Axes');
    ylabel('Z-Axis mG');
    xlabel('Y-Axis mG');
    axis equal;
    
    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
    subplot(2,2,4);
    plot3(sensors.magnetometers(:,1),sensors.magnetometers(:,2),sensors.magnetometers(:,3));
    title('X / Y / Z axes');
    ylabel('Y-Axis mG');
    xlabel('X-Axis mG');
    zlabel('Z-Axis mG');
    axis equal;
    
    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

end