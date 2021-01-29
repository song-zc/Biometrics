# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 17:47:59 2020

@author: Jonathan
"""
import re

for num in range(1,8):
    f = open("FP"+str(num)+"_raw.txt")
    fOut = open("FP"+str(num)+".txt", 'w+')
    line = f.readline()
    while line:
        numbers=re.findall(r"\d+",line)
        print (numbers[1],numbers[2],int(numbers[3])*11.5,file=fOut)    
        line = f.readline()
    f.close()
    fOut.close()