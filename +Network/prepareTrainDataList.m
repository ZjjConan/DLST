function trainPerms = prepareTrainDataList(perms, nums, batch, maxIters)
    trainPerms = [];
    remain = batch * maxIters;
    while(remain > 0)
        if(perms == 0)
            trainList = randperm(nums)';
        end
        trainPerms = cat(1, trainPerms, trainList(perms+1 : min(end, perms+remain)));
        perms = min(length(trainList), perms + remain);
        perms = mod(perms, length(trainList));
        remain = batch * maxIters - length(trainPerms);
    end
end