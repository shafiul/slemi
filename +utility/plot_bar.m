function [f] = plot_bar(x, y, y_legends,xLab, yLab, xScale, yScale)
    % y can be a vector or matrix
    [sorted_blks_sz, row_ids] =  sort(x);% get the row id while sorting based on number of blocks /models 
    y = y(row_ids,:); % sorted y based on number of blocks per model
    %y_1= y_1(row_ids,:);% sorted y based on number of blocks per model (Avg Mutation)
    if nargin < 8 %nargin is number of input arguments of function
        xScale = 'linear';
    end
    
    if nargin < 9
        yScale = 'linear';
    end
    
    f = figure();
   
    %setting y axis tick label black 
    left_color = [0 0 0];
    right_color = [0 0 0];
    set(f,'defaultAxesColorOrder',[left_color; right_color]);
    set(f,'DefaultAxesFontSize',20)
    % Make column vector
    if isvector(y)
        y = reshape(y, length(y), 1);
    end
    yyaxis left;
    H=bar(y,'stacked','BarWidth',0.5);
    %shades of gray
    nshades = 2500;% multiple of 5 such that we get 6 interval
    %get different shades of gray of each section of stacked bar 
    colorset=gray(nshades);
      H(1).FaceColor = 'flat';
   H(2).FaceColor = 'flat';

     H(3).FaceColor = 'flat';

     H(4).FaceColor = 'flat';

     H(5).FaceColor = 'flat';
     H(6).FaceColor = 'flat';

      %}
     H(1).CData = [0.2999    0.2999    0.2999]; %Run Seed Black
     H(2).CData =  [0.5255    0.5255   0.5255];% Coverage 
     H(3).CData =  [0.9000    0.9000    0.9000] ; % DataType 
     H(4).CData =  [0 0 0]; %Mutant Gen 
     H(5).CData = [ 0.7500    0.7500    0.7500]; %Run Mutant
     H(6).CData =  [1 1 1];%white for  Diff.test
 
 
 
    hold on; 
    box off;
    %xlabel(xLab);
     
    
    ylabel(yLab,'FontSize', 22,'color','k');
    set(gca, 'XScale', xScale);
    set(gca, 'YScale', yScale); 

end
