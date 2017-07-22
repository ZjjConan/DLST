function cfg = loadOTBInfo(base_path, video)
%LOAD_VIDEO_INFO
%   Loads all the relevant information for the video in the given path:
%   the list of image files (cell array of strings), initial position
%   (1x2), target size (1x2), the ground truth information for precision
%   calculations (Nx2, for N frames), and the path where the images are
%   located. The ordering of coordinates and sizes is always [y, x].
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/


	%see if there's a suffix, specifying one of multiple targets, for
	%example the dot and number in 'Jogging.1' or 'Jogging.2'.
	if numel(video) >= 2 && video(end-1) == '-' && ~isnan(str2double(video(end))),
		suffix = video(end-1:end);  %remember the suffix
		video = video(1:end-2);  %remove it from the video name
    elseif strcmpi(video, 'Human4')
        suffix = '-2';
	else
		suffix = '';
	end

	%full path to the video's files
	if base_path(end) ~= '/' && base_path(end) ~= '\',
		base_path(end+1) = '/';
	end
	video_path = [base_path video '/'];
	%try to load ground truth from text file (Benchmark's format)
	filename = [video_path 'groundtruth_rect' suffix '.txt'];
	f = fopen(filename);
	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
	
	%the format is [x, y, width, height]
	try
		ground_truth = textscan(f, '%f,%f,%f,%f', 'ReturnOnError',false);  
	catch  %#ok, try different format (no commas)
		frewind(f);
		ground_truth = textscan(f, '%f %f %f %f');  
	end
	ground_truth = cat(2, ground_truth{:});
	fclose(f);

	
    cfg.att = load([video_path 'cfg.mat']);
    cfg.att = cfg.att.seq;
	
	%from now on, work in the subfolder where all the images are
	video_path = [video_path 'img/'];

	%for these sequences, we must limit ourselves to a range of frames.
	%for all others, we just load all png/jpg files in the folder.
	frames = {'David', 300, 770;
			  'Football1', 1, 74;
			  'Freeman3', 1, 460;
			  'Freeman4', 1, 283;
              'Tiger1', 6, 354
              'Diving', 1, 215};
	if strcmpi(video, 'David')
        cfg.startFrame = 300;
        cfg.annoBegin = 1;
    elseif strcmpi(video, 'Tiger1')
        cfg.startFrame = 6;
        cfg.annoBegin = 1;
        ground_truth = ground_truth(6:end, :);
    else
        cfg.startFrame = 1;
        cfg.annoBegin = 1;
    end
          
          
	idx = find(strcmpi(video, frames(:,1)));
	
	if isempty(idx),
		%general case, just list all images
		img_files = dir([video_path '*.png']);
		if isempty(img_files),
			img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.')
		end
		img_files = sort({img_files.name});
	else
		%list specified frames. try png first, then jpg.
		if exist(sprintf('%s%04i.png', video_path, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.png');
		elseif exist(sprintf('%s%04i.jpg', video_path, frames{idx,2}), 'file'),
			img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.jpg');
		else
			error('No image files to load.')
		end
		
		img_files = cellstr(img_files);
    end
    %eliminate frame 0 if it exists, since frames should only start at 1
	img_files(strcmp('00000000.jpg', img_files)) = [];
    img_files = strcat(video_path, img_files);

    cfg.img_files = img_files;
    cfg.ground_truth = ground_truth;

end

