function prop = Propagate_Inertial_Rates(state, raw_sensors, bias)
%PROPAGATE_RAW_SENSORS

    %*********************************************************************%
    %Initialize
    %*********************************************************************%

    %Initialize prop position, velocity, accel, orientation
    prop.position               = zeros(size(raw_sensors.accelerometers));
    prop.velocity               = zeros(size(raw_sensors.accelerometers));
    prop.acceleration           = zeros(size(raw_sensors.accelerometers));

    %Create initial position, velocity, accel
    prop.position(1,:)          = state.position(1,:);
    prop.velocity(1,:)          = state.velocity(1,:);
    prop.acceleration(1,:)      = state.acceleration(1,:);

    %Initialize prop time
    prop.duration_seconds       = raw_sensors.duration_seconds;

    %*********************************************************************%
    %Begin Propagation: Loop
    %*********************************************************************%
    
    %Initializations
    state_indx          = 0;
    bias_indx           = 0;

    %Begin Loop
    for i = 1:length(raw_sensors.duration_seconds)-1

        %*****************************************************************%
        %Begin First Pass Tasks
        %*****************************************************************%

        %Determine index of state data that most closely matches raw
        %sensors index
        state_indx = find(abs(raw_sensors.duration_seconds(i) - state.duration_seconds) == min(abs(raw_sensors.duration_seconds(i) - state.duration_seconds)));

        %Error check state indx
        if(length(state_indx) > 1)
            state_indx = min(state_indx);
        end
        
        %Determine index of bias data that most closely matches raw
        %sensors index
        bias_indx = find(abs(raw_sensors.duration_seconds(i) - bias.duration_seconds) == min(abs(raw_sensors.duration_seconds(i) - bias.duration_seconds)));

        %Error check state indx
        if(length(bias_indx) > 1)
            bias_indx = min(bias_indx);
        end

        %Calculate dt
        dt = raw_sensors.duration_seconds(i+1) - raw_sensors.duration_seconds(i);
        
        %*****************************************************************%
        %Calculate NED Trasnform & Apply
        %*****************************************************************%

        %Calculate transform
        dcm = inertialToNED(state.orientation(state_indx,1), state.orientation(state_indx,2), state.orientation(state_indx,3));

        %Apply transform
        NED_accel       = dcm*(raw_sensors.accelerometers(i,:) - bias.accelerometer_bias(bias_indx,:))';
        NED_gyro        = dcm*raw_sensors.gyroscopes(i,:)';

        %*****************************************************************%
        %Remove Gravity
        %*****************************************************************%

        %Remove grav
        prop.acceleration(i+1,:)    = NED_accel' + [0,0,9.80665];

        %*****************************************************************%
        %Propagate States
        %*****************************************************************%

        %Propagate velocity
        prop.velocity(i+1,:)        = prop.velocity(i,:) + prop.acceleration(i+1,:)*dt;

        %Propagate positional displacement
        pos_dt                      = prop.velocity(i+1,:)*dt;

        %Convert position displacement into lat, lon, height
        prop.position(i+1,:)        = Calculate_Position_From_Displacement(prop.position(i,:), pos_dt);

    end



    %Grab positions & times
    positions.input_1   = state.position(:,1:2);
    positions.input_2   = prop.position(:,1:2);
    
    time.input_1        = state.duration_seconds;
    time.input_2        = prop.duration_seconds;
    
    %Make Plot Info
    plot_info.title     = "COTS D90 GNSS Jamming (Lat,Long)";
    plot_info.x_label   = "Latitude";
    plot_info.y_label   = "Longitude";
    plot_info.legend    = {"State", "Prop"};
    
    %Call position history function
    position_fig        = Plot_Position_History(positions, plot_info);

    %Make input vectors
    times.time1             = prop.duration_seconds;
    times.time2             = prop.duration_seconds;
    times.time3             = prop.duration_seconds;
    
    input_vectors.inp1      = prop.acceleration(:,1);
    input_vectors.inp2      = prop.acceleration(:,2);
    input_vectors.inp3      = prop.acceleration(:,3);

    %Make Plot Info
    plot_info.create_figure = 1;
    plot_info.title         = "Acceleration";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "Acceleration";
    plot_info.legend        = {"Accel X", "Accel Y", "Accel Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make plot
    heading_check           = Plot_Time_History(times, input_vectors, plot_info);

    %Make input vectors
    times.time1             = prop.duration_seconds;
    times.time2             = prop.duration_seconds;
    times.time3             = prop.duration_seconds;
    
    input_vectors.inp1      = prop.velocity(:,1);
    input_vectors.inp2      = prop.velocity(:,2);
    input_vectors.inp3      = prop.velocity(:,3);

    %Make Plot Info
    plot_info.create_figure = 1;
    plot_info.title         = "Velocity";
    plot_info.x_label       = "Time (s)";
    plot_info.y_label       = "velocity";
    plot_info.legend        = {"velocity X", "velocity Y", "velocity Z"};
    plot_info.lims_x        = [];
    plot_info.lims_y        = [];
    
    %Make plot
    heading_check           = Plot_Time_History(times, input_vectors, plot_info);


end


function position = Calculate_Position_From_Displacement(position_init, pos_dt)
%This function takes an initial position, and a positional displacement in
%meters, and creates a new position - %Position [lat, lon, height]

    %*********************************************************************%
    %Initialization
    %*********************************************************************%

    %Defines constants
    R           = 6371*10^3;
    deg_2_rad   = pi/180;

    % --- WGS84 Ellipsoid Parameters ---
    a = 6378137.0;         % Semi-major axis (equatorial radius) in meters
    f = 1/298.257223563;   % Flattening
    e_sq = f * (2 - f);    % Square of the first eccentricity

    %Initialize position output
    position = [];

    %*********************************************************************%
    %Calculate new Position
    %*********************************************************************%
    
    % Convert initial latitude from degrees to radians for trigonometric functions
    lat_rad = position_init(1)*deg_2_rad;
    lon_rad = position_init(2)*deg_2_rad;
    
    % Extract displacement components
    delta_north = pos_dt(1);
    delta_east  = pos_dt(2);
    delta_down  = pos_dt(3);

    % Calculate the radii of curvature at the initial latitude
    % R_N: Meridian radius of curvature (for North-South displacement)
    % R_E: Transverse radius of curvature (for East-West displacement)
    sin_lat_sq = sin(lat_rad)^2;
    denom = sqrt(1 - e_sq * sin_lat_sq);
    
    R_N = a * (1 - e_sq) / (denom^3); % Also called M in some literature
    R_E = a / denom;                  % Also called N in some literature
    
    % Calculate the change in latitude and longitude in radians
    % The effective radius for latitude change is the meridian radius plus height.
    % The effective radius for longitude change is the transverse radius plus
    % height, scaled by the cosine of the latitude.
    delta_lat_rad = delta_north / (R_N + position_init(3));
    delta_lon_rad = delta_east / ((R_E + position_init(3)) * cos(lat_rad));
    
    % Calculate the new latitude and longitude in radians
    lat_new_rad = lat_rad + delta_lat_rad;
    lon_new_rad = lon_rad + delta_lon_rad;
    
    % Convert new latitude and longitude back to degrees
    position(1) = 1/deg_2_rad*lat_new_rad;
    position(2) = 1/deg_2_rad*lon_new_rad;
    
    % Calculate the new height. A positive "down" displacement decreases height.
    position(3) = position_init(3) - delta_down;

end