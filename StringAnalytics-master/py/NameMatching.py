# -*- coding: utf-8 -*-
"""
Created on Mon Aug  6 10:10:52 2018

@author: sbray0730
"""


import pandas as pd
from pandas import ExcelFile
import numpy as np
#import jellyfish
from jellyfish import jaro_distance
import itertools
import  csv

df = pd.read_excel('doc1.xlsx', sheetname='Sheet1')


#Here I want to put the data into an array so that it is easy to iterate, I can drop the dataframe at this point... should have just wentt into an array...
nameArray = np.array(df.ix[:,0], dtype=None, copy=True)
nameArray.sort()

del(df)

#I want to instantiate a new list to populate my results
newList = []


#This function will perform the string comparison using the Jellyfish library
def d(coord):
    i,j = coord
    return jaro_distance(nameArray[i], nameArray[j])

#Here is where the magic happens, I begin by looping through the names from cams
for x in nameArray:
    l = (x, nameArray.tolist().index(x)) #I need to get the word and the index of the word
    if((any( e[1] == x for e in newList)) == False): #if the word I am working with is not already in my newList file, then i perform the search
        for o in nameArray: 
            matchList = (l[0],o,d([l[1], nameArray.tolist().index(o)])) #Here I populate a list with all the words that match what I am looking for, and the percent distance of the match
            #print(matchList)
            if(matchList[2]>=.85): #I found that I get less noise when I accept matches that have an 85% likelyhood of being the same.
                #print(matchList)
                for match in matchList: #now for the matches in my list, I append them to my list of lists
                    newList.append(matchList)
                

##Here I want to remove duplicate entries, need to fine tune my loops at a later date so that I do not have them
newList = list(newList for newList,_ in itertools.groupby(newList))


# i put the output in a final file for delivery, or checking
with open("out.csv","w") as f:
    wr = csv.writer(f)
    wr.writerows(newList)