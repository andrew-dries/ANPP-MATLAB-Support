function log_converter = load_log_converter(filename)
%This function loads information from the configuration file

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Open file
    fid = open_file(filename, 'r');

    %*********************************************************************%
    %Extract configuration information
    %*********************************************************************%

    %Grab line
    log_converter = fgetl(fid);

    %Close file
	fclose(fid);

end
	

