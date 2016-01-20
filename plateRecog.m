function [result] = plateRecog(img, outputPath)

    % resize all images into same dimension
    m = 480;
    n = 640;
    img = imresize(img, [m, n])
   
    % change to bw image
    level = graythresh(img);
    bw = im2bw(img,level);
    
    % imfill the 'white circles'
    % help to recognise rectangle
    bw=imfill(bw,'holes');
    
    % clear border and ignore small regions that cannot be the plate
    bw = imclearborder(bw, 8);
    bw = bwareaopen(bw, 2000);
    
    % get all regions and their properties
    L = bwlabel(bw, 8);
    stats = regionprops(L, 'centroid', 'BoundingBox');
    
    % localise plate
    possibleRectangles = [];
    center = [];
    for i = 1:size(stats)
        center = stats(i).Centroid;
%         if center(1) < 240 || center(1) > 400
%             continue;
%         end
        aspectRatio = stats(i).BoundingBox(3)/stats(i).BoundingBox(4);
        if aspectRatio < 4.5 && aspectRatio > 2
            possibleRectangles = [possibleRectangles; stats(i).BoundingBox];
            center = stats(i).Centroid;
        end
    end

    % resize the image according to the absolute value of plate
    % thus, the area of a car will be in similar range around the plate
    % this step can help to crop the image
    if size(possibleRectangles,1) == 1
        numPlateImg = imcrop(img,possibleRectangles(1,:));
        numPlateImg = imcomplement(numPlateImg);
        [h, w] = size(numPlateImg);
        heightRatio = 70 / h;
        widthRatio = 220 / w;
        result = imresize(img, [int16(m*heightRatio), int16(n*widthRatio)]);
       
        % crop image to reduce the effects of surroundings
        startx = int16(center(1) - 300);
        starty = int16(center(2) - 300);

        if startx < 0
            startx = 0;
        end
        if starty < 0
            starty = 0;
        end
        
        [sizex, sizey] = size(result);
        if sizex > 450 && sizey > 600
            result = imcrop(result, [starty, startx, 450, 600]);
        else
            result = imresize(result, [450, 600]);
        end
        
        % resize the image to get proper number of hog features
        result = imresize(result, [100, 100]);
        
        % save the normalized images
        imwrite(result, outputPath);
    end
end


