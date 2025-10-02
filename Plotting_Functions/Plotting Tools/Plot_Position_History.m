function position_fig = Plot_Position_History(input_positions, times, plot_info_input)
    %This function is meant to take in a matrix of positions to be plotted
    %against each other if there are more than one.
    %INPUTS: input_positions (N,2,M), plot_info_input
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
    position_fig = figure('Name',"Plot Position History");
    
    %Create Positions figure properties
    grid on;
    
    %**************************************%
    %Grab fieldnames of input positions
    pos_fields      = fieldnames(input_positions);
    time_fields     = fieldnames(times);
    
    %Check for width of vectors
    vector_width    = length(pos_fields);
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

    %*********************************************************************%
    %Create Datatips
    %*********************************************************************%

    % 1.  Grab data of interest and save to a cell
    datatip_data.unix_time_seconds          = times.(time_fields{1});
    datatip_data.position                   = input_positions.(pos_fields{1});

    % 2. Get the data cursor mode object for the figure
    dcm_obj = datacursormode(position_fig);

    % 3.  Save the datatip data to the dcm object
    dcm_obj.Figure.UserData = datatip_data;

    % 4. Enable the data cursor mode
    datacursormode on;
    
    % 5. Set the 'UpdateFcn' property to our custom function
    % The @ symbol creates a function handle. MATLAB will call this function
    % whenever a new datatip is created or an existing one is moved.
    set(dcm_obj, 'UpdateFcn', @myCustomDatatipPositionHistory);
    
    %*************************************************************************%
    %Begin Plotting
    %*************************************************************************%
    
    %Populate figure properties
    title(plot_info.title, 'Interpreter', 'none')
    xlabel(plot_info.x_label, 'Interpreter', 'none')
    ylabel(plot_info.y_label, 'Interpreter', 'none')
    
    %Step through the number of vector CDFs to plot
    for i = 1:vector_width

        %Set hold on if i == 2
        if(i == 2)
            hold on;
        end

        %Make geoscatter plots
        geoscatter(input_positions.(pos_fields{i})(:,1), input_positions.(pos_fields{i})(:,2),2);
    
    end

    %Create legend if more than one value
    if(~isempty(plot_info.legend{1}))
        legend(plot_info.legend, 'Interpreter', 'none')
    end

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

end

% --- Custom Datatip Function ---
    % This function must be in a file named 'myCustomDatatip.m' on the MATLAB path,
    % or it can be a local function if this script is itself a function.

function output_txt = myCustomDatatipPositionHistory(~, event_obj)
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
                  [sprintf("UTC Time:    %4.12d\n", datatip_data.unix_time_seconds(ind))]};

    %Print text to screen
    fprintf("%s\n", output_txt{:})

end