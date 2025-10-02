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

function adu_data = load_adu_log(filename, time_filter)
%This function reads in adu log data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in data from csv file
    data = csvread(filename, 1, 1);

    %Initialize output struct
    adu_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [adu_data, time_mask] = process_time_log_file(adu_data, data(:,1:2), time_filter);
    %Load raw data
    adu_data.altitude_delay = data(time_mask,3);
    adu_data.airspeed_delay = data(time_mask,4);
    adu_data.altitude = data(time_mask,5);
    adu_data.airspeed = data(time_mask,6);
    adu_data.altitude_error = data(time_mask,7);
    adu_data.airspeed_error = data(time_mask,8);
    adu_data.system_status.altitude_valid = data(time_mask,9);
    adu_data.system_status.airspeed_valid = data(time_mask,10);
    adu_data.system_status.altitude_overrange = data(time_mask,11);
    adu_data.system_status.airspeed_overrange = data(time_mask,12);
    adu_data.system_status.altitude_sensor_failure = data(time_mask,13);
    adu_data.system_status.airspeed_sensor_failure = data(time_mask,14);   

end
