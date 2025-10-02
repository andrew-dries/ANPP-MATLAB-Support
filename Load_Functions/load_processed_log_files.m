function data = load_processed_log_files(folderpath, time_filter)
%LOAD_PROCESSED_LOG_FILES This function loads all data from files that
%exist in this folder.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    data                = [];

    %Determine time interval
    if(nargin >= 2)

        %Perform error checks
        %Check is empty
        if(~isempty(time_filter.time_interval))
            
            %Length
            if(length(time_filter.time_interval) ~= 2)
                error("Time interval size incorrect!")
            end
    
            %Min/Max
            if(time_filter.time_interval(1) >= time_filter.time_interval(2))
                error("Time interval first element is larger than or equal to second element!  Time interval should consist consist of [min time, max time].")
            end

        end

    end

    %*********************************************************************%
    %Begin Loading Files
    %*********************************************************************%

    %Check for .mat file
    if(exist(strcat(folderpath,'/log.mat'), 'file') == 2)

        %Load file
        try(load(strcat(folderpath,'/log.mat'), 'data', 'time_interval_save'))

            %Check if data exists or not
            if(~exist("data"))
                %Check for time interval & make sure they match
            elseif(isempty(time_filter.time_interval) && isempty(time_interval_save))
                return;
            elseif(isempty(time_filter.time_interval) && ~isempty(time_interval_save))
            elseif(isempty(time_interval_save) && ~isempty(time_filter.time_interval))
            elseif(time_filter.time_interval(1) == time_interval_save(1) && time_filter.time_interval(2) == time_interval_save(2))
                return;
            end
            
        end

        %If you made it here, we're going to reload the log data
        fprintf("Reloading log data!  Time intervals did not match.\n");

    end

    %load device information
    if(exist(strcat(folderpath,'/DeviceInformation.txt'), 'file') == 2)

        %Load device information
        data.device_information = load_device_information(strcat(folderpath,'/DeviceInformation.txt'));
        
        %Grab device ID
        device_id = data.device_information.device_id;

    else

        %Initialize device_id to 0 if no device information file
        device_id = 0;

    end

    %Load Configuration File
    if(exist(strcat(folderpath,'/Configuration.txt'), 'file') == 2)
        data.configuration = load_configuration(strcat(folderpath,'/Configuration.txt'), device_id);
    end

    %Load Log Converter File
    if(exist(strcat(folderpath,'/LogConverter.txt'), 'file') == 2)
        data.log_converter = load_log_converter(strcat(folderpath,'/LogConverter.txt'));
    end

    %Load State
    if(exist(strcat(folderpath,'/State.csv'), 'file') == 2)
        data.state = load_state_log(strcat(folderpath,'/State.csv'), time_filter);
    end

    %Load System Status
    if(exist(strcat(folderpath,'/Status.csv'), 'file') == 2)
        data.status = load_status_log(strcat(folderpath,'/Status.csv'), time_filter);
    end

    %Load RawSensors
    if(exist(strcat(folderpath,'/RawSensors.csv'), 'file') == 2)
        data.raw_sensors = load_sensor_log(strcat(folderpath,'/RawSensors.csv'), time_filter);
    end

    %Load Satellites
    if(exist(strcat(folderpath,'/Satellites.csv'), 'file') == 2)
        data.satellites = import_satellites_log(strcat(folderpath,'/Satellites.csv'), time_filter);
    end

    %Load RawGNSS
    if(exist(strcat(folderpath,'/RawGNSS.csv'), 'file') == 2)
        data.raw_gnss = load_rawGNSS_log(strcat(folderpath,'/RawGNSS.csv'), time_filter);
    end

    %Load Euler Standard Deviation
    if(exist(strcat(folderpath,'/EulerStandardDeviation.csv'), 'file') == 2)
        data.euler_sd = load_euler_sd_log(strcat(folderpath,'/EulerStandardDeviation.csv'), time_filter);
    end

    %Load North Seeking Status
    if(exist(strcat(folderpath,'/NorthSeekingStatus.csv'), 'file') == 2)
        data.north_seeking_status = load_north_seeking_status(strcat(folderpath,'/NorthSeekingStatus.csv'), time_filter);
    end

    %Load PDR
    if(exist(strcat(folderpath,'/PedestrianDeadReckoning.csv'), 'file') == 2)
        data.pdr = load_pedestrian_dead_reckoning_log(strcat(folderpath,'/PedestrianDeadReckoning.csv'), time_filter);
    end

    %Load body velocity Log
    if(exist(strcat(folderpath,'/BodyVelocity.csv'), 'file') == 2)
        data.body_velocity = load_body_velocity_log(strcat(folderpath,'/BodyVelocity.csv'), time_filter);
    end

    %Load body accceleration Log
    if(exist(strcat(folderpath,'/BodyAcceleration.csv'), 'file') == 2)
        data.body_acceleration = load_body_acceleration_log(strcat(folderpath,'/BodyAcceleration.csv'), time_filter);
    end

    %Load velocity standard deviation log
    if(exist(strcat(folderpath,'/VelocityStandardDeviation.csv'), 'file') == 2)
        data.velocity_sd = load_velocity_sd_log(strcat(folderpath,'/VelocityStandardDeviation.csv'), time_filter);
    end

    %Load external velocity log
    if(exist(strcat(folderpath,'/ExternalVelocity.csv'), 'file') == 2)
        data.external_velocity = load_external_velocity_log(strcat(folderpath,'/ExternalVelocity.csv'), time_filter);
    end

    %Load external body velocity log
    if(exist(strcat(folderpath,'/ExternalBodyVelocity.csv'), 'file') == 2)
        data.external_body_velocity = load_external_body_velocity_log(strcat(folderpath,'/ExternalBodyVelocity.csv'), time_filter);
    end

    %Load extended satellites log
    if(exist(strcat(folderpath,'/ExtendedSatellites.csv'), 'file') == 2)
        data.extended_satellites = load_extended_satellites_log(strcat(folderpath,'/ExtendedSatellites.csv'), time_filter);
    end

    %Load odometer state log
    if(exist(strcat(folderpath,'/OdometerState.csv'), 'file') == 2)
        data.odometer_state = load_odometer_state_log(strcat(folderpath,'/OdometerState.csv'), time_filter);
    end

    %Load bias state log
    if(exist(strcat(folderpath,'/Biases.csv'), 'file') == 2)
        data.bias = load_bias_state_log(strcat(folderpath,'/Biases.csv'), time_filter);
    end

    %Load wind log
    if(exist(strcat(folderpath,'/Wind.csv'), 'file') == 2)
        data.wind_data = load_wind_log(strcat(folderpath,'/Wind.csv'), time_filter);
    end

    %Load ADU log
    if(exist(strcat(folderpath,'/ExternalAirData.csv'), 'file') == 2)
        data.adu_data = load_adu_log(strcat(folderpath,'/ExternalAirData.csv'), time_filter);
    end

    %Load detailed satellites log
    if(exist(strcat(folderpath,'/DetailedSatellites.csv'), 'file') == 2)
        data.detailed_satellites_data = load_detailed_satellites_log(strcat(folderpath,'/DetailedSatellites.csv'), time_filter);
    end

    %Load geoid height log
    if(exist(strcat(folderpath,'/GeoidHeight.csv'), 'file') == 2)
        data.geoid_height_data = load_geoid_height_log(strcat(folderpath,'/GeoidHeight.csv'), time_filter);
    end

    %Load UpTime log
    if(exist(strcat(folderpath,'/UpTime.csv'), 'file') == 2)
        data.uptime_data = load_uptime_log(strcat(folderpath,'/UpTime.csv'), time_filter);
    end

    %Load Kinematica Post Processed Log
    if(exist(strcat(folderpath,'/PostProcessed.csv'), 'file') == 2)
        data.kinematica_data = load_post_processed_kinematica_log(strcat(folderpath,'/PostProcessed.csv'), time_filter);
    end

    %*********************************************************************%
    %Save as .mat file
    %*********************************************************************%

    %Save time interval as time_interval_save
    time_interval_save = time_filter.time_interval;

    %Execute save
    if(~isempty(data))
        save(strcat(folderpath,'/log.mat'), 'data', 'time_interval_save', "-v7.3");
    else
        error("Check your directory, data to be saved is empty!")
    end

end

