close all
clear all
clc
%%
% cd 'F:\biometric\Homework #5\iris-img\gallery\'
% for i=1:100
%     filename=['gallery_',num2str(i),'.tiff'];
%     [template{i}, mask{i}] = createiristemplate(filename);
% end
% save('F:\biometric\Homework #5\iriscode\gallery.mat','template','mask');
cd 'F:\biometric\Homework #5\iris-img\probe-blurred'
for i=1:100
    filename=['probe_',num2str(i),'.jpg'];
    [template{i}, mask{i}] = createiristemplate(filename);
end
save('F:\biometric\Homework #5\iriscode\probe.mat','template','mask');

%%

gallery=load('gallery.mat');
probe=load('probe.mat');
for i=1:100
    for j=1:100
        hd(i,j) = gethammingdistance(gallery.template{1,i}, gallery.mask{1,i},...
            probe.template{1,j}, probe.mask{1,j},1);
    end
end

%%
genuScore=diag(hd);
genuLoc = eye(size(hd));
impScore = hd(~genuLoc);

genuMean=nanmean(genuScore);
impMean=nanmean(impScore);
genuStd=nanstd(genuScore);
impStd=nanstd(impScore);

edges = 0:0.03:1;
hist1 = histcounts(genuScore,edges, 'Normalization', 'probability');
hist2 = histcounts(impScore,edges, 'Normalization', 'probability');
figure();
plot(edges,[0,hist1]);
hold on;
plot(edges,[0,hist2]);
title('Match Result');
xlabel('Hamming Distance');
ylabel('Probability');
legend('Genuine distribution','Imposter Distribution');

genuMaxLoc=find(genuScore==max(genuScore));

genuMinLoc=find(genuScore==min(genuScore));

impMaxLoc=find(impScore==max(impScore));

impMinLoc=find(impScore==min(impScore));

%%
img1=probe.mask{3};
img2=probe.template{3};
figure;
subplot(2,1,1)
imshow(img1);
subplot(2,1,2)
imshow(img2);

%%
img1=imread('F:\biometric\Homework #5\iris-img\gallery\gallery_45.tiff');
img2=imread('F:\biometric\Homework #5\iris-img\probe-blurred\probe_71.jpg');
imgg=cat(2,img1,img2);
figure;
imshow(imgg);

%%
count=0;
for i=1:100
    for j=1:100
        if i~=j 
            count=count+1;
        end
        if count==4426
            i
            j
        end
    end
end

        

