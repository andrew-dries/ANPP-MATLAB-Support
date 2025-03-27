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

function geoid_height_data = load_geoid_height_log(filename, time_interval)
%This function reads in geoid height log

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in data from csv file
    data = csvread(filename, 1, 1);

    %Initialize output struct
    geoid_height_data = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%
    
    %Process time
    [geoid_height_data, time_mask] = process_time_log_file(geoid_height_data, data(:,1:2), time_interval);

    %Load raw data
    geoid_height_data.geoid_height = data(time_mask,3);

end
