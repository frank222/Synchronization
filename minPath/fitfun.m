%cmaes()


% velErr vel pitch*100
%posPara = [-1.2231 0.41653 0.21201]/100;
%psiPara = [1.258 1.6294 -7.1549];

function f = fitfun(path)
global M
f=0;

n=length(path);
path=[path(1:n/2) path(n/2+1:n)];


[n,m]=size(M);
flag=0;
%boundary
for i=1:length(path)
    x=path(i,1);
    y=path(i,2);
    if x<1 || y<1 || x>n || y>m
        f=f+10e10;
        flag=1;
    end
end


%move leftward,downward
x0=path(1,1);
y0=path(1,2);
for i=2:length(path)
    x1=path(i,1);
    y1=path(i,2);
    if x1<x0 || y1<y0 %|| (x1==x0 && y1==y0)
        f=f+10e10;
        flag=1;
    end
%     c(end+1)=x1-x0;%>0
%     c(end+1)=y1-y0;%>0
%     c(c>=0)=[];
%     f=f+sum(c*w);
    x0=x1;
    y0=y1;
end

if flag
    return;
end


f=0;

for i=1:length(path)
    x=int8(path(i,1));
    y=int8(path(i,2));
    f=f+M(x,y);
end

c=[];
w=10e10;
x0=path(1,1);
y0=path(1,2);
for i=2:length(path)
    x1=path(i,1);
    y1=path(i,2);
    c(end+1)=x1-x0;%>0
    c(end+1)=y1-y0;%>0
    c(c>=0)=[];
    f=f+sum(c*w);
    x0=x1;
    y0=y1;
end


%     f=f+(x1-1)*wb;%>0
%     f=f+(y1-1)*wb;%>0
%     f=f+(x0-1)*wb;%>0
%     f=f+(y0-1)*wb;%>0
%     f=f+(n-x1)*wb;%>0
%     f=f+(m-y1)*wb;%>0
%     f=f+(n-x0);%>0
%     f=f+(m-y0);%>0


end