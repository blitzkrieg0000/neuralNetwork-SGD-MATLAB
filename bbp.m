function H = bbp(sinyal)

H = zeros(1,256);
for i=1:length(sinyal)-8
    ys(i)=0;
    blok=sinyal(i:i+8);
    say=1;
    for j=1:9
        if j~=5
            ys(i) = ys(i) + (blok(j)>blok(5))*(2^(8-say));
            say=say+1;
        end
    end
    H(ys(i)+1) = H(ys(i)+1)+1;
end
end