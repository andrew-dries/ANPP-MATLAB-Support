function index = find_closest_time_vector(time1, time2)
%This function will take two time vectors of different sizes and for the
%larger vector return the time indecies of the bigger vector
%that best corresponds to the smaller time vector.

    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Find smallest vector length
    smallest    = min(length(time1), length(time2));

    %Find largest vector length
    largest     = max(length(time1), length(time2));

    %Initialize index
    index           = zeros(size(smallest,1));

    %Grab the largest time vector
    if(length(time1) > smallest)
        big_time    = time1;
        small_time  = time2;
    else
        big_time    = time2;
        small_time  = time1;
    end

    %*********************************************************************%
    %Pass through the smaller vector length, and determine the closest time
    %at each iteration
    %*********************************************************************%

    %Step through
    for i = 1:smallest

        %Find the index that matches
        index(i) = find_closest_time(big_time, small_time(i));

        %If index is equal to zero, skip
        if(index(i) == 0)

            index(i) = 1;

        end

    end

end

