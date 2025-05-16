function position_fig = Plot_Position_History_In_Time(input_positions, input_heading, input_times, plot_info_input)
    %This function is meant to take in a matrix of positions to be plotted
    %against each other with respect to time if there are more than one.
    %INPUTS: input_positions(N,2,M), input_times(N,M), plot_info_input
    %N = Number of Samples
    %M = Number of Position Vectors
    %Sample [lat1, lon1]
    %plot_info_input.title
    %plot_info_input.x_label
    %plot_info_input.y_label
    %plot_info_input.legend
    
    %*************************************************************************%
    %Initializations
    %*************************************************************************%
    
    %Create Positions figure
    position_fig = figure('Name','Position History in Time');

    %Grab default position
    default_position = [2561, 170, 2560, 1315];
    
    %Create Positions figure properties
    grid on;
    
    %**************************************%
    plot_format = get_plot_format();
    %**************************************%

    %**************************************%
    %Grab fieldnames of input positions, heading, and times
    fields.positions    = fieldnames(input_positions);
    fields.heading      = fieldnames(input_heading);
    fields.times        = fieldnames(input_times);
    
    %Check for width of vectors
    vector_width        = length(fields.positions);
    %**************************************%

    %******************Define time intervals for video********************%
    %Check for min and max times
    min_time    = min(input_times.(fields.times{1}));
    max_time    = max(input_times.(fields.times{1}));
    for i = 1:vector_width
        if(min(input_times.(fields.times{i})) < min_time)
            min_time = min(input_times.(fields.times{i}));
        end
        if(max(input_times.(fields.times{i})) > max_time)
            max_time = max(input_times.(fields.times{i}));
        end
    end

    %Video length in time
    frames_per_second           = 30; %seconds
    frame_time_step             = 0.1;  %seconds
    frame_time_width            = 10;
    number_frames               = round((max_time-min_time)/frame_time_step);

    %Time vector in seconds
    time_vector                 = min_time:frame_time_step:max_time;
    %*********************************************************************%

    %***********Create Video Object***********%

    %Create video writer object
    video_obj = VideoWriter("Position_Video.avi");

    %Set frame rate
    video_obj.FrameRate = frames_per_second;

    %Open video obj
    open(video_obj);

    %**************************************%

    %**************************************%
    %Check for plot_info
    if(nargin >= 2)
        plot_info = plot_info_input;
    else
        plot_info.title         = "CDF of Vector Values";
        plot_info.x_label       = "Vector Values";
        plot_info.y_label       = "Percentage of Values";
        plot_info.legend        = cell(1,vector_width);
    end
    %**************************************% 
    
    %*************************************************************************%
    %Begin Plotting
    %*************************************************************************%
    
    %Step through time
    for i = 1:number_frames

        %Clear plot
        cla;

        %Update title with time
        title_text{1}       = plot_info.title;
        title_text{2}       = strcat("Percent Done: ", num2str(100*i/length(time_vector)));
        title_text{3}       = strcat("Current Time (s): ", num2str(time_vector(i)));

        %**************************************%
        reset_min_max   = 1;
        legend_cnt      = 1;
        %**************************************%

        %Step through the number of vector CDFs to plot
        for j = 1:vector_width

            %Create time mask
            mask = input_times.(fields.times{j}) >= (min_time + frame_time_step*(i-1) - frame_time_width) & input_times.(fields.times{j}) < (min_time + frame_time_step*i);

            %Find most current time index
            current_ind = max(find(mask == 1));

            %Set local min / max on first pass
            if(reset_min_max && ~isempty(find(mask == 1)))
    
                %Set reset bit
                reset_min_max = 0;

                %Set min / max of lat / lon
                min_lat = min(input_positions.(fields.positions{j})(mask,1));
                max_lat = max(input_positions.(fields.positions{j})(mask,1));
                min_lon = min(input_positions.(fields.positions{j})(mask,2));
                max_lon = max(input_positions.(fields.positions{j})(mask,2));

            elseif(reset_min_max == 0)

                %Determine local min / max
                if(min(input_positions.(fields.positions{j})(mask,1)) < min_lat)
                    min_lat = min(input_positions.(fields.positions{j})(mask,1));
                end
                if(max(input_positions.(fields.positions{j})(mask,1)) > max_lat)
                    max_lat = max(input_positions.(fields.positions{j})(mask,1));
                end
                if(min(input_positions.(fields.positions{j})(mask,2)) < min_lon)
                    min_lon = min(input_positions.(fields.positions{j})(mask,2));
                end
                if(max(input_positions.(fields.positions{j})(mask,2)) > max_lon)
                    max_lon = max(input_positions.(fields.positions{j})(mask,2));
                end

            end
    
            %Make geoscatter plots - all positions mask
            h(legend_cnt) = geoscatter(input_positions.(fields.positions{j})(mask,1), input_positions.(fields.positions{j})(mask,2), 2, plot_format.colors_alternate{j});

            %Increment legend count
            legend_cnt = legend_cnt + 1;

            %Set hold on
            hold on;

            %Make geoscatter plots - current position mask
            h(legend_cnt) = geoscatter(input_positions.(fields.positions{j})(current_ind,1), input_positions.(fields.positions{j})(current_ind,2), 40, plot_format.colors{j}, "x", ...
                            "DisplayName",plot_info.legend{j});

            %Increment legend count
            legend_cnt = legend_cnt + 1;

        end

        %Step through the number of vector CDFs to plot heading
        for j = 1:vector_width

            %Adjust distnace multiplier as needed
            %0.0001     = 10m
            %0.001      = 100m
            dist_mult = 0.1*(max(abs(max_lat - min_lat), abs(max_lon - min_lon)));

            %Make heading at current position
            h(legend_cnt) = geoplot([input_positions.(fields.positions{j})(current_ind,1), ...
                                     input_positions.(fields.positions{j})(current_ind,1) + dist_mult*cosd(input_heading.(fields.heading{j})(current_ind,1))], ...
                                    [input_positions.(fields.positions{j})(current_ind,2), ...
                                     input_positions.(fields.positions{j})(current_ind,2) + dist_mult*sind(input_heading.(fields.heading{j})(current_ind,1))], ...
                                    "DisplayName", plot_info.legend{j+2}, "Color", plot_format.colors{j});

            % distance_between_lat_lon_points([input_positions.(fields.positions{j})(current_ind,1),input_positions.(fields.positions{j})(current_ind,2)], ...
            %                                 [input_positions.(fields.positions{j})(current_ind,1) + dist_mult*sind(input_heading.(fields.heading{j})(current_ind,1)), ...
            %                                 input_positions.(fields.positions{j})(current_ind,2) + dist_mult*cosd(input_heading.(fields.heading{j})(current_ind,1))])

            %Increment legend count
            legend_cnt = legend_cnt + 1;

        end

        %set hold off
        hold off;

        %Determine 1/2 the difference between the min and max for each
        %and adjust
        lat_adj     = 0.5*(max_lat - min_lat);
        lon_adj     = 0.5*(max_lon - min_lon);

        %Set min and max limits
        geolimits([min_lat-lat_adj, max_lat+lat_adj], [min_lon-lon_adj, max_lon+lon_adj]);

        %Populate figure properties
        title(title_text, 'Interpreter', 'none')
        set(gca, 'FontWeight', 'bold', 'FontSize', 14)

        %Create legend if more than one value
        if(~isempty(plot_info.legend{1}))
            legend([h(2), h(4), h(5), h(6)], 'Interpreter', 'none')
        end

        %Set default position
        position_fig.Position = default_position;
            
        %Grab frame
        frame = getframe(position_fig);

        %Write to video
        writeVideo(video_obj,frame)

        %Drawnow limitrate
        drawnow limitrate;

    end

    %Close video
    close(video_obj);

end