function window = ...
    im_crop(im, bbox, crop_mode, crop_size, padding, mean_rgb)
% window = im_crop(im, bbox, crop_mode, crop_size, padding, image_mean)
%   Crops a window specified by bbox (in [x1 y1 x2 y2] order) out of im.
%
%   crop_mode can be either 'warp' or 'square'
%   crop_size determines the size of the output window: crop_size x crop_size
%   padding is the amount of padding to include at the target scale
%   image_mean to subtract from the cropped window
%
%   N.B. this should be as identical as possible to the cropping
%   implementation in Caffe's WindowDataLayer, which is used while
%   fine-tuning.

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
%
% This file is part of the R-CNN code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------
%
% Modified by Hyeonseob Nam, 2015
%
% ---------------------------------------------------------
%
% Modified by Lingxiao Yang, 2017
%

if nargin<6, mean_rgb = []; end

use_square = false;
if strcmp(crop_mode, 'square')
    use_square = true;
end

% defaults if padding is 0
pad_w = 0;
pad_h = 0;
crop_width = crop_size;
crop_height = crop_size;
if padding > 0 || use_square
    scale = crop_size/(crop_size - padding*2);
    half_height = bbox(4)/2;
    half_width = bbox(3)/2;
    center = [bbox(1)+half_width bbox(2)+half_height];
    if use_square
        % make the box a tight square
        if half_height > half_width
            half_width = half_height;
        else
            half_height = half_width;
        end
    end
    bbox = round([center center] + ...
        [-half_width -half_height half_width half_height]*scale);
    unclipped_height = bbox(4)-bbox(2)+1;
    unclipped_width = bbox(3)-bbox(1)+1;
    %figure(1); showboxesc([], bbox, 'r', '-');
    pad_x1 = max(0, 1 - bbox(1));
    pad_y1 = max(0, 1 - bbox(2));
    % clipped bbox
    bbox(1) = max(1, bbox(1));
    bbox(2) = max(1, bbox(2));
    bbox(3) = min(size(im,2), bbox(3));
    bbox(4) = min(size(im,1), bbox(4));
    clipped_height = bbox(4)-bbox(2)+1;
    clipped_width = bbox(3)-bbox(1)+1;
    scale_x = crop_size/unclipped_width;
    scale_y = crop_size/unclipped_height;
    crop_width = round(clipped_width*scale_x);
    crop_height = round(clipped_height*scale_y);
    pad_x1 = round(pad_x1*scale_x);
    pad_y1 = round(pad_y1*scale_y);
    
    pad_h = pad_y1;
    pad_w = pad_x1;
    
    if pad_y1 + crop_height > crop_size
        crop_height = crop_size - pad_y1;
    end
    if pad_x1 + crop_width > crop_size
        crop_width = crop_size - pad_x1;
    end
%     figure(1); showboxesc(im/256, bbox, 'b', '-');
end % padding > 0 || square

window = im(bbox(2):bbox(4), bbox(1):bbox(3), :);
% We turn off antialiasing to better match OpenCV's bilinear
% interpolation that is used in Caffe's WindowDataLayer.
% tmp = imresize(window, [crop_height crop_width], ...
%     'bilinear', 'antialiasing', false);

% if your do not proper install opencv3.0 and mexopencv, please uncomment
% above build-in function and comment the following line
tmp = cv.resize(window, [crop_width crop_height]);

% tmp = Utility.imResampleMex(window, [crop_width crop_height]);
tmp = single(tmp);

window = zeros(crop_size, crop_size, 3, 'single');
window(pad_h+(1:crop_height), pad_w+(1:crop_width), :) = tmp;
