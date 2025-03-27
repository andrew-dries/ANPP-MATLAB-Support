function std_out = extract_standard_deviation(time, input_vector, filter_width_time)
    %EXTRACT_STANDARD_DEVIATION: This function calculates standard
    %deviation over a time interval of a vector
    %Inputs:  time, input_vector, filter_width_time

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Initialize std output
    std_out = zeros(size(input_vector));

    %Determine filter width from time
    filter_width = round(filter_width_time / mean(diff(time)));

    %*********************************************************************%
    %Begin Std Filter
    %*********************************************************************%

    %Step through data
    for i = filter_width:length(time)
        std_out(i-filter_width+1:i) = std(input_vector(i-filter_width+1:i));
    end

end