clc
clear all
close all
for i=1:7
    FP{i}(:,:)=load(["FP"+num2str(i)+".txt"]);
end;
total=0;
for i=1:6
    for j=i+1:7
        m=size(FP{i},1);
        n=size(FP{j},1);
        a=zeros(73,61,61);
        for p=1:m
            for q=1:n
                theta=round((FP{i}(p,3)-FP{j}(q,3))/10);
                x=round((FP{i}(p,1)-FP{j}(q,1)*cos(theta)-FP{j}(q,2)*sin(theta))/30);
                y=round((FP{i}(p,2)+FP{j}(q,1)*sin(theta)-FP{j}(q,2)*cos(theta))/30);
                a(theta+37,x+31,y+31)=a(theta+37,x+31,y+31)+1;
            end
        end
        total=total+1;
        [M,Loc]=max(a(:));
        [deltatheta,deltax,deltay]=ind2sub([73,61,61],Loc(1));
        delta{total,1}="FP"+num2str(i);
        delta{total,2}="FP"+num2str(j);
        delta{total,3}=(deltatheta-37)*10;
        delta{total,4}=(deltax-31)*30;
        delta{total,5}=(deltay-31)*30;
    end
end
T = cell2table(delta,'VariableNames',{'FirstFP' 'SecondFP' 'DeltaTheta' 'DeltaX' 'DeltaY'})

%% matching
delInd=0;
td=21;
ttheta=5;
totalp=0;
totalup=0;
for i=1:6
    for j=i+1:7
        count=0;
        delInd=delInd+1; 
        m=size(FP{i},1); n=size(FP{j},1);
        
        alitheta=double(cell2mat(delta(delInd,3)));
        alix=double(cell2mat(delta(delInd,4)));
        aliy=double(cell2mat(delta(delInd,5)));
        
%         ttheta=(360+abs(alitheta))/36;
%         td=sqrt(((300+abs(alix))/30).^2+((300+abs(aliy))/30).^2);
        
        f1=zeros(m,1); f2=zeros(n,1);
        
        for p=1:m
            for q=1:n
               if ((~f1(p)) && (~f2(q)) ...
                       && (abs(FP{j}(q,3)+alitheta-FP{i}(p,3))<ttheta))
                   dx=round(FP{i}(p,1)-((FP{j}(q,1)*cos(alitheta)+FP{j}(q,2)*sin(alitheta))+alix));
                   dy=round(FP{i}(p,2)-((-FP{j}(q,1)*sin(alitheta)+FP{j}(q,2)*cos(alitheta))+aliy));
                   if sqrt(dx.^2+dy.^2)<td
                       count=count+2;
                       f1(p,1)=1;
                       f2(q,1)=1;
                   end;
               end
            end
        end
        matchScore{delInd,1}="FP"+num2str(i);
        matchScore{delInd,2}="FP"+num2str(j);
        matchScore{delInd,3}=td;
        matchScore{delInd,4}=ttheta;
        matchScore{delInd,5}=count;
        totalp=totalp+count;
        matchScore{delInd,6}=m+n-count;
        totalup=totalup+m+n-count;
    end
end
T2 = cell2table(matchScore,'VariableNames',{'FirstFP' 'SecondFP' 'Distance' 'Angle' 'PairedPoints' 'UnpairedPoints'})
        
                   
