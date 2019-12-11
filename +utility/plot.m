function [ l] = plot(x, y, y_legends, xLab, yLab, xScale, yScale)
    if nargin < 6
        xScale = 'linear';
    end
    
    if nargin < 7
        yScale = 'linear';
    end
    
    %f = figure();
    
    % Make column vector
    if isvector(y)
        y = reshape(y, length(y), 1);
    end
    
    n_y = size(y, 2);
    
%     markers = {'o', 's', 'd', '^', 'v', '<', '>'};
    
    markers = {'*', '+', 'o', '^', 'x', '<', '>'};
    
    assert(length(markers) >= n_y );
   
    for i = 1: n_y
        ydata = y(:, i);
        
        if iscell(ydata)
            ydata = cell2mat(ydata);
        end
        
        ydata = ydata + eps;
        
        scatter(x, ydata, markers{i}, 'MarkerEdgeColor', 'k');
        hold on;
    end
    
    % Reference line plot 
    y=zeros(1,146);% y values for straight line
    x=0:145;% y values for straight line
    plot(x,y,'--','HandleVisibility','off');
    
    hold off;
    
    if ~ isempty(y_legends)
        l = legend(y_legends{:});
    else
        l = [];
    end

   % xlabel(xLab);
     ylabel(yLab,'FontSize', 20,'color','k'); %ylabel for right y axis

   set(gca, 'XScale', xScale);
   set(gca, 'YScale', yScale);

end
