function [fallingEdge] = EdgeDetect_Fall ...
    (dataDiff, dataDiffOff, risingEdge, lowPower, highPower, durationShort)
% Number of rising edges detected
risingLength = length(risingEdge);
fallingEdge = zeros(risingLength,1);
buffer = round(durationShort/8);
for j = 1:risingLength
        upperLimit = highPower * 1.25;
        lowerLimit = lowPower * 0.75;
    % Event End Detection
    % This section looks for an end event between each rise point, if it
    % can not find one it makes the next point the end point.
    start = risingEdge(j)+buffer;
    if j < risingLength
        % If nothing can be found within the longest possible duration
        % assume it is a spike.
        next = risingEdge(j+1);
        fallingIndice = find(...
            dataDiff(start:next) > -upperLimit & ...
            dataDiffOff(start:next) < -lowerLimit &  ...
            dataDiffOff(start:next) > -upperLimit ...
            ,1,'first');
        if isempty(fallingIndice)
            fallingEdge(j,1) = risingEdge(j) + 2;
        else
            fallingEdge(j,1) = risingEdge(j) + fallingIndice + buffer + 2;
        end
    else
        fallingIndice = find(dataDiffOff(start:end) < -lowerLimit ...
            & dataDiff(start:end) > -upperLimit ...
            & dataDiffOff(start:end) > -upperLimit ...
            ,1,'first');
        if isempty(fallingIndice)
            fallingEdge(end) = risingEdge(j) + 1;
        else
            fallingEdge(end) = risingEdge(j) + fallingIndice + 2;
        end
    end
end
end