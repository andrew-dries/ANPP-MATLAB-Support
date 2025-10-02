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

function biases_data = load_bias_state_log(filename, time_filter)
%This function reads in bias state data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in data from csv file
    data = csvread(filename, 1, 1);

    %Initialize output struct
    biases_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [biases_data, time_mask] = process_time_log_file(biases_data, data(:,1:2), time_filter);
    
    %Load raw data
    biases_data.accelerometer_bias = data(time_mask,3:5);
    biases_data.accelerometer_bias_standard_deviation = data(time_mask,6:8);
    biases_data.gyroscope_bias = data(time_mask,9:11);
    biases_data.gyroscope_bias_standard_deviation = data(time_mask,12:14);
    biases_data.qnh = data(time_mask,15);
    biases_data.qnh_standard_deviation = data(time_mask,16);
    biases_data.x_axis_integration = data(time_mask,17);
    biases_data.zero_angular_rate_updates = data(time_mask,18);
    biases_data.zero_velocity_updates = data(time_mask,19);

    if(length(data(1,:))>22)
        biases_data.magnetometer_zero_rate_updates = data(time_mask,20);
        biases_data.accelerometer_roll_update = data(time_mask,21);
        biases_data.accelerometer_pitch_update = data(time_mask,22);
        biases_data.accelerometer_trust = data(time_mask,23);
    end

    if(length(data(1,:))>29)
        biases_data.accelerometer_rejection_counter = data(time_mask,24);
        biases_data.heading_rejection_counter = data(time_mask,25);
        biases_data.roll_pitch_rejection_counter = data(time_mask,26);
        biases_data.gyroscope_bias_rejection_counter = data(time_mask,27);
        biases_data.position_rejection_counter = data(time_mask,28);
        biases_data.velocity_rejection_counter = data(time_mask,29);
        biases_data.accelerometer_bias_rejection_counter = data(time_mask,30);
    end

end
