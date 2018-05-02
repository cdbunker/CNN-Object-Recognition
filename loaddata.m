%%% Crop the images to fit their bounding box
%%% 10 crops are taken per image
%%% 5 randomly translated and their flipped versions


annotationFolder = '\VOCdevkit\VOC2007\Annotations';
imageFolder = '\VOCdevkit\VOC2007\JPEGImages';
newImageDir = '\images\';
newNameDir = '\names\';
annotations = dir(fullfile(annotationFolder,'*.xml')); %gets all wav files in struct
count=0;
tic
for k = 1:length(annotations)
    if (mod(count,100)==0)
        toc
        count
        k
        tic
    end
    baseFileName = annotations(k).name;
    fullFileName = fullfile(baseFileName);
    %fprintf(1, 'Now reading %s\n', fullFileName);
    
    s=xml2struct(baseFileName);
    
    %number of objects in image
    numObjects = length(s.annotation.object);
    
    %bounding boxes and annotation for each object
    objects = s.annotation.object;
    boxes = zeros(numObjects, 4);
    names = cell(numObjects, 1);
    
    if (numObjects > 1)
        for i=1:numObjects
            o = objects{i};
            names{i} = o.name.Text;
            bndbox = o.bndbox;
            boxes(i,1) = str2double(bndbox.xmin.Text);
            boxes(i,2) = str2double(bndbox.ymin.Text);
            boxes(i,3) = str2double(bndbox.xmax.Text)-str2double(bndbox.xmin.Text);
            boxes(i,4) = str2double(bndbox.ymax.Text)-str2double(bndbox.ymin.Text);
        end
    else
        names{1} = objects.name.Text;
        bndbox = objects.bndbox;
        boxes(1,1) = str2double(bndbox.xmin.Text);
        boxes(1,2) = str2double(bndbox.ymin.Text);
        boxes(1,3) = str2double(bndbox.xmax.Text)-str2double(bndbox.xmin.Text);
        boxes(1,4) = str2double(bndbox.ymax.Text)-str2double(bndbox.ymin.Text);
    end
    
    img = imread([imageFolder '\' baseFileName(1:end-4) '.jpg']);
    I = im2double(img);
    
    for i=1:numObjects
        newImg = imresize(imcrop(I, boxes(i,:)),[275,275]);
        for j=1:5
            x=randi([113,143]);
            y=randi([113,143]);
            cropped=imcrop(newImg, [x-112,y-112,227,227]);
            imwrite(cropped, strcat(newImageDir,'Image',num2str(count),'.jpg'))
            name = names(i);
            save(strcat(newNameDir,'Object',num2str(count),'.mat'),'name')
            count=count+1;
            flipped=fliplr(cropped);
            imwrite(flipped, strcat(newImageDir,'Image',num2str(count),'.jpg'))
            save(strcat(newNameDir,'Object',num2str(count),'.mat'),'name')
            count=count+1;
        end
    end
    
    close all force
end
toc