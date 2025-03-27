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

function detailed_satellites_data = load_detailed_satellites_log(filename, time_interval)
%This function reads in raw sensor data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
	data = csvread(filename, 1, 1);

    %Initialize output struct
    detailed_satellites_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Process time
    [detailed_satellites_data, time_mask] = process_time_log_file(detailed_satellites_data, data(:,1:2), time_interval);

    %Grab detailed satellites data
    detailed_satellites_data.packet_count = data(time_mask,3);
	detailed_satellites_data.satellite_system = data(time_mask,4);
	detailed_satellites_data.satellite_prn = data(time_mask,5);
	detailed_satellites_data.L1CA = data(time_mask,6);
	detailed_satellites_data.L1C = data(time_mask,7);
	detailed_satellites_data.L1P = data(time_mask,8);
	detailed_satellites_data.L1M = data(time_mask,9);
	detailed_satellites_data.L2C = data(time_mask,10);
	detailed_satellites_data.L2P = data(time_mask,11);
	detailed_satellites_data.L2M = data(time_mask,12);
	detailed_satellites_data.L5 = data(time_mask,13);
	detailed_satellites_data.elevation = data(time_mask,14);
	detailed_satellites_data.azimuth = data(time_mask,15);
	detailed_satellites_data.snr = data(time_mask,16);
    
end
