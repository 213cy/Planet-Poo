%% DOCUMENT TITLE
% INTRODUCTORY TEXT
function inst = rigidmove(map,myPin,oppsPin,N)
% 这个函数的策略是 能直走尽量直走
% 不能直走,就随机选择一个可行的方向继续直走                 
persistent myOldDirection 
persistent m n ARROUND
if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[上;左;下;右]
    myOldDirection=randi(4);%1--上 2--左 3--下 4--右
end

opps_Position=sub2ind([m n],oppsPin(:,1),oppsPin(:,2));
my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));
%敌人可以在下一步到达的地方赋予较高危险权重(尽量不去)
map(opps_Position+ARROUND)=map(opps_Position+ARROUND)+0.01;

directionPool=map(my_Position+ARROUND);%%[上;左;右;下]
if directionPool(myOldDirection)==0;
    inst=myOldDirection; %能直走就直走
else
    [~,inst]=min(rand(1,4).*(directionPool+0.0001));
    myOldDirection=inst;
end

