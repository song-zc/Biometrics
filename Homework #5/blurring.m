close all
clear all
clc


for i=1:100
    filename=['F:\biometric\Homework #5\iris-img\probe\probe_',num2str(i),'.tiff'];
    img=imread(filename);
    sigma=1;
    window=double(5);
    H=fspecial('gaussian', window, sigma);
    imgGauss=imfilter(img,H,'replicate');
    imwrite(imgGauss,['F:\biometric\Homework #5\iris-img\probe-blurred\probe_',num2str(i),'.jpg'],'jpg');
end

