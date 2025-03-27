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

function odometer_state = load_odometer_state_log(filename, time_interval)
%This function reads in external body velocity data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read data
	data = csvread(filename, 1, 1);

    %Initialize output struct
    odometer_state = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Process time
    [odometer_state, time_mask] = process_time_log_file(odometer_state, data(:,1:2), time_interval);

    %Grab other outputs
    odometer_data.pulse_count = data(time_mask,3);
    odometer_data.distance = data(time_mask,4);
    odometer_data.speed = data(time_mask,5);
    odometer_data.slip = data(time_mask,6);
    odometer_data.active = data(time_mask,7);
    
end
