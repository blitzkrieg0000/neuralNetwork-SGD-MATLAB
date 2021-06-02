function [ww, wb] = wwGuncelle(out, ww, wb, HL_NO, delta, layers, input, lRate, aktivasyonAd)
layerGiris = {input, out{1:end-1}};

n = numel(layers);       

    %Layer sayısı kadar dönecek
    for i=n:-1:1
        

    if("softmax" == aktivasyonAd)
        if(i==n)
            guncel{i} = delta;
        else
            guncel{i} = delta.*HL_NO{i};
        end
    else
        guncel{i} = delta.*HL_NO{i};
    end
        
        clear delta; %delta Error değerlerini tutarken sonradan, bir önceki işlem yapılan sütunun toplam değerini alıyor.
        delta = sum(ww{i}.*guncel{i}',2);

        ww{i} = ww{i} - lRate*(layerGiris{i}.*guncel{i}');
        wb{i} = wb{i} - lRate.*guncel{i}';             
        
    end
    
    
end