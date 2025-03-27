function plot_format = get_plot_format()
%Get plot  foramt will return standard plot formatting options

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    plot_format                     = struct();
    plot_format.colors              = {'r', 'b', 'k', 'g', 'm', 'c', ...
                                       'r', 'b', 'k', 'g', 'm', 'c'};
    plot_format.colors_alternate    = {'m', 'c', 'g', 'k', 'r', 'b', ...
                                       'm', 'c', 'g', 'k', 'r', 'b'};
    plot_format.markers             = {'x', 'o', 'd', 'o', '*', 's', ...
                                       's', '*', 'o', 'd', 'o', 'x'};

end

