function [net, state] = trainLNet(net, state, features, labels, instanceWeights, varargin)

    opts.verbose = false;
    opts.useGpu = true;
    opts.maxIters = 30;
    opts.learningRate = 0.001;
    opts.weightDecay = 0.0005 ;
    opts.momentum = 0.9 ;
    opts.batchSize = 4;
    
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
    
    
    perms = Network.prepareTrainDataList(0, size(features, 4), opts.batchSize, opts.maxIters);

    % objective fuction
    loss = zeros(1, opts.maxIters);
    net.mode = 'normal';
    lIndex = net.getLayerIndex('loss');
    oIndex = net.getVarIndex('loss');
    labIndex = net.getVarIndex('label');
    for it = 1:opts.maxIters
        excuTime = tic ;
       
        batch = perms((it-1) * opts.batchSize+1 : it*opts.batchSize);
        batchFeats = features(:,:,:,batch);
        batchLabels = labels(:,:,:,batch);
        batchInstanceWeights = instanceWeights(:,:,:,batch);
        
        if opts.useGpu
            batchFeats = gpuArray(batchFeats);
            batchInstanceWeights = gpuArray(batchInstanceWeights);
        end
        net.layers(lIndex).block.opts = {'instanceWeights', batchInstanceWeights};
        inputs = {'data_stream_1', batchFeats, 'label', batchLabels};
        net.eval(inputs, {'loss', one});
        net.layers(lIndex).block.opts = {};
        net.vars(labIndex).value = [];
    
        state = Network.accumulateGradients(net, state, opts, numel(batch), []);

        loss(it) = gather(net.vars(oIndex).value)/numel(batch);
        excuTime = toc(excuTime);
        if opts.verbose
            fprintf('network training batch %3d of %3d ---- loss %.3f, %.3fs\n', ...
                it, opts.maxIters, mean(loss(1:it)), excuTime) ;
        end
    end

end

