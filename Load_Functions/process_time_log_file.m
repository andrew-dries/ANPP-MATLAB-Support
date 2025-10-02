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

function [log_data, time_mask] = process_time_log_file(log_data, time_data, time_filter)
%This function process time from log files

    %*********************************************************************%
    %Initializations
    %*********************************************************************%
    
    %Check for time interval
    %The time interval is exclusively for time duration in seconds
    if(~isempty(time_filter.time_interval))

        %Mask time
        mask_time = 1;

        %Initialize time mask
        time_mask   = logical(zeros(size(time_data(:,1))));

        %Set min and max time
        time_min    = time_filter.time_interval(1);
        time_max    = time_filter.time_interval(2);

    else

        %Mask time
        mask_time = 0;

        %Initialize time mask
        time_mask   = logical(ones(size(time_data(:,1))));

    end

    %*********************************************************************%
    %Begin processing data
    %*********************************************************************%

    %Grab uix time
    log_data.unix_time_seconds  = time_data(:,1) + time_data(:,2)/1000000;

    %*********************************************************************%
    %Begin processing duration in seconds
    %*********************************************************************%

    %Perform diff of unix time and look for big jumps where UTC corrections
    %occur
    utc_diff = [0;abs(diff(log_data.unix_time_seconds))];

    %Use either mode / mean / median if they are not zero
    utc_diff_stat_thresh = mode(utc_diff(utc_diff~=0));

    %Mask for any diffs significantly greater than the mean / mode / median
    mask_utc_time_diff = utc_diff > 9*utc_diff_stat_thresh;

    %Replace these time jumps with the stat thresh
    utc_diff(mask_utc_time_diff) = utc_diff_stat_thresh;

    %Grab duration
    log_data.duration_seconds = cumsum(utc_diff);

    %*********************************************************************%
    %Calculate datetime
    %*********************************************************************%

    %Grab datetime
    log_data.datetime = datetime(log_data.unix_time_seconds, 'ConvertFrom', 'posixtime');
    
    %*********************************************************************%
    %Create time mask
    %*********************************************************************%
    %The time mask is for filtering using time duration in seconds only

    %Check mask time bool
    if(mask_time)

        %time_type definitions
        %1 - date time
        %2 - duration
        if(time_filter.time_type == 1) %date time
            error("Date time is not supported for time filtering!");
        elseif(time_filter.time_type == 2) %duration
            mask_time   = log_data.duration_seconds;
        elseif(time_filter.time_type == 3) %Unix Time
            mask_time   = log_data.unix_time_seconds;
        end

        %Create mask
        time_mask   = mask_time >= time_min & mask_time <= time_max;

        %Check to make sure time mask is not null
        if(isempty(find(time_mask == 1)))
            fprintf('***********ERROR***********\n');
            fprintf('Incorrect time interval given, time interval falls outside of duration!\n');
            fprintf('Time Interval:  %f, %f\n', time_filter.time_interval(1), time_filter.time_interval(2));
            fprintf('Time Duration [Min, Max]:  %f, %f\n', min(log_data.duration_seconds), max(log_data.duration_seconds));
            fprintf('***********ERROR***********\n');
            error("Incorrect time interval given, time interval falls outside of duration!");
        end

        %Mask time
        log_data.unix_time_seconds      = log_data.unix_time_seconds(time_mask);
        log_data.duration_seconds       = log_data.duration_seconds(time_mask);
        log_data.datetime               = log_data.datetime(time_mask);

    end

    %Grab min unix time
    log_data.utc_time_min       = min(log_data.unix_time_seconds);

end
