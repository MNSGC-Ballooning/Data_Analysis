function [pconc_avg,pconc_std,Amids] = A_sections(altArr,Pbin,maxA,minA,intervalA)

% create altitude sections
Alt = altArr./1000; % convert alitude to kft
Alt = round(Alt,1); % round to be nice
intervalA = intervalA./1000; % convert to kft

Asections = [minA:intervalA:maxA]';
for i=1:length(Asections)-1
    idx = find(Alt>=Asections(i) & Alt<Asections(i+1));
    pconc = [];
    for j=1:length(idx)
        pconc(j) = Pbin(idx(j));
    end
    pconc_avg(i) = mean(pconc);
    pconc_std(i) = std(pconc);
end

Amids = linspace(Asections(2)/2,Asections(end)-Asections(2)/2,length(Asections)-1);

