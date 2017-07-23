function patches = getPatches(image, samples, opts)
    nums = size(samples, 1);
    patches = zeros(opts.inputSize, opts.inputSize, 3, nums, 'single');
    for i = 1:nums
        patches(:,:,:,i) = im_crop(image, samples(i, :), opts.cropMode, opts.inputSize, opts.cropPadding);
    end
end