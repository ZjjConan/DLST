function net = Loss(net, lName, inName, lossType)
    net.addLayer(lName, dagnn.Loss('loss', lossType), inName, lName);
end