function [win,instructions]=judgement(mapNum,drawflag)
%% DOCUMENT TITLE
% mapNum   挑选地图 取值 1到8
% drawflag 控制是否画图,取值0或1
%% 初始化
% 初始化输入参数
switch nargin
    case 0 
        mapNum=1;
        drawflag=1;
    case 1
        drawflag=1;
end
% 初始化地图
map=generatemap(mapNum);
[x1_old,y1_old]=find(map==11);
[x2_old,y2_old]=find(map==22);

% 准备参赛控制函数
files=what('private');
entrys=[files.m(1:2);'none(draw)'];
entry1=eval(['@',entrys{1}(1:end-2)]);
entry2=eval(['@',entrys{2}(1:end-2)]);
% 初始化绘图窗口
N=0;
if drawflag
    survey(map,[x1_old,y1_old;x2_old,y2_old],[nan;nan],N,entrys);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 生长过程
% DESCRIPTIVE TEXT
winner=-1;
instructions=zeros(2,500);
while winner<0
    N=N+1;
    % *更新地图*
    map(x1_old,y1_old)=1;
    map(x2_old,y2_old)=2;
    
    % *计算下一步的位置*
    nextp1 = entry1(map,[x1_old,y1_old],[x2_old,y2_old],N);
    [x1,y1]=move2ind(nextp1,x1_old,y1_old);
    nextp2 = entry2(map,[x2_old,y2_old],[x1_old,y1_old],N);
    [x2,y2]=move2ind(nextp2,x2_old,y2_old);
    instructions(:,N)=[nextp1;nextp2];

    % *可视化绘图*
    
    if drawflag
        %   visualize and validate the results
        survey(map,[x1_old,y1_old;x2_old,y2_old],[nextp1;nextp2],N);
    end
    % *死亡检测*
    switch true
        case {x1==x2&&y1==y2}%同时踏入同一区域
            winner=3;
            nextp1=5;nextp2=5;
        case {map(x1,y1)>0&&map(x2,y2)>0}%同时撞墙
            winner=3;
            x1=x1_old;y1=y1_old;
            x2=x2_old;y2=y2_old;
            nextp1=5;nextp2=5;
        case {map(x1,y1)>0&&map(x2,y2)==0}
            winner=2;
            x1=x1_old;y1=y1_old;
            nextp1=5;
        case {map(x1,y1)==0&&map(x2,y2)>0}
            winner=1;
            x2=x2_old;y2=y2_old;
            nextp2=5;
        otherwise
            x1_old=x1;y1_old=y1;
            x2_old=x2;y2_old=y2;
    end
end
% 将结果信息写入窗口
if drawflag
    % visualize and validate the results
    survey(map,[x1,y1;x2,y2],[nextp1;nextp2],inf);%,winner
    drawnow
end
% 在command window输出结果
instructions(:,N+1:end)=[];
win=entrys{winner};
disp(['winner entry:   ',win])
beep

function [x,y]=move2ind(nextp,x_old,y_old)
x=x_old;y=y_old;
switch nextp
    case 1 %向上移动
        x=x_old-1;
    case 2 %向左移动
        y=y_old-1;
    case 3 %向下移动
        x=x_old+1;
    case 4 %向右移动
        y=y_old+1;
    otherwise
        error('控制函数的输出指令只能是: 1 2 3 4')
end

