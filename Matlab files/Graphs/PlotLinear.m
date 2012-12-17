function [ slope, intercept ] = PlotLinear(name, xTitle, yTitle, xUnits, yUnits, x, y, xErrs, yErrs)
%PLOTLINEAR Summary of this function goes here
%   Detailed explanation goes here

    title(name)
    xlabel(sprintf('%s [%s]', xTitle, xUnits));
    ylabel(sprintf('%s [%s]', yTitle, yUnits));
    
    % Find fit
    p = polyfit(x, y, 1);
    slope = p(1);
    intercept = p(2);
    f = polyval(p, x);
    
    % Start plotting
    hold on;
    %figure();
    set(gca, 'color', [1 1 1]);
    plot(x, y, 'o', x, f, '-');
    
    % Add error bars
    herrorbar(x, y, xErrs);
    errorbar(x, y, yErrs, 'xb');
    hold off;
end

