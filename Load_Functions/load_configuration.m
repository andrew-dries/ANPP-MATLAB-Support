function configuration = load_configuration(filename, device_id)
%This function loads information from the configuration file

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Open file
    fid = open_file(filename, 'r');

    %Initialize internal variables
    configuration.hardIronX             = 0;
	configuration.hardIronY             = 0;
	configuration.hardIronZ             = 0;
	configuration.gnssAntennaOffsetX    = 0;
	configuration.gnssAntennaOffsetY    = 0;
	configuration.gnssAntennaOffsetZ    = 0;
	configuration.rollOffset            = 0;
	configuration.pitchOffset           = 0;
	configuration.headingOffset         = 0;

    %*********************************************************************%
    %Extract configuration information
    %*********************************************************************%

    %Step through file until end
	while ~feof(fid)

        %Read new line
	    line = fgetl(fid);

        %Search for GNSS Antenna Offsets
        if strfind(line,'GNSS Antenna Offset X = ')
            lineScan = textscan(line,'%s%s%s%s%s%f%s');
            configuration.gnssAntennaOffsetX = lineScan{6};
        elseif strfind(line,'GNSS Antenna Offset Y = ')
            lineScan = textscan(line,'%s%s%s%s%s%f%s');
            configuration.gnssAntennaOffsetY = lineScan{6};
        elseif strfind(line,'GNSS Antenna Offset Z = ')
            lineScan = textscan(line,'%s%s%s%s%s%f%s');
            configuration.gnssAntennaOffsetZ = lineScan{6};

        %Search for Secondary GNSS Antenna Offsets
        elseif strfind(line,'Manual Offset X = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.gnssManualOffsetX = lineScan{5};
        elseif strfind(line,'Manual Offset Y = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.gnssManualOffsetY = lineScan{5};
        elseif strfind(line,'Manual Offset Z = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.gnssManualOffsetZ = lineScan{5};

        %Search for Secondary GNSS Antenna Offsets
        elseif strfind(line,'Offset Type = ')
            lineScan = strsplit(line,'Offset Type = ');
            configuration.OffsetType = lineScan{2};
        elseif strfind(line,'Automatic Offset Orientation = ')
            lineScan = strsplit(line,'Automatic Offset Orientation = ');
            configuration.AutomaticOffsetOrientation = lineScan{2};

        %Look for Hard Iron Offset
        elseif strfind(line,'Hard Iron X = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.hardIronX = lineScan{5};
        elseif strfind(line,'Hard Iron Y = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.hardIronY = lineScan{5};
        elseif strfind(line,'Hard Iron Z = ')
            lineScan = textscan(line,'%s%s%s%s%f');
            configuration.hardIronZ = lineScan{5};

        %Look for Roll, Pitch & Haw Offsets
        elseif strfind(line,'Roll Offset = ')
            lineScan = textscan(line,'%s%s%s%f%s');
            configuration.rollOffset = lineScan{4};
        elseif strfind(line,'Pitch Offset = ')
            lineScan = textscan(line,'%s%s%s%f%s');
            configuration.pitchOffset = lineScan{4};
        elseif strfind(line,'Heading Offset = ')
            lineScan = textscan(line,'%s%s%s%f%s');
            configuration.headingOffset = lineScan{4};
        end
    end

    %Close file
	fclose(fid);

    %*********************************************************************%
    %Print Configuration Information
    %*********************************************************************%

    %Look for GNSS Anetnna Offsets not being set
	if( configuration.gnssAntennaOffsetX + configuration.gnssAntennaOffsetY + configuration.gnssAntennaOffsetZ == 0 )
		fprintf("WARNING: GNSS Antenna Offset not set\n");
	end

    %Look for Magnetic Calibration not beign perforemd
	if( (configuration.hardIronX + configuration.hardIronY + configuration.hardIronZ == 0) && (device_id == 1 || device_id == 17 || device_id == 3 || device_id == 11))
		fprintf("WARNING: Magnetic Calibration not performed\n");
	end

    %Look for abscence of roll and pitch offsets
	if( configuration.rollOffset + configuration.pitchOffset == 0 )
        fprintf("WARNING: No roll and pitch offset entered\n");
    else
        fprintf("NOTE: Roll Offset: %f degrees.\n", configuration.rollOffset);
        fprintf("NOTE: Pitch Offset: %f degrees.\n", configuration.pitchOffset);
	end

    %Look for heading offset
	if( configuration.headingOffset == 0 )
        fprintf("NOTE: No heading offset entered\n");
    end

end
	