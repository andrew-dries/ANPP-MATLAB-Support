function filter = average_filter(time, input_vector, filter_width_time)
    %MEAN_TIME_FILTER:  This function filters data using a low pass
    %averaging method
    %Inputs:  time, input_vector, filter_width_time

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Initialize filter output
    filter = zeros(size(input_vector));

    %Determine filter width from time
    filter_width = round(filter_width_time / mean(diff(time)));

    %*********************************************************************%
    %Begin Mean Filter
    %*********************************************************************%

    %Step through data
    for i = filter_width:length(time)
        filter(i-filter_width+1:i) = mean(input_vector(i-filter_width+1:i));
    end

end