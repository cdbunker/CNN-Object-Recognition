%%% Load all of the data into memory

folder = '.\images';
namesFolder = '.\names';

names = dir(fullfile(namesFolder,'*.mat')); %gets all wav files in struct

newDir = './datastore/';
allPic = dir(fullfile(folder,'*.jpg')); %gets all wav files in struct

allPics = imageDatastore(folder);

l = length(allPic);

category = categorical(zeros(l,1));
% Aeroplanes=0
% Bicycles=1
% Birds=2
% Boats=3
% Bottle=4
% Buses=5
% Car=6
% Cat=7
% Chair=8
% Cow=9
% diningtable=10
% Dog=11
% Horse=12
% Motorbike=13
% People=14
% pottedplant=15
% Sheep=16
% Sofa=17
% Train=18
% TVMonitor=19
for k = 1:l
    baseFileName = names(k).name;
    fullFileName = fullfile(baseFileName);
    if (mod(k,1000)==0)
        fprintf(1, 'Now reading %s\n', fullFileName);
    end
    name=load(baseFileName);
    
    N=name.name;
    
    c=cellstr(lower(N{1}));
    category(k,1) = c;
end

allPics.Labels = categorical(category);
allPics.ReadFcn = @(filename)readAndPreprocessImage(filename);