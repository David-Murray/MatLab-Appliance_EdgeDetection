function [DataFinal] = Calc_kWh(DataFinal, Time, Data)
   for a = 1:length(DataFinal(end).edge_Rise)
       diff_Time = seconds(diff(Time(DataFinal(end).edge_Rise(a):DataFinal(end).edge_Fall(a))));
       diff_Time(end+1,1) = diff_Time(end,1);
       RemoveBase = Data(DataFinal(end).edge_Rise(a):DataFinal(end).edge_Fall(a))-Data(DataFinal(end).edge_Rise(a)-1);
       kWh= (diff_Time/3600) .* (RemoveBase/1000);
       calcKWH(a,1) = sum(kWh);
   end
   DataFinal(end).kWh = calcKWH;
end