function index = find_closest_time(time_vector, time_desired)
%This function returns the time index of a timte vector closest to the
%desired time.  This function operates by subtracting the time desired from
%the time vector, taking the absolute value, and finding the index of the
%minimum value.

    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Initialize index
    index               = 0;

    %Determine if time desired is outside min and max of vector
    if(min(time_vector) > time_desired)
        index           = 1;
        return;
    elseif(max(time_vector) < time_desired)
        index           = length(time_vector);
        return;
    end

    %*********************************************************************%
    %Find min time
    %*********************************************************************%

    %Remove the time desired from the time vector
    time_vector_minus   = abs(time_vector - time_desired);

    %Find min index
    index               = find(time_vector_minus == min(time_vector_minus), 1);

end