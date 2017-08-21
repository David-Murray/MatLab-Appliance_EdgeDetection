function [risingEdge, fallingEdge] = Threshold_Cont ...
    (risingEdge, fallingEdge, Time, timeGap)

% Calculate Time Between Event
 diffTimeGap = [NaN; seconds(Time(risingEdge(2:end))-Time(fallingEdge(1:end-1)))];
 
% Generates 1's and where a time between events is smaller than the gap.
%    __________
% __|          |___
diffGap = diff(diffTimeGap < timeGap);
eventIndices = zeros(length(risingEdge),1);

% Groups events based on the end of the 1's generated.

for l = 1:length(diffGap)
    if diffGap(l) == 1
        eventEnd = find(diffGap(l:end) == -1, 1);
        if isempty(eventEnd) == 1
            eventIndices(l+1:end) = 1;
            fallingEdge(l) = fallingEdge(end);
        else
            eventIndices(l+1:l+eventEnd-1) = 1;
            fallingEdge(l) = fallingEdge(l + eventEnd -1);
        end
    end
end
eventIndices = logical(eventIndices);
risingEdge(eventIndices) = [];
fallingEdge(eventIndices) = [];
end