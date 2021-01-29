close all
clear all
clc

load simMatrix1.txt
load simMatrix2.txt
[m,n]=size(simMatrix1);

genuScore=diag(simMatrix1);
genuLoc = eye(size(simMatrix1));
impScore = simMatrix1(~genuLoc);
edges = 0:0.01:1;
hist1 = histcounts(genuScore,edges, 'Normalization', 'probability');
hist2 = histcounts(impScore,edges, 'Normalization', 'probability');
figure();
subplot(2,1,1);
plot(edges,[0,hist1]);
hold on;
plot(edges,[0,hist2]);
title('simMatrix1');
xlabel('Match Score');
ylabel('Probability');
legend('Genuine distribution','Imposter Distribution');

genuScore2=diag(simMatrix2);
genuLoc2 = eye(size(simMatrix2));
impScore2 = simMatrix2(~genuLoc2);
edges = 0:0.01:1;
hist21 = histcounts(genuScore2,edges, 'Normalization', 'probability');
hist22 = histcounts(impScore2,edges, 'Normalization', 'probability');
subplot(2,1,2);
plot(edges,[0,hist21]);
hold on;
plot(edges,[0,hist22]);
title('simMatrix2');
title('simMatrix2');
xlabel('Match Score');
ylabel('Probability');
legend('Genuine distribution', 'Imposter Distribution');


cmc=zeros(m,1);
for t = 1:m
    temp=size(find(simMatrix1(:,t)>simMatrix1(t,t)),1);
    cmc(temp+1)=cmc(temp+1)+1;
end;
for t = 2:m
    cmc(t)=cmc(t)+cmc(t-1);
end;
figure();
subplot(2,1,1);
plot(1:1:m,cmc/m);
title('simMatrix1');
xlabel('Rank(t)');
ylabel('Rank-t Identification Rate');
xlim([1 466]);
ylim([0.75 1]);

cmc2=zeros(m,1);
for t = 1:m
    find(simMatrix2(:,t)>simMatrix2(t,t))
    temp=size(find(simMatrix2(t,:)>simMatrix2(t,t)),2)
    cmc2(temp+1)=cmc2(temp+1)+1;
end;
for t = 2:m
    cmc2(t)=cmc2(t)+cmc2(t-1);
end;
subplot(2,1,2);
plot(1:1:m,cmc2/m);
title('simMatrix2');
xlabel('Rank(t)');
ylabel('Rank-t Identification Rate');
ylim([0.75 1]);
xlim([1 466]);

d=sqrt(2)*abs(mean(genuScore)-mean(impScore))/sqrt((std(genuScore)).^2+(std(impScore)).^2);
d2=sqrt(2)*abs(mean(genuScore2)-mean(impScore2))/sqrt((std(genuScore2)).^2+(std(impScore2)).^2);

r=find((cmc/m)>0.7,1);
r2=find((cmc2/m)>0.7,1);

%%
for t=1:1:1001
    thres=(t-1)/1000;
    far(t)=size(find(impScore>thres),1)/216690;
    frr(t)=size(find(genuScore<thres),1)/466;
end;
figure();
subplot(2,1,1);
plot(far,frr);
title('simMatrix1');
xlabel('FAR');
ylabel('FRR');

for t=1:1:1001
    thres=(t-1)/1000;
    far2(t)=size(find(impScore2>thres),1)/216690;
    frr2(t)=size(find(genuScore2<thres),1)/466;
end;
subplot(2,1,2);
plot(far2,frr2);
title('simMatrix2');
xlabel('FAR');
ylabel('FRR');

differ=abs(far(:)-frr(:));
opPoint=(find(differ==min(differ))-1)/1000;
eer=far(opPoint*1000+1);

differ2=abs(far2(:)-frr2(:));
opPoint2=(find(differ2==min(differ2))-1)/1000;
eer2=far2(opPoint2*1000+1);

%%
[min1,loc1]=min(abs(far2(:)-0.01));
ans1=frr2(loc1);
