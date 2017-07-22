function opts = getDefaultOpts()
    % the created DLST tracker path
    opts.model = 'F:/Research/Track_Community/DLST-MM/models/tracker.mat';
    % whether use gpu or not
    opts.useGpu = true;
    % show tracking and training results
    opts.verbose = false;

    % whether use bb regression or not
    opts.useBBReg = true;
    % the number of bbox used for bbreg
    opts.numSamplesBBReg = 1000;
    
    % the learning rate for tracker
    opts.learningRate = 0.003;
    
    % max iterations in the initial frame
    opts.initMaxIters = 30;
    % the number of positive samples from the initial frame
    opts.initNumPos = 500;
    % the number of negative samples from the initial frame
    opts.initNumNeg = 5000;
    % the threshold for positive samples
    opts.initPosThre = 0.7;
    % the threshold for negative samples
    opts.initNegThre = 0.5;
    
    % max iterations for tracking
    opts.updateMaxIters = 10;
    % the number of positive samples collected online
    opts.updateNumPos = 50;
    % the number of negative samples collected online
    opts.updateNumNeg = 200;
    % the threshold for positive samples for online collection
    opts.updatePosThre = 0.7;
    % the threshold for negative samples for online collection
    opts.updateNegThre = 0.3;
    
    % the long-term period
    opts.updateLongPeriod = 100;
    % the short-term period
    opts.updateShortPeriod = 20;
    % update interval
    opts.updateInterval = 10;
    
    % input image size
    opts.inputSize = 107;
    % crop mode
    opts.cropMode = 'wrap';
    % zero padding 
    opts.cropPadding = 16;
    
    % candidates number
    opts.numCandidates = 256;
    % base scale factor
    opts.scaleFactor = 1.05;
    % translation factor
    opts.transF = 0.6;
    % scale factor
    opts.scaleF = 1;
    
    % the learning batch size for localization network
    opts.locBatchSize = 8;
    % the context ratio used in localization network
    opts.locContext = 4;
    % upsampling ratio
    opts.locTotalStride = 2;
    % the radius that determines where is positives
    opts.locR = 16;
    % label map size for localization network
    opts.labelSize = 51;
    
    % the batch size for classification network
    opts.testBatchSize = 128;
    
    % the learning batch size for classification network 
    opts.clfBatchSize = 128;
    % the positive samples for each batch
    opts.clfBatchPos = 32;
    % the negative samples for each batch
    opts.clfBatchNeg = 96;
end
