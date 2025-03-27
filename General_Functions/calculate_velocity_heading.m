function velocity_heading = calculate_velocity_heading(velocity)
%CALCULATE_VELOCITY_HEADING Summary of this function goes here
%   Detailed explanation goes here

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize heading
    velocity_heading            = zeros(length(velocity),1);

    %Define north vector
    north_vector                = [1,0];

    %*********************************************************************%
    %Calculate velocity heading
    %*********************************************************************%
    
    %Tan(Ang)   = Opposite / Adjacent
    %Opposite   = easting
    %Adjacent   = northing
    %Calculate velocity heaidng
    velocity_heading            = atand(velocity(:,2) ./ velocity(:,1));

    %Filter for negative values and convert to 0 -> 360
    mask                        = velocity_heading < 0;
    velocity_heading(mask)      = 360 + velocity_heading(mask);

end

