function C_b_n = inertialToNED(roll, pitch, heading)
% inertialToNED Creates a transformation matrix from a body frame to the NED frame.
%
% This function calculates the Direction Cosine Matrix (DCM) that rotates
% a vector from the body-fixed frame (e.g., an inertial sensor frame) to the
% local North-East-Down (NED) navigation frame. The transformation is based
% on the provided roll, pitch, and heading Euler angles.
%
% The body frame axes are typically defined as:
%   x-axis: forward (roll axis)
%   y-axis: right (pitch axis)
%   z-axis: down (yaw/heading axis)
%
% The rotation sequence is ZYX (Heading, Pitch, Roll).
%
% Inputs:
%   roll    - The roll angle (phi) in radians. Rotation about the body x-axis.
%   pitch   - The pitch angle (theta) in radians. Rotation about the body y-axis.
%   heading - The heading angle (psi) in radians. Rotation about the body z-axis.
%
% Outputs:
%   C_b_n   - The 3x3 Direction Cosine Matrix (DCM) for transforming a
%             vector from the body frame to the NED frame. To use it, you
%             would perform: v_NED = C_b_n * v_body.
%

% --- Input Validation (Optional but Recommended) ---
if nargin ~= 3
    error('This function requires exactly three inputs: roll, pitch, and heading.');
end

% --- Pre-calculate Sine and Cosine for efficiency ---
c_phi = cosd(roll);
s_phi = sind(roll);

c_th = cosd(pitch);
s_th = sind(pitch);

c_psi = cosd(heading);
s_psi = sind(heading);

% --- Define the individual rotation matrices ---

% R_x(phi): Rotation about the x-axis (Roll)
% R_x = [1,  0,      0;
%        0,  c_phi,  s_phi;
%        0, -s_phi,  c_phi];

% R_y(theta): Rotation about the y-axis (Pitch)
% R_y = [c_th,  0, -s_th;
%        0,     1,  0;
%        s_th,  0,  c_th];

% R_z(psi): Rotation about the z-axis (Heading/Yaw)
% R_z = [c_psi,  s_psi, 0;
%       -s_psi,  c_psi, 0;
%        0,      0,     1];


% --- Compute the combined Direction Cosine Matrix (DCM) ---
% The transformation from body to NED is C_b_n = R_x(phi) * R_y(theta) * R_z(psi).
% Note: The order of multiplication is crucial. Here we are using the
% aerospace standard rotation sequence 3-2-1 (Yaw-Pitch-Roll).
% However, to build the matrix that directly transforms from body to NED,
% we construct it as shown below.

C_b_n = [ ...
    c_th*c_psi,   -c_phi*s_psi + s_phi*s_th*c_psi,    s_phi*s_psi + c_phi*s_th*c_psi; ...
    c_th*s_psi,    c_phi*c_psi + s_phi*s_th*s_psi,   -s_phi*c_psi + c_phi*s_th*s_psi; ...
    -s_th,         s_phi*c_th,                       c_phi*c_th ...
];

% An alternative way to compute the same matrix is by matrix multiplication
% of the individual rotation matrices. Note the transpose to get the body-to-NED
% transformation. The final matrix is the same.
% C_n_b = R_x * R_y * R_z; % This is NED to Body
% C_b_n_alternative = C_n_b'; % Transpose to get Body to NED

end

% --- Example Usage ---
%{
  % Define some example Euler angles in degrees
  roll_deg = 10;
  pitch_deg = -5;
  heading_deg = 45;

  % Convert angles to radians for the function
  roll_rad = deg2rad(roll_deg);
  pitch_rad = deg2rad(pitch_deg);
  heading_rad = deg2rad(heading_deg);

  % Generate the transformation matrix
  dcm = inertialToNED(roll_rad, pitch_rad, heading_rad);

  % Display the resulting matrix
  disp('Direction Cosine Matrix (Body to NED):');
  disp(dcm);

  % Example: Transform a vector from the body frame to the NED frame
  % Let's say the sensor measures an acceleration vector purely along its
  % x-axis (e.g., moving forward).
  accel_body = [9.81; 0; 0];

  % Calculate the acceleration in the NED frame
  accel_ned = dcm * accel_body;

  disp('Acceleration vector in body frame:');
  disp(accel_body);
  disp('Acceleration vector in NED frame:');
  disp(accel_ned);
%}
