function image = readImage(file)
    
    image = imread(file);
    if size(image, 3) == 1
        image = repmat(image, [1 1 3]);
    end

end

