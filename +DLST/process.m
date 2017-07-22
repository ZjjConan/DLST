function [res, fps] = process(imgFiles, groundTruths, opts)    
    numFrames = numel(imgFiles);
    
    res = zeros(numFrames, 4);
    res(1, :) = groundTruths(1, :);
        
    % override image size
    image = readImage(imgFiles{1});
    opts.imageSize = size(image);
     
    % load network
    [lnet, cnet] = DLST.loadNet(opts);
    
    if opts.useGpu
        lnet.feat.move('gpu');
        lnet.trac.move('gpu');
        cnet.feat.move('gpu');
        cnet.trac.move('gpu');
    end
    
    if opts.useBBReg
        regressor = BoundingBox.train(cnet.feat, image, res(1, :), opts);
    end
    
%    avgImg = @(x, y) bsxfun(@minus, x, y); 
    
    % process clfNet
    positives = Sampler.getPositives('gaussian', res(1, :), opts.initNumPos, opts.imageSize, ...
                                     opts.scaleFactor, 0.1, 5, opts.initPosThre);
    negatives = Sampler.getNegatives('none', res(1, :), opts.initNumNeg, opts.imageSize, ...
                                     opts.scaleFactor, 1, 10, opts.initNegThre, true); ...
                                 
    samples = [positives; negatives];
    
    posIndex = 1:size(positives, 1);
    negIndex = (1:size(negatives,1)) + size(positives,1);
    
    regions = getPatches(image, samples, opts);
    features = Network.forward(cnet.feat, {regions - 128}, opts, 'feature');
    posFeats = features(:, :, :, posIndex);
    negFeats = features(:, :, :, negIndex);
    
    cnet.trac = Network.trainCNet(cnet.trac, [], {posFeats}, {negFeats}, opts,...
                                  'maxIters', opts.initMaxIters, ...
                                  'learningRate', opts.learningRate);
    
    % process locNet
    [regions, labels, instanceWeights] = getSearchRegions(image, positives(1:10:end, :), opts);
    cosWindow = single(hann(opts.labelSize) * hann(opts.labelSize)');
    features = Network.forward(lnet.feat, {regions - 128}, opts, 'feature');
    features = bsxfun(@times, features, cosWindow);
    lnet.trac = Network.trainLNet(lnet.trac, [], features, ....
                                  labels, instanceWeights, opts, ...
                                  'maxIters', opts.initMaxIters, ...
                                  'learningRate', opts.learningRate, ...
                                  'batchSize', opts.locBatchSize);
     
    % for locNet
    lnetFeats = cell(numFrames, 1);
    lnetLabel = cell(numFrames, 1);
    lnetInstW = cell(numFrames, 1);
    lnetFeats{1} = features;
    lnetLabel{1} = labels;
    lnetInstW{1} = instanceWeights;
    
    if opts.verbose
        im = double(image)/255;
        fig_handle = figure('Name', 'Tracking');
        imagesc(im);
        hold on;
        rectangle('Position', res(1, :), 'EdgeColor', 'r', 'LineWidth', 2);
        text(10, 10, int2str(1), 'color', [0 1 1]);
        hold off;
        axis off;
%         axis image;
%         set(gca, 'Units', 'normalized', 'Position', [0 0 1 1])
    end    
    
    % collect feature
    cnetPos = cell(numFrames, 1);
    cnetNeg = cell(numFrames, 1);
    
    negatives = Sampler.getNegatives('uniform', res(1, :), opts.updateNumNeg, opts.imageSize, ...
                                     opts.scaleFactor, 2, 5, opts.initNegThre, false);
    regions = getPatches(image, negatives, opts);
    features = Network.forward(cnet.feat, {regions - 128}, opts, 'feature');
    
    cnetPos{1} = posFeats;
    cnetNeg{1} = features;
    
    success = 1;
    transF = opts.transF;
    scaleF = opts.scaleF;
 
    % do work
    trkPos = res(1, :);
    time = 0;
    for frame = 2:numFrames; 
        image = readImage(imgFiles{frame});

        excuTime = tic;
        
        [region, alignedSample, cropInfo] = getSingleSearchRegion(image, trkPos, opts);
        feature = Network.forward(lnet.feat, {region - 128}, opts, 'feature');
        feature = bsxfun(@times, feature, cosWindow);
        locResponse = Network.forward(lnet.trac, {feature}, opts, 'prediction');
        locResponse = squeeze(locResponse(:,:,2));
        responseUp = cv.resize(locResponse, [opts.labelSize opts.labelSize]*2, 'Interpolation', 'Cubic');
            
        maxVal = max(responseUp(:));
        if maxVal > 0
            [maxr, maxc] = find(responseUp == max(responseUp(:)), 1);
            trans = [maxr maxc] - round(opts.labelSize*2) / 2;
            locPos = [trans(2) * opts.locTotalStride/2 + alignedSample(1), ...
                      trans(1) * opts.locTotalStride/2 + alignedSample(2), ...
                      alignedSample(3:4)];
            locPos = getAlignedBBoxBack(locPos, cropInfo);
        else
            locPos = trkPos;
        end

        samples = [gen_samples('gaussian', trkPos, round(opts.numCandidates/2), ...
                               opts.imageSize, opts.scaleFactor, transF, scaleF);
                   gen_samples('gaussian', locPos, round(opts.numCandidates/2), ...
                               opts.imageSize, opts.scaleFactor, opts.transF, opts.scaleF)];                   
        
        regions = getPatches(image, samples, opts);
        features = Network.forward(cnet.feat, {regions - 128}, opts, 'feature');
        response = Network.forward(cnet.trac, {features}, opts, 'prediction');
        response = squeeze(response(:,:,2,:));

        [scores, idx] = sort(response, 'descend');
        trkScore = mean(scores(1:5));
        trkPos = mean(samples(idx(1:5), :), 1);
        res(frame, :) = trkPos;
    
        if(trkScore < 0)
            transF = min(1.5, 1.1*transF);
        else
            transF = opts.transF;
        end
    
        % bbox regression
        if (opts.useBBReg && trkScore > 0)
            res(frame, :) = BoundingBox.predict(regressor, features(:,:,:,idx(1:5)), samples(idx(1:5), :));
        end
        
        % collect data
        if (trkScore > 0 || frame <= 3)
            % for clfNet
            positives = Sampler.getPositives('gaussian', res(frame, :), opts.updateNumPos, opts.imageSize, ...
                                             opts.scaleFactor, 0.1, 5, opts.updatePosThre);
            negatives = Sampler.getNegatives('uniform', res(frame, :), opts.updateNumNeg, opts.imageSize, ...
                                             opts.scaleFactor, 2,   5, opts.updateNegThre, false);
            
            posIndex = 1:size(positives, 1);
            negIndex = (1:size(negatives,1)) + size(positives,1);
            samples = [positives; negatives];
            
            regions = getPatches(image, samples, opts);
            features = Network.forward(cnet.feat, {regions - 128}, opts, 'feature');
            cnetPos{frame} = features(:, :, :, posIndex);
            cnetNeg{frame} = features(:, :, :, negIndex);

            % for locNet
            [regions, labels, instanceWeights] = getSearchRegions(image, positives(1:10:end, :), opts);
            features = Network.forward(lnet.feat, {regions - 128}, opts, 'feature');
            features = bsxfun(@times, features, cosWindow);
            lnetFeats{frame} = features;
            lnetLabel{frame} = labels;
            lnetInstW{frame} = instanceWeights;
            
            success = [success, frame];
            if(numel(success) > opts.updateLongPeriod)
                range = success(end - opts.updateLongPeriod);
                cnetPos{range} = single([]);
                lnetFeats{range} = single([]);
                lnetLabel{range} = single([]);
                lnetInstW{range} = single([]);   
            end
            
            if(numel(success) > opts.updateShortPeriod)
                cnetNeg{success(end - opts.updateShortPeriod)} = single([]);
            end
        else
           cnetPos{frame} = single([]);
           cnetNeg{frame} = single([]);
           lnetFeats{frame} = single([]);
           lnetLabel{frame} = single([]);
           lnetInstW{frame} = single([]);  
        end
    
        % Network update
        if ((mod(frame, opts.updateInterval) == 0 || trkScore < 0) && frame ~= numFrames)
            numSucess = numel(success);
            if (trkScore < 0) % short-term update
                range = success(max(1, numSucess - opts.updateShortPeriod+1) : numSucess);
            else % long-term update
                range = success(max(1, numSucess - opts.updateLongPeriod+1) : numSucess);
            end
            posFeats = cat(4, cnetPos{range});
            negFeats = cat(4, cnetNeg{success(max(1, end - opts.updateShortPeriod+1):end)});
        
            cnet.trac = Network.trainCNet(cnet.trac, [], {posFeats}, {negFeats}, opts, ...
                                          'maxIters', opts.updateMaxIters, ...
                                          'learningRate', opts.learningRate);
            
            features = cat(4, lnetFeats{range});
            labels = cat(4, lnetLabel{range});
            instanceWeights = cat(4, lnetInstW{range});
            lnet.trac = Network.trainLNet(lnet.trac, [], features, labels, instanceWeights, opts, ...
                                          'maxIters', opts.updateMaxIters, ...
                                          'learningRate', opts.learningRate);
        end
        excuTime = toc(excuTime);
        time = time + excuTime;
    
        % show result
        if opts.verbose
            im = double(image) / 255;
            imagesc(im);
            hold on;
            rectangle('Position', trkPos, 'EdgeColor', 'r',  'LineWidth', 2);
            text(10, 10, int2str(frame), 'color', [0 1 1]);
            hold off;
            drawnow;
        end
    end
    fps = (numFrames-1) / time;
                                                       
    if opts.useGpu
        lnet.feat.move('cpu');
        lnet.trac.move('cpu');
        cnet.feat.move('cpu');
        cnet.trac.move('cpu');
    end
end