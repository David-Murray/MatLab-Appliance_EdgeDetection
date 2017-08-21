function [TrainingPositive, TargetPositive] = NN_Gen_Training_Neg(DataFinal, Aggregate, Appliance)
windowSize = Appliance.WindowSize;
for i = 1:length(DataFinal.edge_Rise)
    applianceWindow = DataFinal.edge_Fall(i,1) - DataFinal.edge_Rise(i,1);
    pad = windowSize-applianceWindow;
    if pad < 0
        continue
    else
    frontPad = round(pad/2);
    if rem(pad,2) == 1
        backPad = frontPad-2;
    else
        backPad = frontPad-1;
    end
    TrainingPositive{1,i} = Aggregate((DataFinal.edge_Rise(i,1)-frontPad):(DataFinal.edge_Fall(i,1)+backPad))';
    TargetPositive{1,i} = [zeros(1,frontPad) zeros(1,applianceWindow)+1 zeros(1,backPad+1)];
    end
end
end