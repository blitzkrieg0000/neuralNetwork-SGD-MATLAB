function [out, no]  = aktivasyon(A , fonksiyonAd)

switch fonksiyonAd
    case 'sigmoid'
            %Sigmoid
            X = sum(A)';
            out = 1./((1+ exp(-X)));
            no = exp(-X) ./ power(1+exp(-X),2);  %Net e göre Türev, küçük sapmalar var
            %no = out.*(1-out);                  %Out a göre Türev
     
    case 'relu'
            %Rectified Linear Unit
            X = sum(A)';
            out = max(0, X);
            no = ones(size(X));
                no(X<0) = 0;
                no(X>=0) = 1;  
            
    case 'lRelu'
            %Leaky Rectified Linear Unit
            X = sum(A)';
                alpha = 0.03;
            out = max(alpha.*X, X);
            no = ones(size(X));
                no(X<0) = alpha;
                no(X>=0) = 1;  

    case 'tanh'
            %Hiperbolik Tanjant
            X = sum(A)';
            out = (exp(X) - exp(-X)) ./ (exp(X) + exp(-X));
            no = 1 - power(out,2);
   
    case 'swish'
            %Swish
            X = sum(A)';
            out = X./(1+exp(-X));
            no = ((exp(-X).*(X+1)) + 1) ./ power((1 + exp(-X)),2); %Düzenlenmiş hali
    
    case 'softmax'
            X = sum(A)';
            out = softmax(X);
            no = ones(numel(X),1);
            
    otherwise
        disp('Beklenmeyen Giriş');
end


end