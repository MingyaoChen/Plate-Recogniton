function [] = preprocess( inputFolder, outputFolder )
% list all files under paty
listing = dir(inputFolder);

% get the number of files and the properties of each file
[m, n] = size(listing);

% browse each sub directory one by one

for x=1:m
    sub = listing(x);
    
    % ignore some irrelevant hidden files in mac os
    if ((sub.isdir == 0) || (strcmp(sub.name,'.') == 1) || (strcmp(sub.name,'..') == 1) || (strcmp(sub.name,'.DS_Store') == 1))
        continue;
    end
    label = sub.name;
     % get the path of current file
    files = dir(strcat(inputFolder, label, '/'));
    [m2, n2] = size(files);
    
    %browse all car image files in each car type directory
    for y=1:m2
        subsub = files(y);
        if ((subsub.isdir == 1) || (strcmp(subsub.name,'.') == 1) || (strcmp(subsub.name,'..') == 1) || (strcmp(subsub.name,'.DS_Store') == 1))
            continue;
        end
        fileName = files(y).name;
        filePath = strcat(inputFolder, label, '/', fileName);
        
        % read the original image and change the rgb image to gray
        img = imread(filePath);
        dim = size(img);
        if numel(dim) > 2
            img = rgb2gray(img);
        end
        
        % make directory for a specific car type
        mkdir(strcat(outputFolder, label));
        
        % localise the plate and crop the image
        plateRecog(img, strcat(outputFolder, label, '/', fileName));
    end
end

