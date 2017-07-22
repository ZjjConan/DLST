function net = Conv(net, lName, inName, shape, pad, stride, lr, wd, init)
    block = dagnn.Conv('size', shape, 'hasBias', true, 'pad', pad, 'stride', stride);
    net.addLayer(lName, block, inName, lName, {[lName 'f'], [lName 'b']});
    
    if numel(lr) == 1
        lr_f = lr;
        lr_b = lr;
    else
        lr_f = lr(1);
        lr_b = lr(2);
    end
    
    if numel(wd) == 1
        wd_f = wd;
        wd_b = wd;
    else
        wd_f = wd(1);
        wd_b = wd(2);
    end
    
    if nargin == 9 && init == true
        net.params(end-1).value = randn(shape, 'single') * 0.01 ;
        net.params(end).value = zeros(shape(4), 1, 'single') ;
    end
    
    net.params(end-1).learningRate = lr_f;
    net.params(end).learningRate = lr_b;
    net.params(end-1).weightDecay = wd_f;
    net.params(end).weightDecay = wd_b;
    
end