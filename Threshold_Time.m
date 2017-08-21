function [risingEdge, fallingEdge] = Threshold_Time ...
    (risingEdge, fallingEdge, Time, timeShort, timeLong)

diffTime = etime(datevec(Time(fallingEdge)), datevec(Time(risingEdge)));
diffEdge = diffTime < timeShort | diffTime > timeLong;
risingEdge(diffEdge) = [];
fallingEdge(diffEdge) = [];
end