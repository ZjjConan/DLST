function [regions, labels, instanceWeights, cropInfo] = getSearchRegions(image, samples, opts)

    regions = zeros(opts.inputSize, opts.inputSize, 3, size(samples, 1), 'single');
    labels = zeros(opts.labelSize, opts.labelSize, 1, size(samples, 1), 'single');
    instanceWeights = zeros(opts.labelSize, opts.labelSize, 1, size(samples, 1), 'single');

    labelSize = [opts.labelSize opts.labelSize];
    posRadius = opts.locR / opts.locTotalStride;
    
    for i = 1:size(samples, 1)
        [regions(:,:,:,i), alignedSample, cropInfo] = getSingleSearchRegion(image, samples(i, :), opts);
        center = alignedSample(1:2) + alignedSample(3:4) / 2;
        [labels(:,:,:,i), instanceWeights(:,:,:,i)] = ...
            getLabels(labelSize, center / opts.locTotalStride, posRadius);
    end

end

