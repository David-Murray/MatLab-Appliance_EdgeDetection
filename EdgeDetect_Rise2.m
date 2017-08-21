function [rising_Edges] = ...
    EdgeDetect_Rise2(Data, min_Pow, max_Pow)
%Normal Offset
D_Diff = diff(Data);
D_Diff_Off = [D_Diff(2:end); 0;];
r_Edges = find(D_Diff < min_Pow & D_Diff_Off > min_Pow & D_Diff_Off < max_Pow);
%Two Step Offset
D_Diff_Sum_1 = ([diff(Data);0] + [0;diff(Data)]);
D_Diff_Sum_1(D_Diff_Sum_1 < 0) = 0;
D_Diff_Sum_1_Off = [D_Diff_Sum_1(2:end);0;];
r_Edges_1 = find(D_Diff_Sum_1 < min_Pow & D_Diff_Sum_1_Off > min_Pow & D_Diff_Sum_1_Off < max_Pow);
%Three Step Offset

rising_Edge = sort([r_Edges;r_Edges_1]);
rising_Edges = unique(rising_Edge);
end