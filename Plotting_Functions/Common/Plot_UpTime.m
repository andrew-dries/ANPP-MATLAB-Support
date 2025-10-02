function UpTime_Fig = Plot_UpTime(uptime)
    
    %*************************************************************************%
    %Initializations
    %*************************************************************************%
    
    %Create Time History Plot figure
    UpTime_Fig = figure;
    
    %Create Time History Plot figure properties
    grid on;
    
    %*************************************************************************%
    %Begin Plotting
    %*************************************************************************%
    
    %Make plot
    plot(uptime.datetime, uptime.uptime,"x");
	title('Up Time Tracker');
	ylabel('Up Time (s)');
	xlabel('Seconds');

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)

end