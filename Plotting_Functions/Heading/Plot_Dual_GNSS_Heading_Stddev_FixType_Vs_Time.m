function figs = Plot_Dual_GNSS_Heading_Stddev_FixType_Vs_Time(plotting_time, raw_gnss, create_figure)
%Plot_Dual_GNSS_Heading Plots important information to understand Dual GNSS
%Heading performance

    %Inputs: raw_gnss struct
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize figure
    figs = [];
    
    %Check to create figure
    if(create_figure)
        figs = figure;
    end
    
    %Initialize internal variables
    fix_names =   ["None";    "2D";    "3D";  "SBAS"; "Differential"; "PPP";   "RTK Float"; "RTK Fix"];
    fix_colours = ["magenta"; "white"; "red"; "blue"; "cyan";         "white"; "yellow";    "green" ];

    %Create time mask
    time_mask = raw_gnss.status.time_valid == 1;

    %*********************************************************************%
    %Begin Plotting
    %*********************************************************************%

    %Perform calculations
    heading_fix_type = (raw_gnss.status.heading_valid(time_mask) & (raw_gnss.status.floating_heading(time_mask) == 0)) * 7 + (raw_gnss.status.heading_valid(time_mask) & raw_gnss.status.floating_heading(time_mask)) * 6;
    dt = plotting_time(time_mask);
    sd = raw_gnss.heading_standard_deviation(time_mask);

    %Begin for loop and plotting
    for fixtype = 0:7

        %Set fix type
        selfix = (heading_fix_type == fixtype);

        %Begin plotting
        plot(...
            dt(selfix),...
            sd(selfix),...
            'x',...
            'Color', fix_colours(fixtype + 1),...
            'DisplayName', fix_names(fixtype + 1)...
            );

        %Set hold
        hold on;

    end

    %Set plot parameters
    grid on;
    grid minor;
    title("Raw GNSS Heading Standard Deviation");
    xlabel("UTC Time");
    ylabel("Heading Standard Deviation (deg)");
    legend;
    
end

