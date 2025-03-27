function fid = open_file(filename, rw_option)
%This function verifies a file exists and attempts to open it and return
%the file ID.  Will throw an error if there is an issue opening the file.

    %Open file
    fid = fopen(filename, rw_option);

    %Make sure fid does not equal -1, throw error
    if(fid == -1)

        %Throw error that file could not be opened
        error(strcat("Error opening file!  Filename: ", filename));

    end

end

