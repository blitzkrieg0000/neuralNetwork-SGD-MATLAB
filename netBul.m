function netMatris = netBul(giris, w, wb) 
    %net = sum(giris.*w)' + wb';
    netMatris = giris.*w;
    netMatris(end+1,:) = wb;
end 