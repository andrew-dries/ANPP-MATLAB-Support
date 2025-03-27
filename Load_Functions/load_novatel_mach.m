function novatel_data = load_novatel_mach(filepath)

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output data
    novatel_data = struct();

    %Create novatel header
    header = {'unix_time', 'system_time', 'latitude', 'longitude', 'easting', ...
              'northing', 'height', 'UTM_zone', 'position_sep', 'velocity_x', ...
              'velocity_y', 'velocity_z', 'velocity_sep', 'pitch', 'roll', ...
              'heading', 'pitch_rms', 'roll_rms', 'heading_rms', 'heading_rate', ...
              'heading_rate_rms'};


    %*********************************************************************%
    %Load Data
    %*********************************************************************%

    %Read csv
    csv_raw = csvread(filepath);

    %pair csv with header
    for i = 1:length(header)
        novatel_data.(header{i}) = csv_raw(:,i);
    end

end