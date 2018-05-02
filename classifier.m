loaddata
makeImageDatastore2

tbl = countEachLabel(allPics)
trainingNumFiles = 2500;
rng(1) % For reproducibility
[trainData,testData, valData] = splitEachLabel(allPics, ...
				trainingNumFiles,170,50,'randomize');

labels=length(unique(trainData.Labels));
%

net = alexnet;
layersTransfer = net.Layers(1:end-3);
layers = [
    layersTransfer
    fullyConnectedLayer(labels,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm','MaxEpochs',30,...
      'LearnRateSchedule','piecewise',...
      'LearnRateDropFactor',0.02,...
      'LearnRateDropPeriod',3,...
      'ValidationData',valData,...
      'ValidationFrequency',50,...
	  'InitialLearnRate',0.001, ...
      'MiniBatchSize',50, ...
      'ValidationPatience', 4, ...
      'Plots', 'training-progress',...,
      'Shuffle','Every-epoch');


convnet = trainNetwork(trainData,layers,options);

[YTest,err] = classify(convnet,testData);
TTest = testData.Labels;
%%
% Calculate the accuracy.
accuracy = sum(YTest == TTest)/numel(TTest)
conf = zeros(labels);

for i=1:length(YTest)
   conf(YTest(i), TTest(i)) = conf(YTest(i), TTest(i))+1;
end

%confusion matrix
conf

%Percent correct for each class
eye(length(conf)).*conf./sum(conf,1)

%Error of classifications with confidence>0.95
err2=err;
err2(:,end+1)=TTest;
err2(:,end+1)=YTest;
ind=find(max(err2(:,1:labels),[],2)>0.95);
err3=err2(ind,:);
sum(err3(:,end-1)==err3(:,end))/size(err3,1)




%%%Test it out
img = imread('\VOCdevkit\VOC2007\JPEGImages\000009.jpg');
imshow(img)
 
clear boxes
clear boxes2

boxes = selsearch(img);

boxes2(:,1)=boxes(:,2);
boxes2(:,2)=boxes(:,1);

four = boxes(:,3)-boxes(:,1);
three = boxes(:,4)-boxes(:,2);
boxes2(:,4)=four;
boxes2(:,3)=three;

% figure
% heatmap = zeros(size(img,1), size(img,2), 1);
% for i=1:length(boxes)
%     temp = zeros(size(img,1), size(img,2), 1);
%     temp(boxes(i,1):boxes(i,3), boxes(i,2):boxes(i,4)) = 1;
%     heatmap = heatmap + temp;
% end
% imshow(heatmap, [])

figure
imshow(img)
hold on
for i=1:length(boxes)
    I=imcrop(img,boxes2(i,:));
    [class,con]=classify(convnet,imresize(I,[227,227]));
    classes(i)=class;
    cons(i)=max(con);
    if (max(con)>0.95)
       rectangle('Position',boxes2(i,:), 'EdgeColor', 'y', 'LineWidth', 2)
       drawnow
       fprintf('%s\t%f\n',class,max(con));
    end
end

[~,ind]=max(cons);
classes(ind)
figure
imshow(img)
rectangle('Position',boxes2(ind,:), 'EdgeColor', 'y', 'LineWidth', 2)