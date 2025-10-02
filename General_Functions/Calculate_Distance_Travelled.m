function distance_travelled = Calculate_Distance_Travelled(positions)
%This function calculates the distance that has been travelled
%This function assumes that GNSS is being used as a source of truth.
%Spoofing can badly degrade this capability.

    %*********************************************************************%
    %Initialization
    %*********************************************************************%
    
    %Initialize distance travelled
    distance_travelled = zeros(length(positions),1);

    %*********************************************************************%
    %Begin Calculations
    %*********************************************************************%
    
    %Step through positions
    for i = 2:length(positions)

        %Calculate distance at these positions
        distance_travelled(i)       = distance_travelled(i-1) + distance_between_lat_lon_points(positions(i-1, 1:2), positions(i, 1:2));

    end

end

