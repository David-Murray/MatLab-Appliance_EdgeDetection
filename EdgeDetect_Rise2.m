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
D_Diff_Sum_2 = ([diff(Data);0;0;] + [0;diff(Data);0;] + [0;0;diff(Data);]);
D_Diff_Sum_2(D_Diff_Sum_2 < 0) = 0;
D_Diff_Sum_2_Off = [D_Diff_Sum_2(2:end);0;];
r_Edges_2 = find(D_Diff_Sum_2 < min_Pow & D_Diff_Sum_2_Off > min_Pow & D_Diff_Sum_2_Off < max_Pow);
% Three Step Offset - Check for duplicates first then remove 1
r_Unique = (setdiff(r_Edges_2,[r_Edges;r_Edges_1]))-1;

rising_Edge = sort([r_Edges;r_Edges_1;r_Unique]);
rising_Edges = unique(rising_Edge);

% x_plot = 1:length(Data);
% plot(Data)
% hold
% plot(x_plot(rising_Edges),Data(rising_Edges),'rx')
end