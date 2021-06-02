function [rdata , ry] = hazirla(veriAdi)

%waitbar
f = waitbar(0,'Lütfen Bekleyiniz...');pause(1);

%Dataseti içeri aktar
waitbar(.20,f,'Veriler Okunuyor...');
    [~, ~, rawDataset] = xlsread(veriAdi);
    sinyal = rawDataset(2:end, 1799:end-1);
    veriset = cell2mat(sinyal);
    [uz, ~] = size(veriset);
%{
    for i = 1:uz
        veriset(i,:) = wden(veriset(i,:),'rigrsure','s','sln',1,'db4');
    end
%}
    veri = power(veriset,2); %Negatif değerlerin birbirini götürmemesi için kare alma
    veri = fillmissing(veri,'movmedian',10); %Boş olan verileri movmedian a göre doldurma ve ortalamayı koruma.
    [vUzunluk, ~] = size(veri);
    
waitbar(.33,f,'Veri Ön İşlemesi Yapılıyor...');
for k=1:vUzunluk
%Özellik çıkartma
    raw_sinyal = veri(k,:);
    for i=1:3
        X(k,(i-1)*256+1:i*256) = bbp(raw_sinyal);  %BBP ile 256 özellik çıktı
        [l,h] = dwt(raw_sinyal,'db4'); % sym4, bior2.8-3.3, db8, db4, coif2  (mexh?,meyer?)
        clear raw_sinyal;
        raw_sinyal=l;
    end
end

[~, X_genislik] = size(X);

%Max Min Normalizasyon
for i = 1:X_genislik 
  nVeri(:,i) = ((X(:,i) - min( X(:,i) ))  /  ((max(X(:,i)) - min(X(:,i))) + eps));
end

%Ezberlemek amele işidir.

%Nominal değerleri işlem yapabilmek için sayılarla etiketliyoruz.
tags = rawDataset(2:end, end);
for k=1:length(tags)
    tmp = tags(k,end);
    if "NEGATIVE" == tmp(1)
        y(k) = 1; 
    elseif "POSITIVE" == tmp(1)
        y(k) = 2;
    elseif "NEUTRAL" == tmp(1)
        y(k) = 3;
    end
end

%Yukarıda 5 * bbp den 1280 tane özellik sürunu çıkardık şimdi en iyi 256
%tanesini seçmek için relieff hesaplaması yapıyoruz.
[a, ~] = relieff(nVeri, y', 10);

%En iyi 256 özelliği çıkartıyoruz.
for i=1:256
    data(:,i) = nVeri(:,a(i));
end
sdata = [data, y'];
sdata = sortrows(sdata, length(sdata(end,:)));
rdata = sdata(:,1:end-1);
ry = sdata(:,end);

close(f);
end