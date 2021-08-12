function nnCiz(Y)
clc,close all

    X = ones(1,length(Y))';
    rad = ones(1,length(Y));
    merkez = [X Y];
    
    cla,
    xlim([-10 10])
    ylim([-10 10])
    axis square
    
    viscircles(merkez, rad,'Color','b');    
    hold on
    
    plot(X,Y, '-r', 'LineWidth', 1, 'MarkerSize', 8, 'MarkerEdgeColor','b')
    text(X,Y,num2str(1))
    hold on
end