function cdf_fig = Plot_CDF(input_vectors, plot_info_input)
    %This function is meant to take in an input vector, and plot a CDF
    %
    %INPUTS: input_vectors (N,M), plot_info_input
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
        cdf_fig = figure('Name','Plot CDF');
    else
        cdf_fig = [];
    end
    
    %Create CDF figure properties
    hold on;
    grid on;
    
    %**************************************%
    %Check size of input vectors
    size_input = size(input_vectors);
    
    %Check for width of vectors
    vector_width = size(input_vectors,2);
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
        plot_info.range         = [min(input_vectors), max(input_vectors)];
    end
    
    %Marker Types
    markers     = {'x', '+', 'o', '*', 's', 'd'};
    colors      = {'r', 'b', 'k', 'g', 'm', 'c'};
    
    %**************************************%
    
    %*************************************************************************%
    %Begin Plotting
    %*************************************************************************%
    
    %Populate figure properties
    title(plot_info.title, 'Interpreter', 'none')
    xlabel(plot_info.x_label, 'Interpreter', 'none')
    ylabel(plot_info.y_label, 'Interpreter', 'none')
    set(gca, 'FontWeight', 'bold', 'FontSize', 14)
    
    %Step through the number of vector CDFs to plot
    for i = 1:vector_width
    
        %Plot CDF
        plot(sort(input_vectors(:,i)), 1/size_input(1):1/size_input(1):1, ...
                LineStyle="none", Marker=markers{i}, Color=colors{i}, MarkerSize=2);
    
    end

    if(~isempty(plot_info.legend))
        %Create legend if more than one value
        legend(plot_info.legend, 'Interpreter', 'none')
    end
    
    %Set Min / Max
    xlim(plot_info.range);

end