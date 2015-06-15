%% DOCUMENT TITLE
% INTRODUCTORY TEXT
function inst = yieldingmove(map,myPin,oppsPin,N)
% ��������Ĳ����� ��ͣ�������
persistent myOldDirection myTurnState TURNTABLE
persistent m n ARROUND

if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[��;��;��;��]
    myOldDirection=randi(4);%1--�� 2--�� 3--�� 4--��
    myTurnState=randi([1,2]);
    TURNTABLE={[4 1 2 3;1 2 3 4;2 3 4 1;3 4 1 2];
        [2 1 4 3;3 2 1 4;4 3 2 1;1 4 3 2]};
end

opps_Position=sub2ind([m n],oppsPin(:,1),oppsPin(:,2));
my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));

%���˿�������һ������ĵط�����ϸ�Σ��Ȩ��(������ȥ)
map(opps_Position+ARROUND)=map(opps_Position+ARROUND)+0.01;

directionPool=map(my_Position+ARROUND);%%[��;��;��;��]
tmp=find(directionPool==0);
switch length(tmp)
    case 0
        [~,inst]=min(rand(1,4).*(directionPool));
        myOldDirection=inst;
    case 1
        inst=tmp;
        myOldDirection=inst;
        myTurnState=randi([1,2]);
    otherwise
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