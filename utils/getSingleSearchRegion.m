function [patch, bbox, info] = getSingleSearchRegion(image, bbox, opts)
    
    % crop image
    [patch, offset, impad] = contextCropImage(image, bbox, opts.locContext);
    
    % resize image and bbox
    [h, w, ~] = size(patch);
    imageSize = [opts.inputSize, opts.inputSize];
    scale = imageSize ./ [w h];
    
    info.offset = offset;
    info.scale = scale;
    info.impad = impad;
    
    bbox = getAlignedBBox(bbox, info);
    patch = cv.resize(patch, imageSize);
end