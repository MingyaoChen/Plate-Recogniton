% using harris detector
function [ featureSet, labelSet ] = extractFeature(path)

listing = dir(path);
[m, n] = size(listing);
featureSet = [];
labelSet = [];

for x=1:m
    sub = listing(x);
    if (sub.isdir == 0) || (strcmp(sub.name,'.') == 1) || (strcmp(sub.name,'..') == 1)
        continue;
    end
    label = sub.name;
    files = dir(strcat(path, label, '/'));
    [m2, n2] = size(files);
    for y=1:m2
        subsub = files(y);
        if (subsub.isdir == 1) || (strcmp(subsub.name,'.') == 1) || (strcmp(subsub.name,'..') == 1)
            continue;
        end
        fileName = files(y).name;
        filePath = strcat(path, label, '/', fileName);
        img = imread(filePath);
        img = imresize(img, [100, 100]);
        c = extractHOGFeatures(img);
        featureSet = [featureSet;c];
        labelSet = [labelSet;x];
    end
end

end

