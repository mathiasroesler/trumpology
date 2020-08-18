# Trumpology project
This project was part of a course on human/machine interaction and used knowledge of signal processing and in particular audio signals. The article Trumpologie in the article folder explains the findings in French. 

## General information
The objective of the project was to see if it is possible to discriminate a voice from imitators. To do this, the voice of President Donald Trump was compared with imitators. The characteristics of the voice that were extracted from the data were the picth, the fundatmental frequency and the rate using MFCC. The data was seperated using a Bhattacharyya distance. 

For this project, very simple databases were constructed. The data is saved and seperated in three sets: train, test and validation. They are made of different corpora (French politicians, Trump imitators, normal speakers, American men politicians, American women politicians and Trump speeches) each composed of four speakers. 

## Technologies
* MATLAB Release R2019b

## Launch
To launch the project run the `main.m` file from MATLAB.

## Organization
The article folder contains the articles that were used during the project as well at the article that was written about the project (Trumpologie.pdf).

The code folder contains the different functions that were written for this project. 

The data folder contains the databases that were created for this project. 

Some of the results are saved in the folder with the same name. A ranking of the different imitators can be found and the evolution of the distance with the number of MFCC as well.
