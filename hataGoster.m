function hataGoster(A,ep,k)
if(mod(ep,2) == 0)
   renk='-r';
else
   renk='-b';
end
                    
plot(A, renk, 'LineWidth', 1, 'MarkerSize', 9, 'MarkerEdgeColor', 'g'),
ylim([min(A)-0.01 max(A)+0.01]),
    title({
           'Error/iterasyon: ' A(end),...
           'Epoch: ' ep...
           'Veri: ' ,k
           }),
end




