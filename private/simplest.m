function inst = simplest_move(map,myPin,oppsPin,N)
% ��������Ĳ����� ÿ�ζ�����н�                 
persistent m n ARROUND
if N==1
    [m,n]=size(map);
    ARROUND=[-1,-m 1,m];%[��;��;��;��]
end

my_Position=sub2ind([m n],myPin(:,1),myPin(:,2));

directionPool=map(my_Position+ARROUND);%%[��;��;��;��]

[~,inst]=min(rand(1,4).*(directionPool+0.0001));


