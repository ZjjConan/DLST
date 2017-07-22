function outputs = forward(net, inputs, opts, stage)
    
    if strcmpi(stage, 'feature')
        oIndex = net.getVarIndex(net.getOutputs);
    elseif strcmpi(stage, 'prediction')
        oIndex = net.getVarIndex('prediction');
    else
        error('stage should be: feature or prediction');
    end
    net.mode = 'test';
    nums = size(inputs{1}, 4);
    numBatches = ceil(nums / opts.testBatchSize);
    for i = 1:numBatches
        bstart = opts.testBatchSize * (i-1) + 1;
        bend = min(nums, opts.testBatchSize * i);
        
        netInputs = Network.getBatchInputs(inputs, bstart:bend);
        if opts.useGpu
            for j = 1:numel(inputs)
                netInputs{2*j} = gpuArray(netInputs{2*j});
            end
        end

        net.eval(netInputs);
   
        feat = gather(net.vars(oIndex).value);
        if ~exist('outputs', 'var')
            [rows, cols, dims, ~] = size(feat);
            outputs = zeros(rows, cols, dims, nums, 'single');
        end
        outputs(:, :, :, bstart:bend) = feat;
    end
end
