function [Table] ...
    = Run_Detect_App(Time, Data, ApplianceType, genGraphs, genFig)
% Load Appliance Details
load('Appliance.mat')
% Select Appliance
for i = 1:length(Appliance) %#ok<NODEF>
    isMatch = strcmp(Appliance(i).Name,ApplianceType);
    if isMatch == 1
        match = i; break;
    end
end
Appliance = Appliance(match);

for state = 1:Appliance.requireState
    % Load Appliance Details for Current State
    pow_Low = Appliance.LowPower(state);
    pow_High = Appliance.HighPower(state);
    % Length of an event in seconds, 3600,7200,10800,14400 = 1,2,3,4 hours.
    dur_Short = Appliance.DurationShort(state);
    dur_Long = Appliance.DurationLong(state);
    % A larger gap means that the profile is more erratic
    % e.g. Washing Machine spin cycle requires a higher gap
    time_Gap = Appliance.DurationGap(state);
    
    [edge_Rise] = ...
        EdgeDetect_Rise2(Data, pow_Low, pow_High);
    
    [edge_Fall] = ...
        EdgeDetect_Fall2(Time, Data, edge_Rise, pow_Low, ...
        pow_High, dur_Short, dur_Long);
    % Compensates for the offset in the detection.
    Edges = [edge_Rise edge_Fall];
    Z = isnan(Edges(:,2));
    Edges(Z,:) = [];
    edge_Rise = Edges(:,1);
    edge_Fall = Edges(:,2);
    
    figure(1)
    plot(Time,Data)
    hold
    plot(Time(edge_Rise),Data(edge_Rise),'bx')
    plot(Time(edge_Fall),Data(edge_Fall),'ro')
    hold
    
    [edge_Rise, edge_Fall] = ...
        Threshold_Cont(edge_Rise, edge_Fall, Time, time_Gap);
    
    figure(2)
    plot(Time,Data)
    hold
    plot(Time(edge_Rise),Data(edge_Rise),'bx')
    plot(Time(edge_Fall),Data(edge_Fall),'ro')
    hold
    
    [edge_Rise, edge_Fall] = ...
        Threshold_Time(edge_Rise, edge_Fall, Time, dur_Short, dur_Long);
    
    figure(3)
    plot(Time,Data)
    hold
    plot(Time(edge_Rise),Data(edge_Rise),'bx')
    plot(Time(edge_Fall),Data(edge_Fall),'ro')
    hold
    
    DataStruct(state).edge_Rise = edge_Rise-1;
    DataStruct(state).edge_Fall = edge_Fall;
    DataStruct(state).edge_Diff = ...
        Data(DataStruct(state).edge_Fall)-Data(DataStruct(state).edge_Rise);
    DataStruct(state).state_include = zeros(length(edge_Rise),1)+state;
end

DataFinal = DataStruct(end);


% DataFinal checks
% Remove signatures based on number of points.
[DataFinal] = Check_PointCount(DataFinal, Appliance);
[DataFinal] = Calc_kWh(DataFinal, Time, Data);
[DataFinal] = Calc_Duration(DataFinal, Time);
[DataFinal] = Save_Datetime_Start(DataFinal, Time);
[DataFinal] = Save_Datetime_End(DataFinal, Time);

if genFig == 1
    figure; hold on;
    plot(Time, Data, 'y');
    plot(Time(DataFinal(end).edge_Rise),...
         Data(DataFinal(end).edge_Rise), 'rx');
    plot(Time(DataFinal(end).edge_Fall),...
         Data(DataFinal(end).edge_Fall),'bo');
    title(Appliance.Name)
    hold off
end

[Table] = GenTable(DataFinal);

end