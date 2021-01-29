close all
clear all
clc

simMatrix=load('simMatrixlh.txt');
[m,n]=size(simMatrix);

genuNum=0;
impNum=0;
for i=1:m
    for j=1:n
        if ceil(j/2)==i
            genuNum=genuNum+1;
            genuScore(genuNum)=simMatrix(i,j);
        else
            impNum=impNum+1;
            impScore(impNum)=simMatrix(i,j);
        end
    end
end
edges = 0:0.01:1;
hist1 = histcounts(genuScore,edges, 'Normalization', 'probability');
hist2 = histcounts(impScore,edges, 'Normalization', 'probability');
figure();
plot(edges,[0,hist1]);
hold on;
plot(edges,[0,hist2]);
title('simMatrix');
xlabel('Match Score');
ylabel('Probability');
legend('Genuine distribution','Imposter Distribution');

cmc=zeros(n,1);
for t = 1:n
    temp=size(find(simMatrix(:,t)>simMatrix(ceil(t/2),t)),1);
    cmc(temp+1)=cmc(temp+1)+1;
end;
for t = 2:n
    cmc(t)=cmc(t)+cmc(t-1);
end;
figure();
plot(1:1:n,cmc/n);
title('simMatrix');
xlabel('Rank(t)');
ylabel('Rank-t Identification Rate');

d=sqrt(2)*abs(mean(genuScore)-mean(impScore))/sqrt((std(genuScore)).^2+(std(impScore)).^2);

%%
for t=1:1:1001
    thres=(t-1)/1000;
    far(t)=size(find(impScore>thres),2)/impNum;
    frr(t)=size(find(genuScore<=thres),2)/genuNum;
end;
figure();
plot(far,frr);
title('simMatrix');
xlabel('FAR');
ylabel('FRR');


differ=abs(far(:)-frr(:));
opPoint=(find(differ==min(differ))-1)/1000;
eer=far(opPoint*1000+1);

r=find((cmc/n)>0.8,1);

[min1,loc1]=min(abs(far(:)-0.01));
ans1=frr(loc1);
[min2,loc2]=min(abs(far(:)-0.2));
ans2=frr(loc2);

