function [DataFinal] = Save_Datetime_Start(DataFinal, Time)
for a = 1:length(DataFinal(end).edge_Rise)
    datetime_Start(a,:) = Time(DataFinal.edge_Rise(a)); 
end
    DataFinal(end).StartTime = datetime_Start;
end