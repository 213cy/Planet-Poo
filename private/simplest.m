function inst = simplest_move(map,myPin,oppsPin,N)
% 这个函数的策略是 每次都随机行进                 
persistent m n ARROUND
if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[上;左;下;右]
end

my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));

directionPool=map(my_Position+ARROUND);%%[上;左;右;下]

[~,inst]=min(rand(1,4).*(directionPool+0.0001));


