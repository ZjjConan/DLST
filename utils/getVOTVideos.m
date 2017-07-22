function seqNames = getVOTVideos(datapath)  
    dirs = dir(datapath);
    seqNames = {dirs.name};
    seqNames(1:2) = [];
    seqNames(strcmpi(seqNames, 'list.txt')) = [];
end

