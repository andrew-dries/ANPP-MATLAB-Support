function [freq_resp, freq] = extract_frequency_information(time, output)
    
    %extract_frequency_information This funciton will extract the FFT for
    %either gyros or accels
    %Inputs: time(N,1), output(N,1)
    %N = number of sampled data points
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Initialize outputs
    freq_resp   = [];
    freq        = [];

    %Grab length of input vector
    len = length(time);

    %Calculate sampling period
    fs = 1/mean(diff(time));

    %Calculate frequencies
    freq = (0:fs/len:fs/2)';

    %Replace NaNs with zeros
    for i = 1:size(output,2)
        output(isnan(output(:,i)),i) = 0.0;
    end

    %*********************************************************************%
    %Perform FFT & acquire noise density
    %Steps:
    %       1.  Remove mean
    %       2.  Take FFT
    %       3.  Acquire noise density
    %*********************************************************************%

    %Remove bias by calculating mean and remove
    output = output - mean(output);

    %Take FFT
    xdft = fft(output);

    %Grab the first 1:len/2-1 of data
    xdft = xdft(1:len/2+1,:);

    %Square the FFT data and divide by the frequency interval
    freq_resp = (1/(fs*len)) * abs(xdft).^2;

    %Multiply by 2 to maintain the total power (we only used half of the fft data due to symmetry of fft response)
    freq_resp(2:end-1) = 2*freq_resp(2:end-1);

    %Take mean of PSD
    freq_resp = sqrt(freq_resp);

end

