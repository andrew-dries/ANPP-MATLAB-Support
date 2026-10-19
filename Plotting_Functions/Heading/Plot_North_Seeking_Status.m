function figs = Plot_North_Seeking_Status(log_data, plot_options)
%PLOT_NORTH_SEEKING_STATUS Plots alignment heading and error flags
% performance based on NorthSeekingStatus.csv log format

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Grab north seeking plotting time
    if(plot_options.plotting_time_type == 1) %date time
        plotting_time      = log_data.north_seeking_status.datetime;
    elseif(plot_options.plotting_time_type == 2) %duration
        plotting_time      = log_data.north_seeking_status.duration_seconds;
    elseif(plot_options.plotting_time_type == 3) %UTC time
        plotting_time      = log_data.north_seeking_status.unix_time_seconds;
    elseif(plot_options.plotting_time_type == 4) %UTC time Normalized
        plotting_time      = log_data.north_seeking_status.unix_time_seconds - log_data.north_seeking_status.utc_time_min;
    elseif(plot_options.plotting_time_type == 5) %Index
        plotting_time      = [1:length(log_data.north_seeking_status.datetime)];
    end

    %Set figure names
    fig_names = {"North Seeking - Alignment Overview", ...
                 "North Seeking - Error Flags"};

    %*********************************************************************%
    % Figure 1: Heading and Progress
    %*********************************************************************%
    figs(1) = figure('Name', fig_names{1});

    subplot(3,1,1);
    plot(plotting_time, log_data.north_seeking_status.heading);
    title('Heading');
    ylabel('Degrees');
    xlabel('Time (s)');
    grid on; set(gca, 'FontWeight', 'bold', 'FontSize', 12);

    subplot(3,1,2);
    plot(plotting_time, log_data.north_seeking_status.predicted_accuracy);
    title('Predicated Accuracy');
    ylabel('Degrees');
    xlabel('Time (s)');
    grid on; set(gca, 'FontWeight', 'bold', 'FontSize', 12);

    subplot(3,1,3);
    plot(plotting_time, log_data.north_seeking_status.progress);
    title('North Seeking Progress');
    ylabel('Progress (%)');
    xlabel('Time (s)');
    grid on; set(gca, 'FontWeight', 'bold', 'FontSize', 12);

    %*********************************************************************%
    % Figure 2: Error Flags (Conditionals)
    %*********************************************************************%
    figs(2) = figure('Name', fig_names{2});
    
    % Use a 3x3 grid to plot the boolean status flags from the CSV
    subplot(3,3,1);
    plot(plotting_time, log_data.north_seeking_status.northseeking_complete);
    title('NS Complete'); ylim([-0.1 1.1]);
    
    subplot(3,3,2);
    plot(plotting_time, log_data.north_seeking_status.northseeking_cannot_start);
    title('Cannot Start'); ylim([-0.1 1.1]);
    
    subplot(3,3,3);
    plot(plotting_time, log_data.north_seeking_status.solution_out_of_range);
    title('Solution Out Range'); ylim([-0.1 1.1]);
    
    subplot(3,3,4);
    plot(plotting_time, log_data.north_seeking_status.solution_nonorthogonal);
    title('Non-orthogonal'); ylim([-0.1 1.1]);
    
    subplot(3,3,5);
    plot(plotting_time, log_data.north_seeking_status.excessive_movement);
    title('Excessive Movement'); ylim([-0.1 1.1]);
    
    subplot(3,3,6);
    plot(plotting_time, log_data.north_seeking_status.latitude_change);
    title('Latitude Change'); ylim([-0.1 1.1]);
    
    subplot(3,3,7);
    plot(plotting_time, log_data.north_seeking_status.leverarm_change);
    title('Lever-arm Change'); ylim([-0.1 1.1]);
    
    subplot(3,3,8);
    plot(plotting_time, log_data.north_seeking_status.invalid_latitude);
    title('Invalid Latitude'); ylim([-0.1 1.1]);
    
    % Format all subplots
    for i = 1:8
        subplot(3,3,i);
        set(gca, 'FontWeight', 'bold', 'FontSize', 10);
        grid on;
    end

    % Call save figure and pngs if required
    if(plot_options.save_plots)
        save_figures_and_pngs(figs, fig_names);
    end
end