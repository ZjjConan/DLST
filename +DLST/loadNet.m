function [lnet, cnet] = loadNet(opts)    
    net = load(opts.model);
    
    % adjust learning rate
    locNet = dagnn.DagNN.loadobj(net.locNet);
    f = locNet.getParamIndex('predictionf');
    b = locNet.getParamIndex('predictionb');
    locNet.params(f).learningRate = 10;
    locNet.params(b).learningRate = 20;
    
    clfNet = dagnn.DagNN.loadobj(net.clfNet);
    f = clfNet.getParamIndex('prediction_avgf');
    b = clfNet.getParamIndex('prediction_avgb');
    if ~isnan(f)
        clfNet.params(f).learningRate = 10;
    end
    if ~isnan(b)
        clfNet.params(b).learningRate = 20;
    end
    
    % setting for loc-net
    vIndex = locNet.getVarIndex('extra_conv1');
    locNet.vars(vIndex-1).precious = 1;
    vIndex = locNet.getVarIndex('prediction');
    locNet.vars(vIndex).precious = 1;
    vIndex = locNet.getVarIndex('loss');
    locNet.vars(vIndex).precious = 1;
     
    % setting for clf-net
    vIndex = clfNet.getVarIndex('extra_conv1');
    clfNet.vars(vIndex-1).precious = 1;
    vIndex = clfNet.getVarIndex('prediction');
    clfNet.vars(vIndex).precious = 1;
    vIndex = clfNet.getVarIndex('loss');
    clfNet.vars(vIndex).precious = 1;
        
    [locCNet, locFNet] = splitNet(locNet, 'extra_conv1');
    [clfCNet, clfFNet] = splitNet(clfNet, 'extra_conv1');
    
    locCNet.setLayerInputs('conv1', {'data_stream_1'});
    clfCNet.setLayerInputs('conv1', {'data_stream_1'});
    locFNet.setLayerInputs('extra_conv1', {'data_stream_1'});
    clfFNet.setLayerInputs('extra_conv1', {'data_stream_1'});
   
    lnet.feat = locCNet;
    cnet.feat = clfCNet;
    lnet.trac = locFNet;
    cnet.trac = clfFNet;
      
    lnet.feat.mode = 'test';
    cnet.feat.mode = 'test';
end

function [net1, net2] = splitNet(net, splitLayer)
    net1 = net.copy();
    net2 = net.copy();
    removedIndex = net1.getLayerIndex(splitLayer);
    layers = {net1.layers.name};    
    net1.removeLayer(layers(removedIndex:end));
    net2.removeLayer(layers(1:removedIndex-1));
end

