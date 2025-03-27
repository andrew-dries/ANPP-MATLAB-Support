function rms = extract_rms(input_vector)
    %EXTRACT_RMS Calculates root mean square of an input vector
    %Inputs:  Input Vector (3 dimensions typically, could be 1)

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize RMS
    rms = zeros(size(input_vector,1),1);

    %Input vector width
    input_vector_width = size(input_vector,2);

    %*********************************************************************%
    %Construct RMS
    %*********************************************************************%

    %Perform RMS calcultaion
    for i = 1:input_vector_width
        rms = rms + input_vector(:,i).^2;
    end

    %Square root
    rms = sqrt(rms);

end

