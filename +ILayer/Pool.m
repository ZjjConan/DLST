function net = Pool(net, lName, inName, shape, pad, stride, method)
    block = dagnn.Pooling('method', method, 'poolSize', shape, 'pad', pad, 'stride', stride);
    net.addLayer(lName, block, inName, lName);
end