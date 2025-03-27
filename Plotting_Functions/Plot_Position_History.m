function position_fig = Plot_Position_History(input_positions, plot_info_input)
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
    position_fig = figure;
    
    %Create Positions figure properties
    grid on;
    
    %**************************************%
    %Grab fieldnames of input positions
    fields = fieldnames(input_positions);
    
    %Check for width of vectors
    vector_width = length(fields);
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
        geoscatter(input_positions.(fields{i})(:,1), input_positions.(fields{i})(:,2),2);
    
    end

    %Create legend if more than one value
    if(~isempty(plot_info.legend{1}))
        legend(plot_info.legend, 'Interpreter', 'none')
    end

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

end