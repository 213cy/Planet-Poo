function  survey(map,germsPosition,germsDirection,N,addition_info)
% ��ͼ���򣬻����н��켣
% MAP m x n matrix :
%      ����map�ڲ��ı��Ϊ0�ĵ��ʾû�д��İ�ȫ����
%      ���Ϊ�������ĵ��ʾ���ڴ��Ĳ���ȫ����
%      ���б��Ϊ9�ĵ���Ȼ���ڵĲ���ȫ����
%      ���Ϊ1,2,3,...u<9�ĵ�Ϊ�ɵ�u���������ﴴ���Ĳ���ȫ����
%
% germsPosition k x 2 matrix
%      ��k�еĵ�һ��Ԫ��Ϊ��k���������ﵱǰ�������б�
%      �ڶ���Ԫ�ص�Ϊ��k���������ﵱǰ�������б�
%       һ��k�������������germsPositionһ��k��
%
% germsDirection k x 1 matrix of directions
%       ��k��Ԫ��Ϊ��k���������ﵱǰ��ǰ������
%       1���ϣ�north      3���£�south
%       4���ң�west       2����east
%
% N
%       �����ĵ�ǰ����
%
% slowflag
%    ���ƻ�ͼ���µ��ٶ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%survey(generatemap(0),[],[],1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent k T_xc T_yr texthandle
switch N
    case 0 %������ʼǰ�ĳ�ʼ��
        [m,n]=size(map);
        k=size(germsDirection,1);%��������
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% ��ʼ��figure
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
        %% ��ʼ������patch����
        % DESCRIPTIVE TEXT
        
        % *draw the invalid regions(square)*
        S_xc=[0 0 1 1]-1;%square_xdata_row
        S_yr=[0 1 1 0]-1;%square_ydata_column
        
        % *��Ǳ߿���ϰ�*
        [s_r,s_c]=find(map==9);
        for i=1:length(s_r)
            patch('xdata', S_xc+s_c(i), 'ydata', S_yr+s_r(i),'cdata',9);%
        end
        % *��ǳ�����*
        for i=1:k
            patch('xdata',S_xc+germsPosition(i,2),'ydata',S_yr+germsPosition(i,1),'cdata',8)
        end
        % ��ʾ����
        text(0,1-0.5,'1','color','c')
        strX=5:5:n;
        text(strX-1,(strX>0)-0.5,cellfun(@num2str,num2cell(strX),'uni',0),'color','c')
        strY=5:5:m;
        text((strY>100)+0,strY-0.5,cellfun(@num2str,num2cell(strY),'uni',0),'color','c')
        
        %% ��ʼ������patch����
        % triangle
        xt=[1 0   1 1]-0.5;%���
        yt=[0 0.5 1 1]-0.5;%��ȥ0.5,����������ԭ��
        T_xc=[[yt;xt;-yt;-xt]-0.5;...%��ȥ0.5,������������ʼλ��
            S_xc];%[��;��;��;��;ͣ]
        T_yr=[[xt;yt;-xt;-yt]-0.5;...
            S_yr];%[��;��;��;��;ͣ]
        
        %% ��ͼ��д˵����Ϣ
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
    case inf %��������
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
        % *����н�����*
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





