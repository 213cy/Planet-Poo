function  survey(map,germsPosition,germsDirection,N,addition_info)
% 画图程序，画出行进轨迹
% MAP m x n matrix :
%      矩阵map内部的标记为0的点表示没有大便的安全区域，
%      标记为正整数的点表示存在大便的不安全区域，
%      其中标记为9的点天然存在的不安全区，
%      标记为1,2,3,...u<9的点为由第u个参赛生物创建的不安全区域
%
% germsPosition k x 2 matrix
%      第k行的第一个元素为第k个参赛生物当前所处的行标
%      第二个元素的为第k个参赛生物当前所处的列标
%       一共k个参数生物，所以germsPosition一共k行
%
% germsDirection k x 1 matrix of directions
%       第k个元素为第k个参赛生物当前的前进方向：
%       1：上，north      3：下，south
%       4：右，west       2：左，east
%
% N
%       比赛的当前步数
%
% slowflag
%    控制画图更新的速度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%survey(generatemap(0),[],[],1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent k T_xc T_yr texthandle
switch N
    case 0 %比赛开始前的初始化
        [m,n]=size(map);
        k=size(germsDirection,1);%参赛队数
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 初始化figure
        % DESCRIPTIVE TEXT
        clf
        padN=4;
        padPixel=600*padN/n;
        padNorma=padN/(padN+n);
        set(gcf,'DefaultPatchCDataMapping','direct',...
            'defaultpatchfacecolor','flat',...
            'Position',[100 100 600 600+padPixel], ...
            'numbertitle','off','Name','Oops!Poo!',...
            'Menu','none');%,'renderer','opengl'
        figure(gcf)
        
        % set the background image
        try
            a=dir('background/*.jpg');
            a=cellfun(@(s) ['background/',s],{a.name},'uni',0);
            a{end+1}='ngc6543a.jpg';
            picName=a{randi(length(a))};
            ground = imread( picName );
            image(ground(1:600,1:600,:))
        catch E
            warning(['Background picture: "' picName '" not found!']);
        end
        set(gca,...
            'units','normalized','position',[0 padNorma 1 1-padNorma],...
            'visible','off');
        axis equal
        % create a new axes to sit on top of the image
        newax=axes( 'units','normalized','position',[0 0 1 1],...
            'xlim',[0 m],'ylim',[0 n+padN],...
            'visible','off','DataAspectRatio',[1 1 1]);
        axis ij %equal
        
        % set some basic color.
        colormap([lines(7);...
            1 1 0;...
            0.4 0.4 0.3;...
            0 1 1]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 初始正方形patch对象
        % DESCRIPTIVE TEXT
        
        % *draw the invalid regions(square)*
        S_xc=[0 0 1 1]-1;%square_xdata_row
        S_yr=[0 1 1 0]-1;%square_ydata_column
        
        % *标记边框和障碍*
        [s_r,s_c]=find(map==9);
        for i=1:length(s_r)
            patch('xdata', S_xc+s_c(i), 'ydata', S_yr+s_r(i),'cdata',9);%
        end
        % *标记出生点*
        for i=1:k
            patch('xdata',S_xc+germsPosition(i,2),'ydata',S_yr+germsPosition(i,1),'cdata',8)
        end
        % 显示坐标
        text(0,1-0.5,'1','color','c')
        strX=5:5:n;
        text(strX-1,(strX>0)-0.5,cellfun(@num2str,num2cell(strX),'uni',0),'color','c')
        strY=5:5:m;
        text((strY>100)+0,strY-0.5,cellfun(@num2str,num2cell(strY),'uni',0),'color','c')
        
        %% 初始三角形patch对象
        % triangle
        xt=[1 0   1 1]-0.5;%尖端
        yt=[0 0.5 1 1]-0.5;%减去0.5,将中心移至原点
        T_xc=[[yt;xt;-yt;-xt]-0.5;...%减去0.5,将三角移至初始位置
            S_xc];%[上;左;下;右;停]
        T_yr=[[xt;yt;-xt;-yt]-0.5;...
            S_yr];%[上;左;下;右;停]
        
        %% 在图上写说明信息
        for i=1:k
            padX=n/2*rem(i-1,2);
            padPixel=1.5*(i>2);
            patch('xdata',T_xc(1,:)+2+padX,...
                'ydata',T_yr(1,:)+2+m+padPixel,...
                'cdata',i)
            texthandle(i)=text(padX+2.5,padPixel+m+1.5,...
                [': ',addition_info{i}],...
                'Interpreter','none');
        end
    case inf %比赛结束
        for i=1:k
            
            moveDirection=germsDirection(i);
            faceAlpha=1-0.3*(moveDirection==5);
            patch('xdata',T_xc(moveDirection,:)+germsPosition(i,2),...
                'ydata',T_yr(moveDirection,:)+germsPosition(i,1),...
                'cdata',i,'FaceAlpha',faceAlpha)
            if moveDirection<5
                clrmap=colormap;
                str=get(texthandle(i),'string');
                set(texthandle(i),...
                    'string',[str,'  win !!!'],...
                    'color',clrmap(i,:))
            else
                set(texthandle(i),'color',[0.6 0.6 0.6])
            end
        end
        if all(germsDirection>4)
            str=get(texthandle(k),'string');
            set(texthandle(k),'string',[str,'  draw'])
        end
        
    otherwise
        % *标记行进方向*
        for i=1:k
            moveDirection=germsDirection(i);
            patch('xdata',T_xc(moveDirection,:)+germsPosition(i,2),...
                'ydata',T_yr(moveDirection,:)+germsPosition(i,1),...
                'cdata',i)
        end
end
if exist('slowflag','var')||1
    %pause(0.1)
    drawnow
end





