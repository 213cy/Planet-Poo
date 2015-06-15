
function map=generatemap(k,showmapflag)
%% 地图生成器
% 第一个参数可以是1到8的任意一个数字,用来选择地图
% 第二个参数要求程序绘制选择的那个地图
%
a=30;
tmp=zeros(a);
tmp([1 end],:)=9;
tmp(:,[1 end])=9;
switch k
    case 0
        %% 标准对抗地图
        tmp(a/2,1+ceil(a/4))=11;
        tmp(a/2,a-ceil(a/4))=22;
        
    case 1
        %% 标准对抗地图(随机出生地点)
        p=randi([2,a-1],2,2);
        while p(1)==p(2)&&p(3)==p(4)
            p=randi([2,a-1],2,2);
        end
        tmp(p(1),p(3))=11;
        tmp(p(2),p(4))=22;
        
    case 2
        % L-shaped lawn
        ap=ceil(a/2)+1;
        tmp(1:ap,ap:a)=9;
        
        p=ceil(a/4);
        tmp(1+p,1+p)=11;
        tmp(a-p,a-p)=22;
        
    case 3
        % the lake
        [x,y]=meshgrid(linspace(-1,1,a));
        tm=(x.^2+y.^2)<0.2;
        tmp(tm)=9;
        
        p=ceil(a/6);
        tmp(1+p,1+p)=11;
        tmp(a-p,a-p)=22;
        
    case 4
        % Death trap
        [x,y]=meshgrid(linspace(-1,1,a));
        tm=(x.^2+y.^2)>0.9;
        tmp(tm)=9;
        
        p=ceil(a/4);
        tmp(1+p,1+p)=11;
        tmp(a-p,a-p)=22;
        
    case 5
        % the +
        ap=floor(a/2);
        ab=floor(a/4);
        tmp(ab:ap,ap)=9;
        tmp(ap,a-ap+1:a+1-ab)=9;
        tmp(a-ap+1:a+1-ab,a-ap+1)=9;
        tmp(a-ap+1,ab:ap)=9;
        
        p=ceil(a/4);
        tmp(1+p,1+p)=11;
        tmp(a-p,a-p)=22;
        
    case 6
        % the comb
        ap=floor(2*a/3);
        ab=floor(a/5);
        tmp(1:ap,[ab 2*ab a+1-ab a+1-2*ab])=9;
        
        tmp(2,2)=11;
        tmp(2,a-1)=22;
    case 7
        % the concentric
        ap=ceil(a/5);
        ab=2*ap;
        tmp(ap:a+1-ap,ap)=9;
        tmp(ap:a+1-ap,a+1-ap)=9;
        tmp(ap,ap:a+1-ap)=9;
        
        tmp(ab:a+1-ab,ab)=9;
        tmp(ab:a+1-ab,a+1-ab)=9;
        tmp(a+1-ab,ab:a+1-ab)=9;
        
        p=ceil(a/6);
        tmp(2*p,p)=11;
        tmp(2*p,a-p+1)=22;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    otherwise
        % magical
        tm=(magic(a)+fliplr(magic(a)))<600;
        tmp(tm)=9;
        
        I=find(tmp<1);
        p=randperm(length(I),2);
        tmp(I(p(1)))=11;
        tmp(I(p(2)))=22;
end
map=tmp;
%% 地图显示
% DESCRIPTIVE TEXT
if exist('showmapflag','var')
    imagesc(map)
    axis equal
    figure(gcf)
end



