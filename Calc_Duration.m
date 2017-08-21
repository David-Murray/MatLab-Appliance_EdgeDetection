function [DataFinal] = Calc_Duration(DataFinal, Time)
   for a = 1:length(DataFinal(end).edge_Rise)
       durCalc(a,1) = seconds(Time(DataFinal(end).edge_Fall(a))-Time(DataFinal(end).edge_Rise(a)));
   end
   DataFinal(end).Duration = durCalc;
end