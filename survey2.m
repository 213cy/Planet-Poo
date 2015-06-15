function  survey2(mapNum,germDir,varargin)
%SURVEY2(map,initialstate,instructions)
%SURVEY2(map,initialstate,instructions,slow)
%
% SLOW
%    If the fourth argument is specified as 1, then the plotting is
%    delayed so that it is easier to visualize the results.  Default
%    value is 0, undelayed visualization.
%

if nargin==3
    slow=varargin{1};
else
    slow=0;
end


map=generatemap(mapNum);

mat2x1=zeros(2,1);
initRow=mat2x1;
initCol=mat2x1;
[initRow(1),initCol(1)]=find(map==11);
[initRow(2),initCol(2)]=find(map==22);

[numberofgerms, numberofstep] = size(germDir);


rowAdd=[-1 0 1 0];
colAdd=[0 -1 0 1];

germRows = bsxfun(@plus,initRow,cumsum(rowAdd(germDir),2));
germRows =[initRow germRows+randn(numberofgerms,numberofstep)/20];

germCols = bsxfun(@plus,initCol,cumsum(colAdd(germDir),2));
germCols = [initCol germCols+randn(numberofgerms,numberofstep)/20];

% Visualization
% =======================================================
clf;
figure(gcf)
set(gcf,'Name','simple path graph');
axes('visible','off','position',[0 0 1 1]);%'xlim',[-5 55],'ylim',[-5 55]);
axis ij
axis equal

% Draw the invalid regions
[invalidRow,invalidCol]=find(map==9);

for n=1:length(invalidRow),
    patch(invalidCol(n)+[-.5 .5 .5 -.5 -.5],...
        invalidRow(n)+[-.5 -.5 .5 .5 -.5],...
        'k');
end

% 初始化绘制对象
germColor=lines(7);
for n=1:numberofgerms
    % First the tail that doesn't move
    tail(n)=line(germCols(n,1),germRows(n,1), ...
        'LineStyle','-', ...
        'Color',germColor(n,:), ...
        'ButtonDownFcn',@cback);
    squiggle(n) = line(germCols(n,1),germRows(n,1), ...
        'LineStyle','none', ...
        'Marker','.','MarkerSize',20, ...
        'Color',germColor(n,:), ...
        'ButtonDownFcn',@cback );
    head(n)=line(germCols(n,1),germRows(n,1), ...
        'LineStyle','none', ...
        'Marker','^','MarkerSize',8, ...
        'MarkerFaceColor',germColor(n,:), ...
        'MarkerEdgeColor','black', ...
        'ButtonDownFcn',@cback);
end

% Visualize all germs moving simultaneously
markers='^<v>';
for t=2:numberofstep
    drawnow
    for n=1:numberofgerms
        set(head(n),'XData',germCols(n,t),'YData',germRows(n,t), ...
            'Marker',markers(germDir(n,t)))
        set(tail(n),'XData',germCols(n,1:t),'YData',germRows(n,1:t))
        
        if rem(t,4)==0
            line(germCols(n,t-1),germRows(n,t-1), ...
                'LineStyle','none', ...
                'Marker',markers(germDir(n,t-1)),'MarkerSize',5, ...
                'MarkerFaceColor',germColor(n,:), ...
                'MarkerEdgeColor','none');
        end
        
    end
    if slow
        pause(slow)
    end
end

for n=1:numberofgerms
    set([tail(n) head(n) squiggle(n)],'UserData',tail(n));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  cback(src,evt)
hh=get(gcbo,'userdata');
ss=get(hh,'visible');
if strcmp(ss,'on')
    set(hh,'visible','off')
else
    set(hh,'visible','on')
end


