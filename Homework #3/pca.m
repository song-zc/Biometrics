close all
clear all
clc

I=[];
for i=1:100
   gallery=imread(['.\GallerySet\subject',num2str(i),'_img1.pgm']);
   [m,n]=size(gallery);
   gallery=gallery(26:50,1:50);
   [m,n]=size(gallery);
   temp=reshape(gallery,m*n,1);
   I=[I temp];
end
I=double(I);
x=mean(I,2);
A(1:1250,:)=I(1:1250,:)-x;
[eigenvector,eigenvalue]=eig(A'*A);
T=sum(sum(eigenvalue));
t=0;
for i=1:100
    for j=i+1:100
        if eigenvalue(i,i)<eigenvalue(j,j)
            temp=eigenvalue(i,i);
            eigenvalue(i,i)=eigenvalue(j,j);
            eigenvalue(j,j)=temp;
            temp=eigenvector(i,:);
            eigenvector(i,:)=eigenvector(j,:);
            eigenvector(j,:)=temp;
        end
    end
    t=t+eigenvalue(i,i);
    if t/T>0.9
        break
    end
end
K=i;
u=[];
for i=1:K
    u=[u A*eigenvector(i,:)'];
end
eigenface=[];
for i=1:100
    eigenface=[eigenface u'*A(:,i)];
end
img=zeros(1250,1);
for j=1:K
    img=img+(eigenface(j,100).*u(:,j));
end;
img=img+x;
img=reshape(img,m,n);
figure;
imshow(img,[]);
imgori=reshape(I(:,100),m,n);
figure;
imshow(imgori,[]);
for i=1:100
    for j=1:100
        probe1=imread(['.\ProbeSet\subject',num2str(j),'_img2.pgm']);
        probe2=imread(['.\ProbeSet\subject',num2str(j),'_img3.pgm']);
        probe1=probe1(1:50,1:50);
        probe2=probe2(1:50,1:50);
        temp1=double(reshape(probe1,m*n,1));
        temp1=temp1-x;
        temp1=u'*temp1;
        temp2=double(reshape(probe2,m*n,1));
        temp2=temp2-x;
        temp2=u'*temp2;
        simMatrix(i,j*2-1)=norm(eigenface(:,i)-temp1);
        simMatrix(i,j*2)=norm(eigenface(:,i)-temp2);
    end    
end
simMatrix=normalize(simMatrix,'range');
simMatrix=roundn(simMatrix,-6);
writematrix(simMatrix,'simMatrixpca.txt','Delimiter',' ');