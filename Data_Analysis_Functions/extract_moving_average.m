function moving_avg = extract_moving_average(time, input_vector, filter_width_time)
    %EXTRACT_MOVING_AVERAGE: This function calculates the mean
    %over a time interval of a vector
    %Inputs:  time, input_vector, filter_width_time

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Initialize moving avg
    moving_avg = zeros(size(input_vector));

    %Determine filter width from time
    filter_width = round(filter_width_time / mean(diff(time)));

    %*********************************************************************%
    %Begin Moving Average Filter
    %*********************************************************************%

    %Step through data
    for i = filter_width:length(time)
        moving_avg(i-filter_width+1:i) = mean(input_vector(i-filter_width+1:i));
    end

end