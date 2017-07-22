function net = DropOut(net, lName, inName, rate)
    if nargin < 4, rate = 0.5; end
    net.addLayer(lName, dagnn.DropOut('rate', rate), inName, lName);
end

