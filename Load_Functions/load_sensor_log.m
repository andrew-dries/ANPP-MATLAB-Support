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

function sensor_data = load_sensor_log(filename, time_interval)
%This function reads in raw sensor data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in data from csv file
    data = csvread(filename, 1, 1);

    %Initialize output struct
    sensor_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Process time
    [sensor_data, time_mask] = process_time_log_file(sensor_data, data(:,1:2), time_interval);

    %Load raw data
    sensor_data.accelerometers = data(time_mask,3:5);
    sensor_data.gyroscopes = data(time_mask,6:8);
    sensor_data.magnetometers = data(time_mask,9:11);
    sensor_data.imu_temperature = data(time_mask,12);
    sensor_data.pressure = data(time_mask,13);
    sensor_data.pressure_temperature = data(time_mask,14);

end
