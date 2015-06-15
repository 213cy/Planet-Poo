function inst = hardwork(map,myPin,oppsPin,N)
% XXXXXXXXXXXXXXXX

persistent m n ARROUND
persistent apartMode fromCorner
persistent myOldDirection myTurnState TURNTABLE

if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[��;��;��;��]
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

directionPool=map(myArround);%%[��;��;��;��]
tmp=find(directionPool==0);

switch apartMode
    case 'combin'
        %% %%%%%%%%%%% case 'combin' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch length(tmp)
            case 0 %����
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
                %% �Կ���ָ���������
                %��ʼ��δ����Ⱦ������ mapBW (1��ʾδ����Ⱦ)
                mapBW=map<0.5;
                mapBW(opps_Position)=true;
                
                oppDist=bwdistgeodesic(mapBW,opps_Position,'cityblock');
                
                % Ϊÿ������ǰ��������dirctionScore
                directionScore=-inf(1,4);
                % ˳���Ѽ��ָ���ϢapartFlag
                apartFlag=zeros(1,4);
                for k=tmp
                    myDist=bwdistgeodesic(mapBW,myArround(k),'cityblock');
                    
                    if isinf(oppDist(myArround(k)))
                        %���������������ִ���������ͨ������
                        directionScore(k)=nnz(~isnan(myDist))-nnz(~isnan(oppDist));
                        apartFlag(k)=1;
                    else
                        %����������������������������ͨ
                        directionScore(k)=nnz(myDist<oppDist)-nnz(oppDist<myDist);
                    end
                end
                
                %% ȷ��ָ��
                % ��Ǵ�����ײ���յ�ָ���
                intersectFlag = ismember(myArround,oppArround);
                % ����Ѱ�ҵ÷�Ϊ���Ҳ�������ײ���յ�ָ���(����ѡ��)
                indMask=directionScore>0 & ~intersectFlag;
                [~,inst]=max(directionScore.*indMask);
                % �Ҳ������ڲ������Ƿ���ײ�������,ѡ�����ŷ���(����ѡ��)
                if isempty(inst)
                    [~,inst]=max(directionScore);
                end
                
                %% ����Ƿ����ָ�ģʽ
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
            case 0 %����
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
        %��ת��ת
        inst=table(1);
        myOldDirection=inst;
    elseif directionPool(table(2))==0;
        %ֱ��
        inst=table(2);
        %myOldDirection=table(2);
    else %directionPool(table(3))==0;
        %������ķ���ת
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





