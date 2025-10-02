function Add_Common_Paths_Function(ANPP_MATLAB_Support_Path)
%This function is used to add common MATLAB paths to the MATLAB search path

    %Set folder paths
    FolderPath{1} = ANPP_MATLAB_Support_Path;
    
    %Call add paths recursive
    for i = 1:length(FolderPath)
        Add_Paths_Recursive(FolderPath{i})
    end

end