function patches = getPatches(image, samples, opts)
    nums = size(samples, 1);
%     cropSize = [opts.inputSize opts.inputSize];
%     boxes = samples;
%     boxes(:, 3:4) = boxes(:, 1:2) + boxes(:, 3:4) - 1;
%     patches = cropRectanglesMex(single(image), boxes(:, [2 1 4 3]), cropSize);
%     if ~opts.useGpu
%         patches = gather(patches);
%     end
    patches = zeros(opts.inputSize, opts.inputSize, 3, nums, 'single');
    for i = 1:nums
        patches(:,:,:,i) = im_crop(image, samples(i, :), opts.cropMode, opts.inputSize, opts.cropPadding);
    end
end