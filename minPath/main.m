function main

%testing matrix M
global M
% M=[0 0 1 1 2 3 4;
%    1 0 1 2 4 5 3;
%    3 3 10 3 4 2 6;
%    5 6 7 30 0 1 1];
% M=score_mat;
%find path going rightward/downward and with min val 
load result_l_30_camera1_1_camera1_2
M=score_mat;

global minVal
minVal=10e10;

global minPath3_count
minPath3_count=0;

path=minPath4(M);
path


path_vis=zeros(size(M));
for i=1:size(path,1)
    x=path(i,1);
    y=path(i,2);
    path_vis(x,y)=1;
end

figure
imagesc(path_vis)

end



function  path=minPath4(M)
num=3;
P=[];
for i=1:size(M,1)
    
    [V,I]=sort(M(i,:));
    
    a=I(1:num);
    app=[ones(num,1)*i a'];
    P=[P;app];
    
end
    



path_vis=zeros(size(M));
for i=1:size(P,1)
    x=P(i,1);
    y=P(i,2);
    path_vis(x,y)=1/M(x,y);
end

figure
imagesc(path_vis)



end

%recursive solution
function path=minPath3(M)


n=size(M,1);
m=size(M,2);

global targetLen
targetLen=min(n,m);

a=1;b=1;
Q=getQ(M,a,b);
[path,val]=minPath3R(M,a,b,0,Q,0);

path
val

end

%recursively get path with min val, in M(a:end,b:end) starting (a,b);
function [path,val]=minPath3R(M,a,b,len,Q,currVal)
global minVal
global minPath3_count

global targetLen

path=[];
val=0;

if len==targetLen
    minPath3_count=minPath3_count+1;
    minPath3_count
    
    
    if currVal<minVal
        minVal=currVal;
        minVal
    end
    
    return;
end

if currVal>minVal
    currVal
    minVal
    return;
end

ia=Q(:,1)<a;
ib=Q(:,2)<b;
I=ia | ib;
Q(I,:)=[];

if isempty(Q)
    Q=getQ(M,a,b);
end
numQ=size(Q,1);
path1s={};
vals=zeros(numQ,1);
for i=1:size(Q,1)
    
    x=Q(i,1);
    y=Q(i,2);
    M1=M(x:end,y:end);

    Qtemp=Q;
    Qtemp(i,:)=[];
    
    [path1, val]=minPath3R(M,x,y,len+1,Qtemp,currVal+M(x,y));
    path1s{end+1}=path1;
    vals(i)=val+M(x,y);
    
end


[v,i]=min(vals);
path=[Q(i,:); path1s{i}];
val=v;

end

%get queue of values to explore (sorted)
function Q=getQ(M,a0,b0)

    sets=unique(M);
    [a,b]=find(M==sets(1));
    %remove indices where < a0,b0
    ia=a<a0;
    ib=b<b0;
    I=ia | ib;
    a(I)=[];
    b(I)=[];
    
    [n,m]=size(M);
    numUBounds=max(length(a),min(n-a0,m-b0));
    Q=[];
    for i=1:length(sets)
        [a,b]=find(M==sets(i));
        [a,b]=sortByRank(M,[a b]);
        append=[a b ones(size(a,1),1)*sets(i)];
        Q=[Q;append];
        if length(Q)>numUBounds
            break;
        end
    end
end

%sort indices (a,b) by rank - defined as the area(M)-area(square ahead)
function [a,b]=sortByRank(M,ab)
    n=size(M,1);
    m=size(M,2);
    ranks=zeros(size(ab,1),1);
    for i=1:size(ab,1)
        x=ab(i,1);
        y=ab(i,2);
        ranks(i)=n*m-(n-x)*(m-y);
    end
    
    [v,I]=sort(ranks);
    
    a=zeros(size(ab,1),1);b=zeros(size(ab,1),1);
    for i=1:size(ab,1)
        a(i)=ab(I(i),1);
        b(i)=ab(I(i),2);
    end
end

% function rank=getRank(M,x,y)
%     n=size(M,1);
%     m=size(M,2);
%     rank=n*m-(n-x)*(m-y);
% end






%fast but naive solution - strong assumption of matrix M: values increase
%diagnoally (top-left to bottom-right)
function path=minPath2(M)

n=size(M,1);
m=size(M,2);
pathLen=min(n,m);

sets=unique(M);
count=0;
path=[];

for i=1:length(sets)
    [a,b]=find(M==sets(i));
    if count==pathLen
        break;
    end
    
    if count+length(a)>=pathLen
        num=pathLen-count;  
        
%         start=1;
%         
%         append=[a(start:start+num-1) b(start:start+num-1) ones(num,1)*sets(i)];
%         
%         a0=path(:,1);
%         b0=path(:,2);
%         
%         for ii=1:length(a0)
%             a0b0(end+1)=n*m-(n-a0(ii))*(m-b0(ii));
%         end
%         for ii=1:length(a)
%             ab(end+1)=n*m-(n-a(ii))*(m-b(ii));
%         end
% 
%         [v,I]=sort(path());
%         I=I(:,1);
%         path=[path; append];
%         temp=path;
%         for i=1:length(path)
%             if i>1 && I(i)==I(i-1)
%                 i=i+1;
%             end
%             temp(i,:)=path(I(i),:);
%         end
%         path=temp;
%     
    
        
        path=addToPath(path,sets(i),a(1:num),b(1:num));
        break;
    end
    
    path=addToPath(path,sets(i),a,b);
    count=count+length(a);
    
end



end

function path=addToPath(path,w,a,b)

append=[a b ones(size(a,1),1)*w];
if isempty(path)
    path=append;
    return;
end

a0=path(:,1);
b0=path(:,2);

a0b0=a0+b0;
ab=a+b;

[v,I]=sort([a0b0' ab]);

path=[path; append];
temp=path;
for i=1:size(path,1)
    if i>1 && I(i)==I(i-1)
        i=i+1;
    end
    temp(i,:)=path(I(i),:);
end
path=temp;
end





%CMA-ES/fmincon solution, not garantee global optimum
function path= minPath1(M)

n=size(M,1);
m=size(M,2);


path0=zeros(min(n,m),2);
for i=1:min(n,m)
    path0(i,:)=[i,i];
end
path0=[path0(:,1);path0(:,2)];
% 
% options = optimoptions('fmincon','Algorithm','interior-point'); % run interior-point algorithm

% path = fmincon(@(path) myfun(path),path0,[],[],[],[],[],[],@(path) mycon(path));

opt.StopFitness=(mean(M(:))*min(n,m))-1;
[path,fmin]=cmaes('fitfun',path0,1,opt);

n=length(path);
path=[path(1:n/2) path(n/2+1:n)];
path=int8(path)

end



% %Used for fmincon
% function f=myfun(path)
% global M
% f=0;
% for i=1:length(path)
%     x=int8(path(i,1));
%     y=int8(path(i,2));
%     f=f+M(x,y);
% end
% 
% 
% end
% 
% function [c,ceq]=mycon(path)
% global M
% n=size(M,1);
% m=size(M,2);
% 
% path=int8(path);
% c=[];
% ceq=[];
% x0=path(1,1);
% y0=path(1,2);
% for i=2:length(path)
%     x1=path(i,1);
%     y1=path(i,2);
%     c(end+1)=x1-x0;%>0
%     c(end+1)=y1-y0;%>0
%     
%     %boundary
%     c(end+1)=x1-1;%>0
%     c(end+1)=y1-1;%>0
%     c(end+1)=x0-1;%>0
%     c(end+1)=y0-1;%>0
%     c(end+1)=n-x1;%>0
%     c(end+1)=m-y1;%>0
%     c(end+1)=n-x0;%>0
%     c(end+1)=m-y0;%>0
%     
% %     ceq(end+1)=x1-x0;%=0
% %     ceq(end+1)=y1-y0;%=0
%     x0=x1;
%     y0=y1;
% end
% 
% c
% ceq
% end