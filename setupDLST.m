function setupDLST()

	% setup MatConvNet
	addpath('D:/Libraries/matconvnet/matlab');
	addpath('D:/Libraries/matconvnet/matlab/mex/') ;
	addpath('D:/Libraries/matconvnet/matlab/simplenn/') ;
	addpath('D:/Libraries/matconvnet/examples/');
	addpath('D:/Libraries/matconvnet/examples/imagenet');
	    
	% setup OpenCV matlab
	addpath('D:/Libraries/mexopencv/');

	% add current path for VOT2016 integration
	root = fileparts(fileparts(mfilename('fullpath'))) ;
	addpath(fullfile(root, 'DLST')) ;

	% add local path
	addpath(fullfile(root, 'DLST/utils/'));

end
