function Add_Common_Paths_Function()
%This function is used to add common MATLAB paths to the MATLAB search path

    %Set folder paths
    FolderPath{1} = 'C:\Users\andrewdries\Documents\MATLAB\Support\ANPP-MATLAB-Support\';
    FolderPath{2} = 'C:\Users\andrewdries\Documents\NAS\Sandbox\octave';
    
    %Call add paths recursive
    for i = 1:length(FolderPath)
        Add_Paths_Recursive(FolderPath{i})
    end

end