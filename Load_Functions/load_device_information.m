function device_information = load_device_information(filename)
%This function loads information from the device information file

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Open file
    fid = open_file(filename, 'r');

    %*********************************************************************%
    %Extract device information
    %*********************************************************************%

    %Look for device ID
    fgetl(fid);
	device_information.device_id = fscanf(fid,'Device ID: %d');

    %Look for Firmware Version
	fgetl(fid);
	device_information.firmware_version = fscanf(fid,'Firmware Version: %5f');

    %Look for hardware version
	fgetl(fid);
	device_information.hardware_version = fscanf(fid,'Hardware Version: %5f');

    %Determine Device ID String
    switch device_information.device_id
		case 1
			device_information.device_id_string = 'Spatial';
		case 3
			device_information.device_id_string = 'Orientus';
		case 4
			device_information.device_id_string = 'Spatial FOG';
		case 5
			device_information.device_id_string = 'Spatial Dual';
		case 11
			device_information.device_id_string = 'Orientus v3+';
		case 16
			device_information.device_id_string = 'Spatial FOG Dual';
		case 17
			device_information.device_id_string = 'Motus';
		case 19
			device_information.device_id_string = 'GNSS Compass';
		case 26
			device_information.device_id_string = 'Certus / Certus EVO';
		case 27
			device_information.device_id_string = 'Aries';
		otherwise
			device_information.device_id_string = 'other';
    end

    %Close file
	fclose(fid);

    %*********************************************************************%
    %Print Device Information
    %*********************************************************************%

    fprintf("****Device Information****\n");
    fprintf("Device: %s\n", device_information.device_id_string);
    fprintf("Device ID: %f\n", device_information.device_id);
    fprintf("Firmware Version: %f\n", device_information.firmware_version)
    fprintf("Hardware version: %f\n", device_information.hardware_version)

end
	