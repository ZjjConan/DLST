function net = createClassifierNet(opts)
    prenet = vl_simplenn_tidy(load(opts.CNNModel));
    
    % changing the padding in MDNet
    for i = 1:numel(prenet.layers)
        if strcmpi(prenet.layers{i}.name, 'conv4')
            break;
        end
        if strcmpi(prenet.layers{i}.type, 'conv') || ...
           strcmpi(prenet.layers{i}.type, 'pool')
            prenet.layers{i}.pad = 0;
        end
    end
    
    % init conv layers
    net.layers = {};
    for i = 1:numel(prenet.layers)
        l = prenet.layers{i};
        if strcmpi(l.name, opts.removedLayerName)
            break;
        end
        net.layers{end+1} = l;
    end
    
    % convert into dagnn
    net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;
  
    ILayer.Conv(net, 'extra_conv1', net.getOutputs, [1 1 512 512], 0, 1, [1 2], [1 0], true);
    ILayer.ReLU(net, 'extra_relu1', {'extra_conv1'});
    ILayer.DropOut(net, 'extra_drop1', {'extra_relu1'});
    
    ILayer.Conv(net, 'extra_conv2', 'extra_drop1', [1 1 512 128], 0, 1, [1 2], [1 0], true);  
    ILayer.ReLU(net, 'extra_relu2', {'extra_conv2'});
    ILayer.DropOut(net, 'extra_drop2', {'extra_relu2'});
    
    ILayer.Conv(net, 'prediction_avg', {'extra_drop2'}, [1 1 128 2], 0, 1, [1 2], [1 0], true);
    ILayer.Pool(net, 'prediction', net.getOutputs, [3 3], 0, 1, 'avg');   
    ILayer.Loss(net, 'loss', {'prediction', 'label'}, 'softmaxlog');
end
