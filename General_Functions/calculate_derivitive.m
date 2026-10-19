function derivitive = calculate_derivitive(input, time)
%This function calculates a derivitive from input & time vector

    %*********************************************************************%
    %Initialization
    %*********************************************************************%
    
    %Initialize distance travelled
    derivitive = zeros(length(input),1);

    %*********************************************************************%
    %Begin Calculations
    %*********************************************************************%
    
    %Step through positions
    for i = 2:length(input)

        %Calculate distance at these positions
        derivitive(i)       = ( input(i) - input(i-1) )/( time(i) - time(i-1) );

    end

end

