function input = sort_vector(input)
%SORT_VECTOR This function sorts a vector from smallest to largest values

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Determine vector length
    vec_length  = length(input);

    %*********************************************************************%
    %Begin Sort
    %*********************************************************************%

    %Bubble Sort Algorithm
    for i = 1:vec_length-1
        for j = 1:vec_length-i
            if( input(j) > input(j+1) )
                % Swap elements
                temp            = input(j);
                input(j)        = input(j+1);
                input(j+1)      = temp;
            end
        end
    end

end