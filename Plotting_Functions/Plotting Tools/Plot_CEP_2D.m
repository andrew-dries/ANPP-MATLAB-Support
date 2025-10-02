function cep_fig = Plot_CEP_2D(positions_2d, percent)
%PLOT_CEP_2D This function produces a CEP plot using LAT and LON data and
%determining the percentile of interest 1-99

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize figure
    cep_fig         = figure('Name','GNSS Status - CEP 2D');

    %Determine vector length
    vec_length      = length(positions_2d);

    %**************************************%
    plot_format     = get_plot_format();
    %**************************************%

    %*********************************************************************%
    %Calculate CEP variables
    %*********************************************************************%

    %Determine percent index
    percent_index   = round(percent*vec_length);

    %Find mean of lat / lon
    mean_lat_lon    = mean(positions_2d);

    %Calculate distance from mean
    dist            = sqrt( (positions_2d(:,1) - mean_lat_lon(1)).^2 + (positions_2d(:,2) - mean_lat_lon(2)).^2 );

    %Calculate mean distance
    dist_sort       = sort_vector(dist);

    %Mask for all distances within percent of that mean
    mask            = dist <= dist_sort(percent_index);

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Build text
    title_text{1}   = sprintf("CEP%d 2D Plot", percent*100);
    title_text{2}   = sprintf("CEP%d:  %4.2f (meters)", percent*100, distance_between_lat_lon_points(positions_2d(percent_index,1:2), mean_lat_lon));
    inside_text     = sprintf("Inside CEP%d", percent*100);
    outside_text    = sprintf("Outside CEP%d", percent*100);

    %Geoscatter plot - mean
    geoscatter(mean_lat_lon(1), mean_lat_lon(2), 40, ...
                plot_format.colors{1}, "x", "DisplayName", "Mean");

    %set hold on
    hold on;

    %Geoscatter plot - inside CEP
    geoscatter(positions_2d(mask,1), positions_2d(mask,2), 2, ...
                plot_format.colors{2}, "o", "DisplayName", inside_text);

    %Geoscatter plot - outside CEP
    geoscatter(positions_2d(~mask,1), positions_2d(~mask,2), 2, ...
                plot_format.colors{3}, "d", "DisplayName", outside_text);

    %Populate figure properties
    title(title_text, 'Interpreter', 'none');

    %Display legend
    legend();

    %Set font 14 bold
    set(gca, 'FontWeight', 'bold', 'FontSize', 14);

end