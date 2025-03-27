% /****************************************************************/
% /*                                                              */
% /*      Advanced Navigation Packet Protocol Library             */
% /*            Matlab Log Import, Version 3.0                    */
% /*   Copyright 2023, Xavier Orr, Advanced Navigation Pty Ltd    */
% /*                                                              */
% /****************************************************************/
% /*
% * Copyright (C) 2023 Advanced Navigation Pty Ltd
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

function pdr_data = load_pedestrian_dead_reckoning_log(filename)
    
    %*********************************************************************%
    %Initializations
    %*********************************************************************%
	data = csvread(filename, 1, 1);

    %Initialize output struct
    pdr_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    pdr_data = process_time_log_file(pdr_data, data(:,1:2));

    %Extract PDR data
    pdr_data.status.user_step_length_set = data(:,3);
    pdr_data.status.walking_active = data(:,4);
    pdr_data.status.running_active = data(:,5);
    pdr_data.status.no_motion = data(:,6);
    pdr_data.status.initialised = data(:,7);
    pdr_data.step_frequency = data(:,8);
    pdr_data.heading_offset = data(:,9);
    pdr_data.leg_length = data(:,10);
    pdr_data.stride_length = data(:,11);
    pdr_data.velocity = data(:,12:14);

end