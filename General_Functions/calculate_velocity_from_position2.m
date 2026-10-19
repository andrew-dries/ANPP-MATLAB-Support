function [v_ned] = calculate_velocity_from_position2(lla, timestamps)
    % Inputs:
    % lla: [N x 3] matrix (Latitude in deg, Longitude in deg, Altitude in meters)
    % timestamps: [N x 1] vector (seconds)
    % Output:
    % v_ned: [N x 3] matrix (North, East, Down velocity in m/s)

    % WGS84 Ellipsoid Constants
    a = 6378137.0;              % Semi-major axis (meters)
    f = 1/298.257223563;        % Flattening
    e2 = 2*f - f^2;             % Square of eccentricity

    numPoints = size(lla, 1);
    phi = deg2rad(lla(:,1));    % Latitude to radians
    lambda = deg2rad(lla(:,2)); % Longitude to radians
    h = lla(:,3);               % Altitude

    % 1. Convert LLA to ECEF (X, Y, Z)
    N = a ./ sqrt(1 - e2 * sin(phi).^2);
    X = (N + h) .* cos(phi) .* cos(lambda);
    Y = (N + h) .* cos(phi) .* sin(lambda);
    Z = (N * (1 - e2) + h) .* sin(phi);
    ecef_pos = [X, Y, Z];

    % 2. Numerical Differentiation to get ECEF Velocity
    % Using central difference for interior points, forward/backward for ends
    v_ecef = zeros(numPoints, 3);
    dt = diff(timestamps);
    
    for i = 2:numPoints-1
        % Central difference for better accuracy
        v_ecef(i,:) = (ecef_pos(i+1,:) - ecef_pos(i-1,:)) / (timestamps(i+1) - timestamps(i-1));
    end
    % Boundary conditions
    v_ecef(1, :) = (ecef_pos(2,:) - ecef_pos(1,:)) / dt(1);
    v_ecef(end, :) = (ecef_pos(end,:) - ecef_pos(end-1,:)) / dt(end);

    % 3. Rotate ECEF Velocity to NED
    v_ned = zeros(numPoints, 3);
    for i = 1:numPoints
        % Rotation matrix from ECEF to NED
        % Derived from the rotation: Rz(lambda) * Ry(-phi - 90deg)
        sin_phi = sin(phi(i));
        cos_phi = cos(phi(i));
        sin_lam = sin(lambda(i));
        cos_lam = cos(lambda(i));

        R_en = [-sin_phi*cos_lam, -sin_phi*sin_lam,  cos_phi;
                -sin_lam,          cos_lam,          0;
                -cos_phi*cos_lam, -cos_phi*sin_lam, -sin_phi];

        % Transform the velocity vector
        v_ned(i, :) = (R_en * v_ecef(i, :)')';
    end
end