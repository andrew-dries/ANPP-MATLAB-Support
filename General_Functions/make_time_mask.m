function time_mask = make_time_mask(time_vector, time_min, time_max)
    %This function is meant to take in a time vector, min and max time, and
    %return a logical vector, or mask, with 1's between min and max time and 0's otherwise
    %
    %INPUTS: time_vector (N,1), time_min, time_max
    %N = Number of Samples
    %time_min = double
    %time_max = double
    
    %*************************************************************************%
    %Perform Checks
    %*************************************************************************%

    %Check time_vector empty
    if(isempty(time_vector))
        error("time_vector is empty!")
    end

    %Check min time
    if(time_min > max(time_vector))
        error("time_min is greater than time_vector maximum time!")
    end

    %Check max time
    if(time_max < min(time_vector))
        error("time_max is less than time_vector minimum time!")
    end

    %*************************************************************************%
    %Initializations
    %*************************************************************************%
    
    %Grab time vector size
    time_size = size(time_vector);

    %Initialize time mask
    time_mask = zeros(time_size);
    
    %*************************************************************************%
    %Create time mask
    %*************************************************************************%
    
    %Find indecies of min and max time
    time_inds(1)    = find( time_vector >= time_min, 1 );
    time_inds(2)    = find( time_vector >= time_max, 1 );
    
    %Set time_mask of these indecies to 1's
    time_mask(time_inds(1):time_inds(2)) = ones(time_inds(2)-time_inds(1)+1,1);

    %Convert to logical
    time_mask  = logical(time_mask);

end