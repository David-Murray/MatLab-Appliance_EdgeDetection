function [TrainingPositive, TargetPositive] = NN_Gen_Training(DataFinal, Aggregate, Appliance)
windowSize = Appliance.WindowSize;
for i = 1:length(DataFinal.edge_Rise)
    applianceWindow = DataFinal.edge_Fall(i,1) - DataFinal.edge_Rise(i,1);
    pad = windowSize - applianceWindow;
    if pad < 0
        continue
    else
        frontPad = round(pad/2);
        if rem(pad,2) == 1; backPad = frontPad-2; else backPad = frontPad-1; end
        display(i)
        try
            TrainingPositive{1,i} = Aggregate((DataFinal.edge_Rise(i,1)-frontPad):(DataFinal.edge_Fall(i,1)+backPad))';
            TargetPositive{1,i} = [zeros(1,frontPad) ones(1,applianceWindow) zeros(1,backPad+1)];
        catch
            continue
    end
end
for i = 1:length(DataFinal.edge_Rise)
    if i == length(DataFinal.edge_Rise)
        continue
    else
        diffNeg = DataFinal.edge_Rise(i+1) - DataFinal.edge_Fall(i);
        if diffNeg > windowSize
            r = randi([DataFinal.edge_Fall(i) DataFinal.edge_Rise(i+1)-windowSize],1,1);
            TrainingPositive{1,end+1} = Aggregate(r:r+windowSize-1)';
            TargetPositive{1,end+1} = zeros(1,windowSize);
        end
    end
end
end