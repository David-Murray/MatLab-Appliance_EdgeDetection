function [fallingEdge] = EdgeDetect_Fall2 ...
	(Time, Data,rising_Edge, min_Pow, max_Pow, durationShort, durationLong)
Data_Diff = diff(Data);
Data_Diff_Offset1 = [Data_Diff(2:end); 0;];
Data_Diff_Offset2 = [Data_Diff(3:end); 0;0;];

% Sum of differences
Data_Diff_Sum_1 = Data_Diff+Data_Diff_Offset1;
Data_Diff_Sum_2 = Data_Diff+Data_Diff_Offset1+Data_Diff_Offset2;
fallingEdge = NaN(length(rising_Edge),1);
total = length(rising_Edge);
for i =1:total
	% Fridge = 60 130
	% Microwave 1150 1300
	if Time(rising_Edge(i))+seconds(durationShort) < Time(end)
		rising_Edges_Sum = sum(Data_Diff(rising_Edge(i):rising_Edge(i)+2));
        %disp('Sum')
        %disp(rising_Edges_Sum)
    else
        disp('Detected a bad edge')
		break
	end
	if rising_Edges_Sum > min_Pow && rising_Edges_Sum < max_Pow
		beg = rising_Edge(i)+1;
		if (length(Data_Diff) - beg) >= durationLong
			% Fridge = - 130 -30 -130
            disp([i,total])
            search_Time = Time > Time(beg+1) & Time < Time(beg+1)+seconds(durationLong);
			search_Range = Data_Diff(search_Time,1);
			search_Range_Off = Data_Diff_Offset1(search_Time,1);
			fall_E = find(search_Range > -max_Pow & search_Range_Off < -min_Pow &  search_Range_Off > -max_Pow ,1,'first');
			if isempty(fall_E)
				fall_E_S = find(Data_Diff_Sum_1(beg+5:beg+durationLong,1) < -min_Pow &  Data_Diff_Sum_1(beg+5:beg+durationLong,1) > -max_Pow ,1,'first');
				if isempty(fall_E_S)
					fall_E_S_2 = find(Data_Diff_Sum_2(beg+5:beg+durationLong,1) < -min_Pow &  Data_Diff_Sum_2(beg+5:beg+durationLong,1) > -max_Pow ,1,'first');
					if isempty(fall_E_S_2)
						fallingEdge(i,1) = NaN;
					else
						fallingEdge(i,1) = fall_E_S_2+beg+3;
					end
				else
					fallingEdge(i,1) = fall_E_S+beg+3;
				end
			else
				fallingEdge(i,1) = fall_E+beg+3;
			end
		else
			fallingEdge(i,1) = NaN;
		end
	else
		fallingEdge(i,1) = NaN;
	end
end
end