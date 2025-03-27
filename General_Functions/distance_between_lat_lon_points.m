function distance = distance_between_lat_lon_points(positions1, positions2)
%This function calcualtes the distance between two points

    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Defines constants
    R           = 6371*10^3;
    deg_2_rad   = pi/180;

    %Initialize distance
    distance = 0;

    %Convert degrees to radians
    positions1 = positions1*deg_2_rad;
    positions2 = positions2*deg_2_rad;

    %*********************************************************************%
    %Calculate Distance
    %*********************************************************************%
    
    %Make starting calcs
    delta_lat   = positions2(1) - positions1(1);
    delta_lon   = positions2(2) - positions1(2);

    %Calculate a
    a           = sin(delta_lat/2)^2 + cos(positions1(1))*cos(positions2(1))*sin(delta_lon/2)^2;

    %Calcualte c
    c           = 2*atan2(sqrt(a), sqrt(1-a));

    %Calcualte distance
    distance    = R*c;

end