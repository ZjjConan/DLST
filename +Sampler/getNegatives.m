function samples = getNegatives(stateType, loc, numNeg, imageSize, scaleFactor, transF, scaleF, threshold, isInit)
    
    if isInit
        samples = [gen_samples('uniform', loc, numNeg, imageSize, scaleFactor, 1, 10);...
                   gen_samples('whole', loc, numNeg, imageSize, scaleFactor, transF, scaleF)];
    else
        samples = gen_samples(stateType, loc, numNeg*2, imageSize, scaleFactor, transF, scaleF);
    end
    
    samples = samples(BoundingBox.overlap_ratio(samples, loc) < threshold, :);
    sel = randperm(size(samples, 1), min(size(samples, 1), numNeg));
    samples = samples(sel, :);
end