function figs = Plot_Gyrocompass_Heading_Vs_Position(state, raw_gnss, create_figure, position_type, plot_options)
%Plot_Dual_GNSS_Heading Plots important information to understand Dual GNSS
%Heading performance

    %Inputs: state struct, or raw gnss struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Set figure name
    fig_names = {"Gyrcompass Heading vs Position"};

    %Initialize figure
    figs = [];
    
    %Check to create figure
    if(create_figure)
        figs(1) = figure('Name',fig_names{1});
    end
    
    %Determine if using Raw GNSS or State Position
    if(position_type == 1) %Use State
        position                    = state.position(state.filter_status.heading_initialised == 1,:);
        heading                     = state.orientation(state.filter_status.heading_initialised == 1,3);
        heading_standard_deviation  = min(extract_standard_deviation(state.duration_seconds(state.filter_status.heading_initialised == 1), state.orientation(state.filter_status.heading_initialised == 1,3), 0.5), 20);
        time                        = state.unix_time_seconds(state.filter_status.heading_initialised == 1);
    elseif(position_type == 2) %Use Raw GNSS
        position                    = raw_gnss.position(raw_gnss.status.time_valid == 1,:);
        state_time_match            = find_closest_time_vector_fast(state.unix_time_seconds(state.filter_status.heading_initialised == 1), raw_gnss.unix_time_seconds(raw_gnss.status.time_valid == 1));
        heading                     = state.orientation(state_time_match.mask,3);
        heading_standard_deviation  = min(extract_standard_deviation(state.duration_seconds(state_time_match.mask), state.orientation(state_time_match.mask,3), 0.5), 20);
        time                        = state.unix_time_seconds(state_time_match.mask);
    end

    %Initialize interval
    interval = 20;

    %Not sure what's going on here...
    u = sind(heading);
    v = cosd(heading);

    %*********************************************************************%
    %Create Datatips
    %*********************************************************************%

    % 1.  Grab data of interest and save to a cell
    datatip_data.unix_time_seconds          = time;
    datatip_data.position                   = position;
    datatip_data.heading                    = heading;
    datatip_data.heading_standard_deviation = heading_standard_deviation;

    % 2. Get the data cursor mode object for the figure
    dcm_obj = datacursormode(figs);

    % 3.  Save the datatip data to the dcm object
    dcm_obj.Figure.UserData = datatip_data;

    % 4. Enable the data cursor mode
    datacursormode on;
    
    % 5. Set the 'UpdateFcn' property to our custom function
    % The @ symbol creates a function handle. MATLAB will call this function
    % whenever a new datatip is created or an existing one is moved.
    set(dcm_obj, 'UpdateFcn', @myCustomDatatipGyrocompassHeading);

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Create scatter plot of position
    geoscatter(position(:, 1), position(:, 2), "Marker", "*", "LineWidth", 0.25);

    %Set hold on
    hold on

    %Adjust distnace multiplier as needed
    %0.0001     = 10m
    %0.001      = 100m
    dist_mult = 0.001;

    %Make heading at current position
    for i = 1:interval:length(position)
            geoplot([position(i, 1), ...
                     position(i, 1) + dist_mult*v(i)], ...
                    [position(i, 2), ...
                     position(i, 2) + dist_mult*u(i)], ...
                     color='r');
    end

    %Remove hold
    hold off

    %Set title information
    title("Gyrocompass Heading vs Position");
    legend({"Position", "Heading"});
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

    %*********************************************************************%
    %Call Figure Saving Functions
    %*********************************************************************%
    
    %Call save figure and pngs
    if(plot_options.save_plots)
        save_figures_and_pngs(figs, fig_names);
    end
    
end

% --- Custom Datatip Function ---
    % This function must be in a file named 'myCustomDatatip.m' on the MATLAB path,
    % or it can be a local function if this script is itself a function.

function output_txt = myCustomDatatipGyrocompassHeading(~, event_obj)
    % ~            - The first argument is typically the source object, but it's
    %                not used in this case, so we use '~' to ignore it.
    % event_obj    - An object containing information about the event,
    %                such as the position of the datatip.

    %Get the data cursor mode object for the figure
    dcm_obj = datacursormode(gcf);

    %Grab datatip target
    % Get the handle of the line that was clicked
    target_line = get(event_obj, 'Target');
    
    % Get the display name of the clicked line (from the legend)
    line_name = get(target_line, 'DisplayName');

    %Grab the datatip object
    datatip_data = dcm_obj.Figure.UserData;

    %Get the position of the clicked point
    pos = get(event_obj, 'Position');
    x_val = pos(1);
    y_val = pos(2);

    %Find the index of position that closet matches
    x_ind   = find( abs( datatip_data.position(:,1) - x_val ) == min( abs( datatip_data.position(:,1) - x_val ) ) );
    y_ind   = find( abs( datatip_data.position(:,2) - y_val ) == min( abs( datatip_data.position(:,2) - y_val ) ) );
    ind     = x_ind( find( x_ind == y_ind ) );
    
    % Create the custom text for the datatip
    % The output must be a cell array of strings or a character array.
    output_txt = {[sprintf("Position:    Lat %2.3d, Lon %2.3d\n", datatip_data.position(ind,1), datatip_data.position(ind,2))]; ...
                  [sprintf("UTC Time:    %4.8d\n", datatip_data.unix_time_seconds(ind))]; ...
                  [sprintf("Heading:     %2.2d\n", datatip_data.heading(ind))]; ...
                  [sprintf("Heading STD: %2.2d", datatip_data.heading_standard_deviation(ind))]};

    %Print text to screen
    fprintf("%s\n", output_txt{:})

end