opts.CNNModel = 'D:\CNNModel\imagenet-vgg-m.mat';
opts.saveDir = 'models\';

opts.removedLayerName = 'pool1';
locNet = Network.createLocalizationNet(opts);

opts.removedLayerName = 'conv4';
clfNet = Network.createClassifierNet(opts);

save([opts.saveDir 'tracker.mat'], 'locNet', 'clfNet');


