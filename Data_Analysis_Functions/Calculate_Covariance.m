function covariance = Calculate_Covariance(vector1, vector2)
%This function calculates the covariance between two vectors
    %*********************************************************************%
    %Initialization
    %*********************************************************************%
    
    %Perform checks to make sure the vectors are the same size
    if(size(vector1,1) ~= size(vector2,1) || ...
       size(vector1,2) ~= size(vector2,2))
        error("Calculate_Covariance: Vectors are different sizes")
    end

    %Initialize covariance
    covariance = 0;

    %*********************************************************************%
    %Begin Calculations
    %*********************************************************************%
    
    %Calculate mean for each vector
    mean_1 = mean(vector1);
    mean_2 = mean(vector2);

    %Calculate covariance
    for i = 1:length(vector1)

        %Calculate covariance
        covariance = covariance + (vector1(i) - mean_1)*(vector2(i) - mean_2);

    end

    %Normalize
    covariance = covariance / length(vector1);

end

