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
    %Determine heading quadrants
    %*********************************************************************%
    
    %Quadrant mask
    quad_mask(:,1)              = velocity(:,1) >= 0 & velocity(:,2) >= 0;
    quad_mask(:,2)              = velocity(:,1) >= 0 & velocity(:,2) <= 0;
    quad_mask(:,3)              = velocity(:,1) <= 0 & velocity(:,2) <= 0;
    quad_mask(:,4)              = velocity(:,1) <= 0 & velocity(:,2) >= 0;

    %*********************************************************************%
    %Calculate velocity heading
    %*********************************************************************%
    
    %Tan(Ang)   = Opposite / Adjacent
    %Opposite   = easting
    %Adjacent   = northing
    %Calculate velocity heaidng
    angle                       = atand(velocity(:,2) ./ velocity(:,1));

    %Apply quadrants adjustments
    velocity_heading(quad_mask(:,1)) = angle(quad_mask(:,1));               %Quadrant 1 is no adjustment
    velocity_heading(quad_mask(:,2)) = angle(quad_mask(:,2)) + 360;         %Quadrant 2 is +360
    velocity_heading(quad_mask(:,3)) = angle(quad_mask(:,3)) + 180;         %Quadrant 3 is +180
    velocity_heading(quad_mask(:,4)) = angle(quad_mask(:,4)) + 180;         %Quadrant 4 is +180

end

