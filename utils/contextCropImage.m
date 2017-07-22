function [patch, offset, impad] = contextCropImage(im, bbox, padding)
    
    [imy, imx, ~] = size(im);

    cx = bbox(1) + bbox(3) / 2;
    cy = bbox(2) + bbox(4) / 2; 
    cropSize = bbox(3:4) * padding;

    xmin = round(cx - cropSize(1)/2); 
    xmax = xmin + cropSize(1) - 1;
    ymin = round(cy - cropSize(2)/2); 
    ymax = ymin + cropSize(2) - 1;
    lpad = double(round(max(0, 1 - xmin)));
    tpad = double(round(max(0, 1 - ymin)));
    rpad = double(round(max(0, xmax - imx)));
    bpad = double(round(max(0, ymax - imy)));
    
    xmin = xmin + lpad;
    xmax = xmax + lpad;
    ymin = ymin + tpad;
    ymax = ymax + tpad;

    if tpad || lpad
        R = padarray(im(:,:,1), [tpad lpad], 0, 'pre');
        G = padarray(im(:,:,2), [tpad lpad], 0, 'pre');
        B = padarray(im(:,:,3), [tpad lpad], 0, 'pre');
        im = cat(3, R, G, B);
    end

    if bpad || rpad
        R = padarray(im(:,:,1), [bpad rpad], 0, 'post');
        G = padarray(im(:,:,2), [bpad rpad], 0, 'post');
        B = padarray(im(:,:,3), [bpad rpad], 0, 'post');
        im = cat(3, R, G, B);
    end

    patch = single(im(round(ymin:ymax), round(xmin:xmax), :));
    offset = [xmin ymin];
    impad = [tpad lpad bpad rpad];
end