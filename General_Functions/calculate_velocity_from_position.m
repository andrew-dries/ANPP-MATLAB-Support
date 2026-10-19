function [velocity] = calculate_velocity_from_position(position, timestamps)

    %Inits
    velocity.vel    = zeros(length(position),3);
    velocity.mag    = zeros(length(position),1);
    distance        = zeros(length(position),1);

    %Calculate time diff
    time_diff = diff(timestamps);

    %Calculate Distance Between Vectors
    for i = 2:length(position(:,1))

        %Calculate velocity magnitude
        if(time_diff(i-1,1) ~= 0)
            velocity.vel(i-1,1)     = distance_between_lat_lon_points([position(i-1,1), 0],...
                                                                      [position(i,1), 0]) / time_diff(i-1);
            velocity.vel(i-1,2)     = distance_between_lat_lon_points([0, position(i-1,2)],...
                                                                      [0, position(i,2)]) / time_diff(i-1);
            velocity.mag(i-1,1)     = distance_between_lat_lon_points(position(i-1,1:2), position(i,1:2)) / time_diff(i-1); 
        end

    end

end