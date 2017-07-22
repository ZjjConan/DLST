function regressor = train(net, image, loc, opts)
    
    positives = gen_samples('uniform_aspect', loc, opts.numSamplesBBReg*10, ...
        opts.imageSize, opts.scaleFactor, 0.3, 10);  
    positives = positives(BoundingBox.overlap_ratio(positives, loc) > 0.6, :);
    
    num = size(positives, 1);
    sel = randperm(num, min(num, opts.numSamplesBBReg));
    positives = positives(sel, :);
    
    regions = getPatches(image, positives, opts);
    features = Network.forward(net, {regions - 128}, opts, 'feature');
    
    features = permute(gather(features), [4, 3, 1, 2]);
    features = features(:, :);
    labels = repmat(loc, size(positives, 1), 1);
    regressor = BoundingBox.train_bbox_regressor(features, positives, labels); 
end

