function [fallingEdge] = EdgeDetect_Fall2 ...
    (Time, Data,rising_Edge, min_Pow, max_Pow, durationShort, durationLong)
D_Diff = diff(Data);
D_Diff_Offset = [D_Diff(2:end); 0;];
D_Diff_Offset2 = [D_Diff(3:end); 0;0;];

% Sum of differences
Data_Diff_Sum_1 = D_Diff+D_Diff_Offset;

D_Diff_Sum_1 = ([diff(Data);0] + [0;diff(Data)]);
D_Diff_Sum_1(D_Diff_Sum_1 > 0) = 0;
D_Diff_Sum_1_Off = [D_Diff_Sum_1(2:end);0;];

D_Diff_Sum_2 = ([diff(Data);0;0;] + [0;diff(Data);0;] + [0;0;diff(Data);]);
D_Diff_Sum_2(D_Diff_Sum_2 > 0) = 0;
D_Diff_Sum_2_Off = [D_Diff_Sum_2(2:end);0;];

%disp([size(D_Diff) size(D_Diff_Sum_1) size(D_Diff_Sum_2)])

Data_Diff_Sum_2 = D_Diff+D_Diff_Offset+D_Diff_Offset2;
total = length(rising_Edge);
fallingEdge = NaN(total,1);
TimeNum = posixtime(Time);
%disp(size(TimeNum))
TimeLimit = Time(rising_Edge)+seconds(durationShort) < Time(end);
for i =1:total
    if TimeLimit(i) == 1
        rising_Edges_Sum = sum(D_Diff(rising_Edge(i):rising_Edge(i)+2));
    else
        disp('Detected a bad edge')
        break
    end
    if rising_Edges_Sum > min_Pow && rising_Edges_Sum < max_Pow
        beg = rising_Edge(i);
        %disp([i total])
        search_Time = TimeNum > TimeNum(beg) & TimeNum < (TimeNum(beg)+durationLong);
        search_Range = D_Diff(search_Time,1);
        search_Range_Off = D_Diff_Offset(search_Time,1);
        fall_E = find(search_Range > -max_Pow & search_Range_Off < -min_Pow &  search_Range_Off > -max_Pow ,1,'first');
        search_Range1 = D_Diff_Sum_1(search_Time,1);
        search_Range_Off1 = D_Diff_Sum_1_Off(search_Time,1);
        fall_E_1 = find(search_Range1 > -max_Pow & search_Range_Off1 < -min_Pow &  search_Range_Off1 > -max_Pow ,1,'first');
        search_Range2 = D_Diff_Sum_2(search_Time,1);
        search_Range_Off2 = D_Diff_Sum_2_Off(search_Time,1);
        fall_E_2 = find(search_Range2 > -max_Pow & search_Range_Off2 < -min_Pow &  search_Range_Off2 > -max_Pow ,1,'first');
        %disp('A')
        fallingEdges = min(unique([fall_E; fall_E_1; fall_E_2]));
        if isempty(fallingEdges)
            fallingEdge(i,1) = NaN;
        else
            fallingEdge(i,1) = fallingEdges + beg;
        end
        %make this unique
        %if isempty(fall_E)
            
            %disp(size(search_Range))
            %fall_E = 
        %    fall_E_S = find(Data_Diff_Sum_1(beg+5:beg+durationLong,1) < -min_Pow &  Data_Diff_Sum_1(beg+5:beg+durationLong,1) > -max_Pow ,1,'first');
        %    if isempty(fall_E_S)
        %        fall_E_S_2 = find(Data_Diff_Sum_2(beg+5:beg+durationLong,1) < -min_Pow &  Data_Diff_Sum_2(beg+5:beg+durationLong,1) > -max_Pow ,1,'first');
        %        if isempty(fall_E_S_2)
        %            fallingEdge(i,1) = NaN;
        %        else
        %          fallingEdge(i,1) = fall_E_S_2+beg+3;
        %        end
         %   else
         %       fallingEdge(i,1) = fall_E_S+beg+3;
         %   end
        %else
        %    fallingEdge(i,1) = fall_E+beg+3;
        %end
    %else
        %    fallingEdge(i,1) = NaN;
    end
end
end