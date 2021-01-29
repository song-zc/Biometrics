close all
clear all
clc

for i=1:100
    for j=1:100
        gallery=imread(['.\GallerySet\subject',num2str(i),'_img1.pgm']);
        probe1=imread(['.\ProbeSet\subject',num2str(j),'_img2.pgm']);
        probe2=imread(['.\ProbeSet\subject',num2str(j),'_img3.pgm']);
        [m,n]=size(gallery);
        gallery=gallery(1:m,26:n);
        probe1=probe1(1:m,26:n);
        probe2=probe2(1:m,26:n);
        simMatrix(i,j*2-1)=corr2(gallery,probe1);
        simMatrix(i,j*2)=corr2(gallery,probe2);
        
    end
end
simMatrix=roundn(simMatrix,-6);
writematrix(simMatrix,'simMatrixrh.txt','Delimiter',' ')