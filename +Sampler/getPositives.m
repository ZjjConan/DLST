function samples = getPositives(stateType, loc, numPos, imageSize, scaleFactor, transF, scaleF, threshold)
   
    samples = gen_samples(stateType, loc, numPos*2, imageSize, scaleFactor, transF, scaleF);
    samples = samples(BoundingBox.overlap_ratio(samples, loc) > threshold, :);
    sel = randperm(size(samples, 1), min(size(samples, 1), numPos));
    samples = samples(sel, :);
end

