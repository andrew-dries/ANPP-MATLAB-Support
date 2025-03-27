% /****************************************************************/
% /*                                                              */
% /*      Advanced Navigation Packet Protocol Library             */
% /*            Matlab Log Import, Version 3.0                    */
% /*   Copyright 2013, Xavier Orr, Advanced Navigation Pty Ltd    */
% /*                                                              */
% /****************************************************************/
% /*
% * Copyright (C) 2013 Advanced Navigation Pty Ltd
% *
% * Permission is hereby granted, free of charge, to any person obtaining
% * a copy of this software and associated documentation files (the "Software"),
% * to deal in the Software without restriction, including without limitation
% * the rights to use, copy, modify, merge, publish, distribute, sublicense,
% * and/or sell copies of the Software, and to permit persons to whom the
% * Software is furnished to do so, subject to the following conditions:
% *
% * The above copyright notice and this permission notice shall be included
% * in all copies or substantial portions of the Software.
% *
% * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
% * DEALINGS IN THE SOFTWARE.
% */

function rawGNSS_data = load_rawGNSS_log(filename, time_interval)
%This function reads in raw sensor data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
	data = csvread(filename, 1, 1);

    %Initialize output struct
    rawGNSS_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [rawGNSS_data, time_mask] = process_time_log_file(rawGNSS_data, data(:,1:2), time_interval);

    %Load data
    rawGNSS_data.position = data(time_mask,3:5);
    rawGNSS_data.velocity = data(time_mask,6:8);
    rawGNSS_data.position_standard_deviation = data(time_mask,9:11);
    rawGNSS_data.tilt = data(time_mask,12);
    rawGNSS_data.heading = data(time_mask,13);
    rawGNSS_data.tilt_standard_deviation = data(time_mask,14);
    rawGNSS_data.heading_standard_deviation = data(time_mask,15);
    rawGNSS_data.status.fix_type = data(time_mask,16);
    rawGNSS_data.status.doppler_velocity_valid = data(time_mask,17);
    rawGNSS_data.status.time_valid = data(time_mask,18);
    rawGNSS_data.status.external_gnss = data(time_mask,19);
    rawGNSS_data.status.tilt_valid = data(time_mask,20);
    rawGNSS_data.status.heading_valid = data(time_mask,21);

    if (length(data(1,:)) >= 22)
        rawGNSS_data.status.floating_heading = data(time_mask,22);
    end

    % Extra columns for Aries...
    if (length(data(1,:)) >= 23)
        rawGNSS_data.status.antenna1_disconnected = data(time_mask,23);
    end
    if (length(data(1,:)) >= 24)
        rawGNSS_data.status.antenna2_disconnected = data(time_mask,24);
    end
    if (length(data(1,:)) >= 25)
        rawGNSS_data.status.antenna1_short = data(time_mask,25);
    end
    if (length(data(1,:)) >= 26)
        rawGNSS_data.status.antenna2_short = data(time_mask,26);
    end
    if (length(data(1,:)) >= 27)
        rawGNSS_data.status.gnss1_failure = data(time_mask,27);
    end
    if (length(data(1,:)) >= 28)
        rawGNSS_data.status.gnss2_failure = data(time_mask,28);
    end

end
