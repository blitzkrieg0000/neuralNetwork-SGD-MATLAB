function [d,y] = karistir(dat, tag)
    kar = [dat, tag];
    [xu, ~] = size(kar);
    kar = [kar, randperm(xu)'];
    kar = sortrows(kar, length(kar(end,:)));

    d = kar(:,1:end-2); %data
    y = kar(:,end-1);   %taglar
end