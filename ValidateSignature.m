function [Table] = ValidateSignature(Time, Data, Table)
for i = 1:height(Table)
	hold off
	plot(Time(Table.risingEdge(i)-500:Table.fallingEdge(i)+500), Data(Table.risingEdge(i)-500:Table.fallingEdge(i)+500))
	hold
	plot(Time(Table.risingEdge(i)), Data(Table.risingEdge(i)), 'rx')
	plot(Time(Table.fallingEdge(i)), Data(Table.fallingEdge(i)), 'bo')
	w = waitforbuttonpress;
	if w == 0
		Z(i, 1) = 0;
        % Mouse click
	else
		Z(i, 1) = 1;
        % Keyboard
	end
end
Table(logical(Z),:) = [];
end