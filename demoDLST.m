clear all; clc; close all;

setupDLST;

% get tracking options
trackOpts = getDefaultOpts();

% override to show the tracking results
trackOpts.verbose = true;

% get image files and ground truth
cfg = loadOTBInfo('data/', 'Biker');

% do tracking
[res, fps] = DLST.process(cfg.img_files, cfg.ground_truth, trackOpts);