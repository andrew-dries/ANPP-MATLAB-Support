%*************************************************************************%
%Plot Time History of Raw GNSS Position vs State Position - Video

%Plot position history in time
positions.input_1   = log_data.state.position(:,1:2);
positions.input_2   = log_data.raw_gnss.position(log_data.raw_gnss.status.time_valid == 1,1:2);
heading.input_1     = log_data.state.orientation(:,3);
heading.input_2     = calculate_velocity_heading(log_data.raw_gnss.velocity(log_data.raw_gnss.status.time_valid == 1,:));
times.input_1       = log_data.state.duration_seconds(:);
times.input_2       = log_data.raw_gnss.duration_seconds(log_data.raw_gnss.status.time_valid == 1);

plot_info.lims_x        = [];
plot_info.lims_y        = [];
plot_info.title         = "Raw GNSS vs State Position Video";
plot_info.legend        = {"State Position", "Raw GNSS Position", "State Heading", "Raw GNSS Velocity Heading"};
pos_time_hist_follow    = Plot_Position_History_In_Time(positions, heading, times, plot_info);
%*************************************************************************%