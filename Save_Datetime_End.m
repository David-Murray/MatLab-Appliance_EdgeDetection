function [DataFinal] = Save_Datetime_End(DataFinal, Time)
for a = 1:length(DataFinal(end).edge_Rise)
    datetime_End(a,:) = Time(DataFinal.edge_Fall(a)); 
end
    DataFinal(end).EndTime = datetime_End;
end