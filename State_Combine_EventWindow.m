function [DataStruct] = State_Combine_EventWindow(DataStruct, Appliance)
for state = 1:size(DataStruct,2)
    if state < Appliance.States
        for event = 1:length(DataStruct(state).edge_Rise)
            for stateSearch = 1:size(DataStruct,2)
                found = find(DataStruct(stateSearch).edge_Rise > DataStruct(state).edge_Rise(event),1);
                if isempty(found) == 1
                    nextEvent(stateSearch) = Inf;
                else
                    nextEvent(stateSearch) = DataStruct(stateSearch).edge_Rise(found);
                end
            end
            DataStruct(state).nextEvent(event) = min(nextEvent);
        end     
    end
end
end

