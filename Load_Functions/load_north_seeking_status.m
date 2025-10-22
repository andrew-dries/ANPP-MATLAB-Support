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

function coarse_alignment_status = load_north_seeking_status(filename, time_filter)

    %*********************************************************************%
    %Initializations
    %*********************************************************************%

    %Read in data from csv file
    data = csvread(filename, 1, 1);

    %Initialize output struct
    coarse_alignment_status = struct();

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Process time
    [coarse_alignment_status, time_mask] = process_time_log_file(coarse_alignment_status, data(:,1:2), time_filter);
    
    %Process other outputs
    coarse_alignment_status.northseeking_complete = data(time_mask,3);
    coarse_alignment_status.northseeking_cannot_start = data(time_mask,4);
    coarse_alignment_status.solution_out_of_range = data(time_mask,5);
    coarse_alignment_status.solution_nonorthogonal = data(time_mask,6);
    coarse_alignment_status.excessive_movement = data(time_mask,7);
    coarse_alignment_status.latitude_change = data(time_mask,8);
    coarse_alignment_status.leverarm_change = data(time_mask,9);
    coarse_alignment_status.invalid_latitude = data(time_mask,10);
    coarse_alignment_status.progress = data(time_mask,11);
    coarse_alignment_status.alignment_attempts = data(time_mask,12);
    coarse_alignment_status.heading = data(time_mask,13);
    coarse_alignment_status.predicted_accuracy = data(time_mask,14);
    
end