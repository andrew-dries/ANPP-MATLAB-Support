function hist_fig = Plot_Time_History(times, input_vectors, plot_info_input)
    %This function is meant to take in an input vector, and plot a time
    %history
    %
    %INPUTS: time(N,1), input_vectors (N,M), plot_info_input
    %N = Number of Samples
    %M = Number of Vectors
    %plot_info_input.title
    %plot_info_input.x_label
    %plot_info_input.y_label
    %plot_info_input.legend
    
    %*************************************************************************%
    %Initializations
    %*************************************************************************%
    
    %Create Time History Plot figure
    if(plot_info_input.create_figure)
        hist_fig = figure('Name','Plot Time History');
    else
        hist_fig = [];
    end
    
    %Create Time History Plot figure properties
    hold on;
    grid on;
    
    %**************************************%
    %Grab fieldnames of input positions
    fields_input_vectors = fieldnames(input_vectors);

    %Grab fieldnames of times
    fields_times = fieldnames(times);
    
    %Check for width of vectors
    vector_width = length(fields_input_vectors);

    %Perform fields length check
    if(length(fields_times) ~= vector_width)
        error("Times and Inputs Vectors do not have the same number of fields!")
    end
    %**************************************%
    
    %**************************************%
    %Check for plot_info
    if(nargin >= 3)
        plot_info = plot_info_input;
    else
        plot_info.title         = "Time History of Vector Values";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Vector Values";
        plot_info.legend        = cell(1,vector_width);
        plot_info.lims_x        = [];
        plot_info.lims_y        = [];
    end

    %Get plot format info
    plot_format = get_plot_format();
    
    %**************************************%
    
    %*************************************************************************%
    %Begin Plotting
    %*************************************************************************%
    
    %Populate figure properties
    title(plot_info.title, 'Interpreter', 'none')
    xlabel(plot_info.x_label, 'Interpreter', 'none')
    ylabel(plot_info.y_label, 'Interpreter', 'none')
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
    %Set x and y lims
    if( ~isempty(plot_info.lims_x) )
        xlim(plot_info.lims_x);
    elseif( ~isempty(plot_info.lims_y) )
        ylim(plot_info.lims_y);
    end
    
    %Step through the number of vector time histories to plot
    for i = 1:vector_width
    
        %Plot time histories
        plot(times.(fields_times{i}), input_vectors.(fields_input_vectors{i}), ...
                LineStyle="none", Marker=plot_format.markers{i}, Color=plot_format.colors{i}, MarkerSize=4);
    
    end

    %Create legend if more than one value
    if(~isempty(plot_info.legend))
        legend(plot_info.legend, 'Interpreter', 'none');
    end

end