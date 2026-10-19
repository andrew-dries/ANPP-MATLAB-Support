function r_out = calculate_pearson_correlation_coefficient(input_vector_1, input_vector_2, time, filter_width_time)
    %EXTRACT_STANDARD_DEVIATION: This function calculates standard
    %deviation over a time interval of a vector
    %Inputs:  time, input_vector, filter_width_time

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Check that vectors are the same length
    if( length(input_vector_1) ~= length(input_vector_2) )
        error("calculate_pearson_correlation_coefficient.f:  Vectors are not the same length!");
    end

    %Initialize std output
    r_out = zeros(size(input_vector_1));

    %Determine filter width from time
    filter_width = round(filter_width_time / mean(diff(time)));

    %*********************************************************************%
    %Begin Std Filter
    %*********************************************************************%

    %Step through data
    for i = filter_width:length(input_vector_1)

        %Calculate centered data
        centered_1 = input_vector_1(i-filter_width+1:i) - mean(input_vector_1(i-filter_width+1:i));
        centered_2 = input_vector_2(i-filter_width+1:i) - mean(input_vector_2(i-filter_width+1:i));

        %Calculate r
        r_out(i-filter_width+1:i) = dot(centered_1, centered_2) / ( norm(centered_1) * norm(centered_2) );

    end

end