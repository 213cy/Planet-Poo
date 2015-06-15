%% DOCUMENT TITLE
% INTRODUCTORY TEXT
function inst = rigidmove(map,myPin,oppsPin,N)
% ��������Ĳ����� ��ֱ�߾���ֱ��
% ����ֱ��,�����ѡ��һ�����еķ������ֱ��                 
persistent myOldDirection 
persistent m n ARROUND
if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[��;��;��;��]
    myOldDirection=randi(4);%1--�� 2--�� 3--�� 4--��
end

opps_Position=sub2ind([m n],oppsPin(:,1),oppsPin(:,2));
my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));
%���˿�������һ������ĵط�����ϸ�Σ��Ȩ��(������ȥ)
map(opps_Position+ARROUND)=map(opps_Position+ARROUND)+0.01;

directionPool=map(my_Position+ARROUND);%%[��;��;��;��]
if directionPool(myOldDirection)==0;
    inst=myOldDirection; %��ֱ�߾�ֱ��
else
    [~,inst]=min(rand(1,4).*(directionPool+0.0001));
    myOldDirection=inst;
end

