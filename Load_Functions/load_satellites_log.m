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

function satellites_data = load_satellites_log(filename)
%This function reads in raw sensor data

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
	data = csvread(filename, 1, 1);

    %Initialize output struct
    satellites_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    satellites_data = process_time_log_file(satellites_data, data(:,1:2));

    %Extract satellite data
    satellites_data.hdop = data(:,3);
    satellites_data.vdop = data(:,4);
    satellites_data.gps_satellites = data(:,5);
    satellites_data.glonass_satellites = data(:,6);
    satellites_data.beidou_satellites = data(:,7);
    satellites_data.galileo_satellites = data(:,8);
    satellites_data.sbas_satellites = data(:,9);
	satellites_data.total_satellites = data(:,5) + data(:,6) + data(:,7) + data(:,8) + data(:,9);

end
