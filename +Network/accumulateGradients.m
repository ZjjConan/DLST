function state = accumulateGradients(net, state, params, batchSize, parserv)
% code from 'matconvnet' toolbox
    for p=1:numel(net.params)
        if ~isempty(parserv)
            parDer = parserv.pullWithIndex(p) ;
        else
            parDer = net.params(p).der ;
        end

        switch net.params(p).trainMethod

            case 'average' % mainly for batch normalization
                thisLR = net.params(p).learningRate ;
                net.params(p).value = vl_taccum(...
                    1 - thisLR, net.params(p).value, ...
                    (thisLR/batchSize/net.params(p).fanout),  parDer) ;

            case 'gradient'
                thisDecay = params.weightDecay * net.params(p).weightDecay ;
                thisLR = params.learningRate * net.params(p).learningRate ;

                if isempty(state.solverState{p})
                    state.solverState{p} = zeros(size(parDer), 'like', parDer);
                end

                state.solverState{p} = vl_taccum(...
                    params.momentum, state.solverState{p}, ...
                    - (1 / batchSize), parDer) ;
                net.params(p).value = vl_taccum(...
                        (1 - thisLR * thisDecay / (1 - params.momentum)),  ...
                        net.params(p).value, ...
                        thisLR, state.solverState{p}) ;
           
            otherwise
                error('Unknown training method ''%s'' for parameter ''%s''.', ...
                    net.params(p).trainMethod, ...
                    net.params(p).name) ;
        end
    end
end