function net = ReLU(net, lName, inName)
    net.addLayer(lName, dagnn.ReLU, inName, lName);
end