function [DataStruct] = State_Combine_Optional(DataStruct, Appliance, dataDiff, dataDiffOffset)
for state = 1:size(DataStruct,2)
    if state < Appliance.States % States with following states will be completed here.
        for event = 1:length(DataStruct(state).edge_Fall) % Loop through all events of state(N)
            start = DataStruct(state).edge_Fall(event);   % State Start Index
            if DataStruct(state).nextEvent(event) == Inf  % If there is no more events set to end of data
                next = length(dataDiff);
            elseif (DataStruct(state).nextEvent(event)-start) < (Appliance.DurationLong(state+1)/8)
                next = DataStruct(state).nextEvent(event); %If there is a same state event set it to that
            else
                next = start + Appliance.DurationLong(state+1)/8;
            end
            next = round(next);
            upperLimit = round(Appliance.HighPower(state+1) * 1.25);
            lowerLimit = round(Appliance.LowPower(state+1) * 0.75);
            % Finds the last occurence within the specified range and prays
            % it is the actual end and not the start of the next.
            found = find(...
                dataDiff(start:next) > -upperLimit...
                & dataDiffOffset(start:next) < -lowerLimit...
                & dataDiffOffset(start:next) > -upperLimit...
                ,1,'last');
            if isempty(found) == 0 % If something was found
                DataStruct(state).edge_Fall(event) = start + found+1;
                DataStruct(state).state_include(event) = DataStruct(state).state_include(event) + state+1; 
            end
        end
        % Anything detected in an optional flaged appliance is a full event
        % in this stage.
    end
end
end