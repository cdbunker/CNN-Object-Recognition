# CNN-Object-Recognition
Object Recognition using CNNs

This was trained by transfering AlexNet then retrained using the VOC 2007 dataset. The bounding boxes were 
found by using Selective Search algorithm develoed by Uijlings et al. (https://www.koen.me/research/selectivesearch/).

It only shows the object with the highest classification confidence, but it could easily be extended to showing all
objects.

Results:
Showing all interesting bounding boxes:

![alt text](https://github.com/cdbunker/CNN-Object-Recognition/blob/master/Results/AllBoundingBoxes.PNG)

Correctly classified Bottle:

![alt text](https://github.com/cdbunker/CNN-Object-Recognition/blob/master/Results/Bottle.PNG)

Correctly classified Cat:

![alt text](https://github.com/cdbunker/CNN-Object-Recognition/blob/master/Results/Cat.PNG)

Correctly classified Horse:

![alt text](https://github.com/cdbunker/CNN-Object-Recognition/blob/master/Results/Horse.PNG)
