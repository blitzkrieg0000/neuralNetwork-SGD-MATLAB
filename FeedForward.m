%% FCNN
clc, clearvars -except data y, close all;
format long;

%% Dataset Hazırlama
if ~exist("data", "var")
    [data, y] = hazirla("..\datasets\EEG.xlsx");
end
[~,fVeri] = size(data);

tic
%% Neural Network Ayarları
layers = [15, 10, 3];         %Her bir hidden layerdaki perceptron sayısı ve son değer çıkış layerı 
hedef = zeros(1,max(y))';     %Son katman çıkışlarının almasını istediğimiz değerleri
learningRate = 0.03;          %Öğrenme Katsayısı     
epoch = 100;                  %Tüm veri seti elemanlarının toplam kaç kez NN e gireceği
bias = ones(1,length(layers));
aktivasyonAd = "softmax";     %'sigmoid', 'swish', 'softmax', 'lRelu', 'tanh'

%% 1 ve 0 Arası Rastgele Ağırlık Oluştur
m = numel(layers);
ww{1} = rand(fVeri, layers(1));
wb{1} = rand(1,layers(1));
for i=2:m
    ww{i} = rand(layers(i-1),layers(i));
    wb{i} = rand(1,layers(i));
end

%% Malloc - (Hız için)
for i=1:numel(layers)
   N{i} = zeros(layers(i),1);
   O{i} = zeros(layers(i),1);
   NO{i} = zeros(layers(i),1);
end

%% Ağırlıkları Kaydet
if exist("agirliklar.mat")
    load("agirliklar.mat");
end

ep = 0;	%Geçilen Epoch Sayısı
while (ep<=epoch)

acc = 0;
    for k = 1:length(data)
%% FEEDFORWARD 
            hedef = zeros(1,max(y))';
            hedef(y(k)) = 1;        %One-Hot Vector
            [hata, out, NO] = NN(data(k,:)', layers, hedef, ww, wb, aktivasyonAd, N, O, NO);

%% BACKPROPAGATION
            %CrossEntropyLogLoss Fonksiyonunun Out Layer Netine Göre Türevi
            delta = out{end} - hedef; 
                
            %MeanSquaredErrorLoss Fonksiyonunun Çıkışa Göre Türevi
            %delta = out{s}{end} - targets{s};  

            %CrossEntropyLogLoss Fonksiyonunun Çıkış(lara) Göre Türevi
            %delta = -( targets{s}.*(1./out{s}{end}) + (1-targets{s}).*(1./ (1-out{s}{end})) );
          
            %Güncelle--------------------------------------------------------------------------------------------
            [ww, wb] = wwGuncelle(out, ww, wb, NO, delta, layers, data(k, 1:fVeri)', learningRate, aktivasyonAd);
            
            save("agirliklar.mat",'ww','wb');

%% Error Rateleri Çiz
            errors(k) = 0;
            errors(k) = errors(k) + sum(hata);
            errors(k) = sum(errors)./length(errors);

            figure(1),
            hataGoster(errors, ep, k);

%% ACC---------------------------------------------------------------------
            [~, tar] = max(out{1, numel(layers)});
            [~, tar2] = max(hedef);
            if (tar == tar2)
                acc = 1+acc;
            end

            if (mod(k,5)==0)
                clc,
                    ww{1}(1:5,:),
                    disp('Epoch: ');
                    disp(ep);
                    disp('Anlık Accuracy: ');
                    disp(acc./k);
                    disp('Loss: ');
                    disp(errors(end));
            end
        
    end %%Batch/Cluster   

    
ep = 1 + ep;
clear errors;
%[data, y] = karistir(data, y); %Veri Setini Karıştır
end %%


