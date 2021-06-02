function [hata, O, HL_NO] = NN(input, layers, target, ww, wb, aktivasyonFonksiyonu, N, O, HL_NO)

%% son katman ağırlıklarını güncelleme
m = numel(layers);

for i=1:m
   input = gpuArray(input);
   wwG = gpuArray(ww{i});
   wbG = gpuArray(wb{i});

    N{i} = netBul(input, wwG, wbG);
   
    if("softmax" == aktivasyonFonksiyonu)
       if(i == m)
           [O{i}, HL_NO{i}] = aktivasyon(N{i}, 'softmax');
       else
           [O{i}, HL_NO{i}] = aktivasyon(N{i}, 'sigmoid'); 
       end
    else
        [O{i}, HL_NO{i}] = aktivasyon(N{i}, aktivasyonFonksiyonu); 
    end
    
    input = O{i};

    %CPU ya gönder
    O{i} = gather(O{i});
    HL_NO{i} = gather(HL_NO{i});
end

%% MSE
%hata = (power((O{end} - target),2))/2;

%% CrossEntropy
%hata = -( target.*log10(O{end}) + (1-target).*(log10(1-O{end})) );

%% CrossEntropy
hata = -target.*log(O{end});

%hata = -( target.*(1./(O{end})) + (1-target).*(1./(1-O{end})) );
end