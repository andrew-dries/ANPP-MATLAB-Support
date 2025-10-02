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

function extended_satellites = load_extended_satellites_log(filename, time_filter)
%This function reads in externded satellites data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
	data = csvread(filename, 1, 1);

    %Initialize output struct
    extended_satellites = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Process time
    [extended_satellites, time_mask] = process_time_log_file(extended_satellites, data(:,1:2), time_filter);
    %Load in extended satellites data
	extended_satellites.packet_count = data(time_mask,3);
    extended_satellites.packet_number = data(time_mask,4);
    extended_satellites.total_packets = data(time_mask,5);
    extended_satellites.satellite_system = data(time_mask,6);
    extended_satellites.satellite_number = data(time_mask,7);
    extended_satellites.L1CA = data(time_mask,8);
    extended_satellites.L1C = data(time_mask,9);
	extended_satellites.L1P = data(time_mask,10);
    extended_satellites.L1M = data(time_mask,11);
	extended_satellites.L2C = data(time_mask,12);
    extended_satellites.L2P = data(time_mask,13);
	extended_satellites.L2M = data(time_mask,14);
    extended_satellites.L5 = data(time_mask,15);
	extended_satellites.elevation = data(time_mask,16);
    extended_satellites.azimuth = data(time_mask,17);
	extended_satellites.SNR1 = data(time_mask,18);
    extended_satellites.SNR2 = data(time_mask,19);
	extended_satellites.used_in_posiiton = data(time_mask,20);
    extended_satellites.used_in_heading = data(time_mask,21);

end
