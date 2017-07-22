function DLST_VOT16
% DLST VOT integration example

    cleanup = onCleanup(@() exit() );
    
    setupDLST();
try    
    
    RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock))); % Set random seed to a different value every time as required by the VOT rules.
    
    [images, region] = vot_initialize();
    
    % If the provided region is a polygon ...
    if numel(region) > 4
        % Init with an axis aligned bounding box with correct area and center
        % coordinate
        cx = mean(region(1:2:end));
        cy = mean(region(2:2:end));
        x1 = min(region(1:2:end));
        x2 = max(region(1:2:end));
        y1 = min(region(2:2:end));
        y2 = max(region(2:2:end));
        A1 = norm(region(1:2) - region(3:4)) * norm(region(3:4) - region(5:6));
        A2 = (x2 - x1) * (y2 - y1);
        s = sqrt(A1/A2);
        w = s * (x2 - x1) + 1;
        h = s * (y2 - y1) + 1;
    else
        cx = region(1) + (region(3) - 1)/2;
        cy = region(2) + (region(4) - 1)/2;
        w = region(3);
        h = region(4);
    end
    region = double([cx - w/2, cy - h/2, w, h]);
    [trkResults, ~, ~] = DLST.process(images, region);

    results = cell(length(images), 1);
    for i = 1:numel(results)
        results{i} = round(trkResults(i, :));
    end
    
    vot_quit(results);
    
catch err
    [wrapper_pathstr, ~, ~] = fileparts(mfilename('fullpath'));
    cd_ind = strfind(wrapper_pathstr, filesep());
    VOT_path = wrapper_pathstr(1:cd_ind(end));
    
    error_report_path = [VOT_path '/error_reports/'];
    if ~exist(error_report_path, 'dir')
        mkdir(error_report_path);
    end
    
    report_file_name = [error_report_path tracker_name '_' runfile_name datestr(now,'_yymmdd_HHMM') '.mat'];
    
    save(report_file_name, 'err')
    
    rethrow(err);
end