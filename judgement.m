function [win,instructions]=judgement(mapNum,drawflag)
%% DOCUMENT TITLE
% mapNum   ��ѡ��ͼ ȡֵ 1��8
% drawflag �����Ƿ�ͼ,ȡֵ0��1
%% ��ʼ��
% ��ʼ���������
switch nargin
    case 0 
        mapNum=1;
        drawflag=1;
    case 1
        drawflag=1;
end
% ��ʼ����ͼ
map=generatemap(mapNum);
[x1_old,y1_old]=find(map==11);
[x2_old,y2_old]=find(map==22);

% ׼���������ƺ���
files=what('private');
entrys=[files.m(1:2);'none(draw)'];
entry1=eval(['@',entrys{1}(1:end-2)]);
entry2=eval(['@',entrys{2}(1:end-2)]);
% ��ʼ����ͼ����
N=0;
if drawflag
    survey(map,[x1_old,y1_old;x2_old,y2_old],[nan;nan],N,entrys);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��������
% DESCRIPTIVE TEXT
winner=-1;
instructions=zeros(2,500);
while winner<0
    N=N+1;
    % *���µ�ͼ*
    map(x1_old,y1_old)=1;
    map(x2_old,y2_old)=2;
    
    % *������һ����λ��*
    nextp1 = entry1(map,[x1_old,y1_old],[x2_old,y2_old],N);
    [x1,y1]=move2ind(nextp1,x1_old,y1_old);
    nextp2 = entry2(map,[x2_old,y2_old],[x1_old,y1_old],N);
    [x2,y2]=move2ind(nextp2,x2_old,y2_old);
    instructions(:,N)=[nextp1;nextp2];

    % *���ӻ���ͼ*
    
    if drawflag
        %   visualize and validate the results
        survey(map,[x1_old,y1_old;x2_old,y2_old],[nextp1;nextp2],N);
    end
    % *�������*
    switch true
        case {x1==x2&&y1==y2}%ͬʱ̤��ͬһ����
            winner=3;
            nextp1=5;nextp2=5;
        case {map(x1,y1)>0&&map(x2,y2)>0}%ͬʱײǽ
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
% �������Ϣд�봰��
if drawflag
    % visualize and validate the results
    survey(map,[x1,y1;x2,y2],[nextp1;nextp2],inf);%,winner
    drawnow
end
% ��command window������
instructions(:,N+1:end)=[];
win=entrys{winner};
disp(['winner entry:   ',win])
beep

function [x,y]=move2ind(nextp,x_old,y_old)
x=x_old;y=y_old;
switch nextp
    case 1 %�����ƶ�
        x=x_old-1;
    case 2 %�����ƶ�
        y=y_old-1;
    case 3 %�����ƶ�
        x=x_old+1;
    case 4 %�����ƶ�
        y=y_old+1;
    otherwise
        error('���ƺ��������ָ��ֻ����: 1 2 3 4')
end

