function [roll,pitch] = calculate_roll_and_pitch(raw_sensors)

    %This function calculates the roll and pitch from the accelerometers
    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Initialize covariance
    roll        = zeros(size(raw_sensors,1), 1);
    pitch       = zeros(size(raw_sensors,1), 1);

    %X, Y, Z Vectors
    ax          = raw_sensors(:,1);
    ay          = raw_sensors(:,2);
    az          = raw_sensors(:,3);

    %Convert Radians to Degrees
    rad_2_deg   = 180/pi;

    %*********************************************************************%
    %Begin Calculations
    %*********************************************************************%

    %Calculate roll
    roll       = atan2(-ay, -az)*rad_2_deg;

    %Calculate pitch
    pitch       = atan2(ax, sqrt(ay.^2 + az.^2))*rad_2_deg;

end

