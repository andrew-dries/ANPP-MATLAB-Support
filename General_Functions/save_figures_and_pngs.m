function save_figures_and_pngs(figs, names, path)
%This function saves all figures as .figs and .pngs

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine the number of figures / names
    num_figs = length(names);

    %If path does not exist, save in this folder
    if(nargin < 3)
        path = strcat(pwd, "\Plots");
    end

    %Make directory
    if(~(exist(path) == 7))
        mkdir(path);
    end

    %*********************************************************************%
    %Begin Saving
    %*********************************************************************%

    %Step through all figs
    for i = 1:num_figs

        %Create file name
        filename = strrep(names{i}, " ", "_");
        filename = strcat(path, "\" ,filename);

        %Make these figures current, and full screen them
        figure(figs(i));
        figs(i).WindowState = 'fullscreen';

        %Save figure
        saveas(figs(i), filename, 'fig');

        %Save PNG
        saveas(figs(i), filename, 'png');

        %Return windowstate to default
        figs(i).WindowState = 'normal';

    end

end