%This function is used to add common MATLAB paths to the MATLAB search path

%Housekeeping
clear;

%Set folder paths
FolderPath{1} = 'C:\Users\andrewdries\Documents\MATLAB';
FolderPath{2} = 'C:\Users\andrewdries\Documents\NAS\Sandbox';

%Call add paths recursive
for i = 1:length(FolderPath)
    Add_Paths_Recursive(FolderPath{i})
end