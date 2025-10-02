function hist_fig = Plot_Time_History_Mask(time, input_vector, masks, plot_info_input)
    %This function is meant to take in an input vector, and plot a time
    %history with multiple masks
    %
    %INPUTS: time(N,1), input_vectors(N), masks(N,M), plot_info_input
    %N = Number of Samples
    %M = Number of Masks
    %plot_info_input.title
    %plot_info_input.x_label
    %plot_info_input.y_label
    %plot_info_input.legend
    
    %*************************************************************************%
    %Initializations
    %*************************************************************************%

    %Initialize figure
    hist_fig = [];
    
    %Check to create figure
    if(plot_info_input.create_figure)
        hist_fig = figure;
    end
    
    %Create Time History Plot figure properties
    hold on;
    grid on;
    
    %**************************************%
    %Check the length of the masks
    mask_size = size(masks);
    %**************************************%
    
    %**************************************%
    %Check for plot_info
    if(nargin >= 3)
        plot_info = plot_info_input;
    else
        plot_info.title         = "Time History of Vector Values";
        plot_info.x_label       = "Time (s)";
        plot_info.y_label       = "Vector Values";
        plot_info.legend        = cell(1,mask_size(2));
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
    
    %Step through the number of vector masks to plot
    for i = 1:mask_size(2)
    
        %Plot time histories
        plot(time(masks(:,i)), input_vector(masks(:,i)), ...
                LineStyle="none", Marker=plot_format.markers{i}, Color=plot_format.colors{i}, MarkerSize=2);
    
    end

    %Create legend if more than one value
    legend(plot_info.legend, 'Interpreter', 'none');

end