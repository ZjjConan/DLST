function [videos, loadVideoFunc] = loadVideoInfo(dataset, datapath)


%%    
    if strcmpi(dataset, 'OTB50')
        videos = Utility.getOTB50Videos();
        loadVideoFunc = @Utility.loadOTBInfo;
    elseif strcmpi(dataset, 'OTB100')
        videos = Utility.getOTB100Videos();
        loadVideoFunc = @Utility.loadOTBInfo;
    elseif strcmpi(dataset, 'OTB13')
        videos = Utility.getOTB13Videos();
        loadVideoFunc = @Utility.loadOTBInfo;
    elseif strcmpi(dataset, 'VOT')
        videos = Utility.getVOTVideos(datapath);
        loadVideoFunc = @Utility.loadVOTInfo; 
    elseif strcmpi(dataset, 'Hard')
        videos = Utility.getHardVideos();
        loadVideoFunc = @Utility.loadOTBInfo;
    elseif strcmpi(dataset, 'Supp')
        videos = Utility.getSuppVideos();
        loadVideoFunc = @Utility.loadOTBInfo;
    else
        videos = Utility.getOTBVideosAtt(dataset);
        loadVideoFunc = @Utility.loadOTBInfo;
    end

end

