function inst = hardwork(map,myPin,oppsPin,N)
% XXXXXXXXXXXXXXXX

persistent m n ARROUND
persistent apartMode fromCorner
persistent myOldDirection myTurnState TURNTABLE

if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[上;左;下;右]
    apartMode='combin';
    fromCorner=0;
    
    myTurnState=randi([1,2]);
    TURNTABLE={[4 1 2 3;1 2 3 4;2 3 4 1;3 4 1 2];
        [2 1 4 3;3 2 1 4;4 3 2 1;1 4 3 2]};
end

my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));
opps_Position=sub2ind([m n],oppsPin(:,1),oppsPin(:,2));
myArround=my_Position+ARROUND;
oppArround=opps_Position+ARROUND;

directionPool=map(myArround);%%[上;左;下;右]
tmp=find(directionPool==0);

switch apartMode
    case 'combin'
        %% %%%%%%%%%%% case 'combin' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch length(tmp)
            case 0 %死了
                inst=randi([1,4]);
            case 1
                inst=tmp;
                mapBW=map<0.5;
                mapBW(opps_Position)=true;
                oppDist=bwdistgeodesic(mapBW,opps_Position,'cityblock');
                if isinf(oppDist(myArround(tmp)))
                    apartMode='apart';
                    myOldDirection=inst;
                end
            otherwise
                %% 对可行指令进行评价
                %初始化未被污染的区域 mapBW (1表示未被污染)
                mapBW=map<0.5;
                mapBW(opps_Position)=true;
                
                oppDist=bwdistgeodesic(mapBW,opps_Position,'cityblock');
                
                % 为每个可行前进方向打分dirctionScore
                directionScore=-inf(1,4);
                % 顺便搜集分割信息apartFlag
                apartFlag=zeros(1,4);
                for k=tmp
                    myDist=bwdistgeodesic(mapBW,myArround(k),'cityblock');
                    
                    if isinf(oppDist(myArround(k)))
                        %如果敌我两个生物分处两个不连通的区域
                        directionScore(k)=nnz(~isnan(myDist))-nnz(~isnan(oppDist));
                        apartFlag(k)=1;
                    else
                        %如果区域敌我两个生物所在区域连通
                        directionScore(k)=nnz(myDist<oppDist)-nnz(oppDist<myDist);
                    end
                end
                
                %% 确定指令
                % 标记存在相撞风险的指令方向
                intersectFlag = ismember(myArround,oppArround);
                % 首先寻找得分为正且不存在相撞风险的指令方向(最优选择)
                indMask=directionScore>0 & ~intersectFlag;
                [~,inst]=max(directionScore.*indMask);
                % 找不到则在不考虑是否相撞的情况下,选择最优方向(次优选择)
                if isempty(inst)
                    [~,inst]=max(directionScore);
                end
                
                %% 检测是否进入分割模式
                if apartFlag(inst)==1
                    apartMode='apart';
                    myOldDirection=inst;
                    disp('apartMode!')
                end
                %debug display
                % %                     disp('-----------------')
                % %                     disp( N )
                % %                     disp( directionScore )
                % %                     disp( inst )
                
        end
        
    case 'apart'
        %% %%%%%%%%%%% case 'apart' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %disp('apart')
        switch length(tmp)
            case 0 %死了
                inst=randi([1,4]);
            case 1
                inst=tmp;
                myOldDirection=inst;
                formCorner=1;
            case 2
                if formCorner
                    tmpCol=map(:,myPin(2));
                    tmpRom=map(myPin(1),:)
                    formCorner=0;
                    
                else
                    aaa
                end
            case 3
                
        end
        
        [~,inst]=min(directionPool);
        
end

function aaa
    table=TURNTABLE{myTurnState}(myOldDirection,:);
    if directionPool(table(1))==0;
        %能转就转
        inst=table(1);
        myOldDirection=inst;
    elseif directionPool(table(2))==0;
        %直走
        inst=table(2);
        %myOldDirection=table(2);
    else %directionPool(table(3))==0;
        %向另外的方向转
        inst=table(3);
        myOldDirection=inst;
        myTurnState=randi([1,2]);
    end
end
return
%%
figure
subplot(221)
imshow(watershedLine)
subplot(222)
imshow(mapBW+watershedLine,[])
subplot(223)
imshow(myDist,[])
subplot(224)
imshow(oppDist,[])





