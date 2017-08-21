function [DataFinal] = Check_PointCount(DataFinal, Appliance)
%CHECK_POINTCOUNT Removes a signature which doesn't contain enough
%information.
%   If a signature contains far too few points for its duration it is
%   removed due to lack of information.
log = logical(zeros(length(DataFinal(end).edge_Diff),1)); %#ok<LOGL>
for sig = 1:length(DataFinal(end).edge_Rise)
    Difference = DataFinal(end).edge_Fall(sig)-DataFinal(end).edge_Rise(sig);
    if Difference < Appliance.MinPoints
        log(sig,1) = 1;
    end
end
fields= fieldnames(DataFinal);
% -1 ignores 'nextEvent' field
for i = 1:numel(fields)-1
    DataFinal(end).(fields{i})(log,:) = [];
end
end

