function Add_Paths_Recursive(FolderPath)

    %ADD_PATHS_RECURSIVE Recursively adds to MATLAB paths any directories
    %imbedded in FolderPath input directory not currently added to MATLAB paths
    %
    %Inputs: FolderPath (string): Path to the folder whose path & subpaths you
    %want added to the MATLAB path.  FolderPath should only contain a
    %single folder & not an array of folder locations.
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Function statement
    fprintf("Recursively adding all directories inside of path: %s.\n", FolderPath);
    
    %Grab current paths
    paths = path;
    
    %Split into cell array of paths
    paths = strsplit(paths, ';');
    
    %Turn into nx1 vector
    paths = paths';
    
    %*********************************************************************%
    %Begin Logic
    %*********************************************************************%
    
    %Call recursive find paths function
    OutputPaths = find_folders_recursive(FolderPath);

    %Add FolderPath to end of OutputPaths
    OutputPaths{end+1,1} = FolderPath;

    %Convert from cell to character vectors
    OutputPaths = cellstr(OutputPaths');

    %Add all of these to the MATLAB path
    addpath(OutputPaths{:})

end


function OutputPaths = find_folders_recursive(FolderPath)

    %FIND_FOLDERS_RECURSIVE Recursively searches for embedded directories
    %inside of input directory
    %
    %Inputs: FolderPath (string): Path of directory to perform search.

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize output paths
    OutputPaths     = {};
    count           = 1;

    %*********************************************************************%
    %Begin Logic
    %*********************************************************************%

    %Search for folders in current directory
    dirs = dir(FolderPath);

    %Search through all paths
    for i = 3:length(dirs)

        %If directory, add to output paths & call Add Paths Recursive
        %on this directory
        if(dirs(i).isdir)

            %Construct foldername
            foldername              = strcat(dirs(i).folder, "/", dirs(i).name);
            
            %Add to OutputPaths
            OutputPaths{count,1}    = foldername;

            %Increment count
            count = count + 1;

            %Call Add Paths Recursive
            Recursive_Output        = find_folders_recursive(foldername);

            %Determine recursively found output paths size
            output_length           = length(Recursive_Output);

            %If length greater than 0, add
            if(output_length > 0)
    
                %Step through all recursively found paths and add to output
                %paths
                for j = 1:output_length

                    %Add recurisvely found paths to Output Paths
                    OutputPaths{count,1} = Recursive_Output{j};
        
                    %Increment count
                    count = count + 1;

                end

            end

        end

    end

end