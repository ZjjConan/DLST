function [net, state] = trainCNet(net, state, positives, negatives, varargin)

    opts.useHOG = false;
    opts.verbose = false;
    opts.useGpu = true;
    opts.conserveMemory = true ;

    opts.maxIters = 30;
    opts.learningRate = 0.001;
    opts.weightDecay = 0.0005 ;
    opts.momentum = 0.9 ;
    
    opts.hnmBatchSize = 1024;

    opts.batchSize = 128;
    opts.batchPos = 32;
    opts.batchNeg = 96;
    
    opts = vl_argparse_dlst(opts, varargin) ;
    opts.solver = [];
    if isempty(state) || isempty(state.solverState)
        state.solverState = cell(1, numel(net.params)) ;
    end
    
    if opts.useGpu
        one = gpuArray(single(1)) ;
    else
        one = single(1) ;
    end
    
    numFeatBlock = numel(positives);
    
    numPos = size(positives{1}, 4);
    numNeg = size(negatives{1}, 4);

    trainPosPerms = Network.prepareTrainDataList(0, numPos, opts.batchPos*8, opts.maxIters);
    trainNegPerms = Network.prepareTrainDataList(0, numNeg, opts.hnmBatchSize, opts.maxIters);
    
    loss = zeros(1, opts.maxIters);
    pvarIndex = net.getVarIndex('prediction');
    lvarIndex = net.getVarIndex('loss');
    for it = 1:opts.maxIters
        excuTime = tic ;
        
        % hard negative selection
        bstart = (it - 1) * opts.hnmBatchSize + 1;
        bend = it * opts.hnmBatchSize;
        batch = trainNegPerms(bstart:bend);
        batchInputs = Network.getBatchInputs(negatives, batch);
        batchLabel = ones(opts.hnmBatchSize, 1, 'single');
        if opts.useGpu
            for i = 1:numFeatBlock
                batchInputs{2*i} = gpuArray(batchInputs{2*i});
            end
        end
        
        batchInputs = cat(2, batchInputs, {'label', batchLabel});
        net.mode = 'test';
        net.eval(batchInputs);
        scores = squeeze(gather(net.vars(pvarIndex).value(:,:,2,:)));
        [scores, index] = sort(scores, 'descend');
        index = batch(index(1:opts.batchNeg));
        negInputs = Network.getBatchInputs(negatives, index);
        
        
        bstart = (it-1) * opts.batchPos + 1;
        bend = it * opts.batchPos;
        posInputs = Network.getBatchInputs(positives, trainPosPerms(bstart:bend));
       
        batchInputs = posInputs;
        for i = 1:numFeatBlock
            batchInputs{2*i} = cat(4, batchInputs{2*i}, negInputs{2*i});
            if opts.useGpu
                batchInputs{2*i} = gpuArray(batchInputs{2*i});
            end
        end
        
        batchLabel = [2*ones(opts.batchPos, 1, 'single'); ones(opts.batchNeg, 1, 'single')];
        batchInputs = cat(2, batchInputs, {'label', batchLabel});
 
        net.mode = 'normal';
        net.eval(batchInputs, {'loss', one});

        state = Network.accumulateGradients(net, state, opts, numel(batchLabel), []);

        loss(it) = gather(net.vars(lvarIndex).value)/numel(batchLabel);
        excuTime = toc(excuTime);
        if opts.verbose
            fprintf('network training batch %3d of %3d ---- loss %.3f, %.3fs\n', ...
                it, opts.maxIters, mean(loss(1:it)), excuTime) ;
        end
    end
end